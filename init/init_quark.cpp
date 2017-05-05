/*
   Copyright (c) 2016, The Linux Foundation. All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

#include "init_apq8084.h"

__attribute__ ((weak))
void init_target_properties()
{
}

static int read_file2(const char *fname, char *data, int max_size)
{
    int fd, rc;

    if (max_size < 1)
        return 0;

    fd = open(fname, O_RDONLY);
    if (fd < 0) {
        ERROR("failed to open '%s'\n", fname);
        return 0;
    }

    rc = read(fd, data, max_size - 1);
    if ((rc > 0) && (rc < max_size))
        data[rc] = '\0';
    else
        data[0] = '\0';
    close(fd);

    return 1;
}

static void init_alarm_boot_properties()
{
    char const *alarm_file = "/proc/sys/kernel/boot_reason";
    char buf[64];

    if (read_file2(alarm_file, buf, sizeof(buf))) {
        /*
         * Setup ro.alarm_boot value to true when it is RTC triggered boot up
         * For existing PMIC chips, the following mapping applies
         * for the value of boot_reason:
         *
         * 0 -> unknown
         * 1 -> hard reset
         * 2 -> sudden momentary power loss (SMPL)
         * 3 -> real time clock (RTC)
         * 4 -> DC charger inserted
         * 5 -> USB charger insertd
         * 6 -> PON1 pin toggled (for secondary PMICs)
         * 7 -> CBLPWR_N pin toggled (for external power supply)
         * 8 -> KPDPWR_N pin toggled (power key pressed)
         */
        if (buf[0] == '3')
            property_set("ro.alarm_boot", "true");
        else
            property_set("ro.alarm_boot", "false");
    }
}

void vendor_load_properties()
{
    std::string platform;
    std::string sku;
    std::string carrier;
    std::string fsgid;
    std::string radio;
    std::string cid;
    std::string camera_enable_vpu;


    init_target_properties();
    init_alarm_boot_properties();

    platform = property_get("ro.board.platform");
    if (platform != ANDROID_TARGET)
        return;

    // Multi device support, list of known radios, cid and fsgid:
    // Radio: XT1225 Retail  = 0x5
    // Radio: XT1250 America = 0x4
    // Radio: XT1254 Verizon = 0x4
    // Cid:   XT1225 Retail  = 0xC
    // Cid:   XT1250 America = 0x9
    // Cid:   XT1254 Verizon = 0x2 and 0x0
    // Fsgid: XT1225 Retail  = singlela (latino america), emea (euro and india)
    // Fsgid: XT1250 America = lra (america for verizon), lra_gsm (america for gsm network)
    // Fsgid: XT1254 Verizon = verizon (america verizon), verizon_gsm (america for gsm network)

    fsgid = property_get("ro.boot.fsg-id");
    carrier = property_get("ro.boot.carrier");
    sku = property_get("ro.boot.hardware.sku");
    radio = property_get("ro.boot.radio");
    cid = property_get("ro.boot.cid");

    if (fsgid != "emea" && fsgid != "singlela" && fsgid != "lra" && fsgid != "lra_gsm" && fsgid != "verizon" && fsgid != "verizon_gsm") {
        if (sku == "XT1225" || (radio == "0x5" && cid == "0xC")) {
            if (carrier == "reteu") {
                fsgid = "emea";
            } else {
                fsgid = "singlela";
            }
        } else if (sku == "XT1250" || (radio == "0x4" && cid == "0x9")) {
            fsgid = "lra";
        } else if (sku == "XT1254" || (radio == "0x4" && (cid == "0x2" || cid == "0x0"))) {
            fsgid = "verizon";
        }
    }

    if (fsgid =="verizon") {
        // XT1254 - Droid Turbo
        property_set("ro.build.product", "quark");
        property_set("ro.product.device", "quark");
        property_set("ro.product.model", "DROID Turbo");
        property_set("ro.fsg-id", "verizon");
        property_set("ro.telephony.default_network", "10");
        property_set("telephony.lteOnCdmaDevice", "1");
        property_set("ro.build.description", "quark_verizon-user 6.0.1 MCG24.251-5 9 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:6.0.1/MCG24.251-5/9:user/release-keys");
        property_set("ro.telephony.default_cdma_sub", "0");
        property_set("ro.cdma.home.operator.numeric", "311480");
        property_set("ro.cdma.home.operator.alpha", "Verizon");
        property_set("ro.cdma.homesystem", "64,65,76,77,78,79,80,81,82,83");
        property_set("ro.telephony.get_imsi_from_sim", "true");
        property_set("ro.cdma.data_retry_config", "max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000");
        property_set("ro.com.google.clientidbase.ms", "android-verizon");
        property_set("ro.com.google.clientidbase.am", "android-verizon");
        property_set("ro.com.google.clientidbase.yt", "android-verizon");
        INFO("Set properties for \"verizon\"!\n");
    } else if (fsgid =="verizon_gsm") {
        // XT1254 - Droid Turbo, but set as gsm phone
        property_set("ro.build.product", "quark");
        property_set("ro.product.device", "quark");
        property_set("ro.product.model", "DROID Turbo");
        property_set("ro.fsg-id", "verizon");
        property_set("ro.telephony.default_network", "10");
        property_set("telephony.lteOnGsmDevice", "1");
        property_set("ro.gsm.data_retry_config", "default_randomization=2000,max_retries=infinite,1000,1000,80000,125000,485000,905000");
        property_set("ro.com.google.clientidbase.ms", "android-verizon");
        property_set("ro.com.google.clientidbase.am", "android-verizon");
        property_set("ro.com.google.clientidbase.yt", "android-verizon");
        property_set("ro.build.description", "quark_verizon-user 6.0.1 MCG24.251-5 9 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:6.0.1/MCG24.251-5/9:user/release-keys");
        INFO("Set properties for \"verizon_gsm\"!\n");
    } else if (fsgid =="lra") {
        // XT1250 - Moto MAXX
        property_set("ro.build.product", "quark");
        property_set("ro.product.device", "quark");
        property_set("ro.product.model", "Moto MAXX");
        property_set("ro.fsg-id", "lra");
        property_set("ro.telephony.default_network", "10");
        property_set("telephony.lteOnCdmaDevice", "1");
        property_set("ro.build.description", "quark_lra-user 4.4.4 KXG21.50-11 8 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys");
        property_set("ro.telephony.default_cdma_sub", "0");
        property_set("ro.cdma.home.operator.isnan", "1");
        property_set("ro.telephony.get_imsi_from_sim", "true");
        property_set("ro.cdma.data_retry_config", "max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000");
        INFO("Set properties for \"lra\"!\n");
    } else if (fsgid =="lra_gsm") {
        // XT1250 - Moto MAXX, but set as gsm phone
        property_set("ro.build.product", "quark");
        property_set("ro.product.device", "quark");
        property_set("ro.product.model", "Moto MAXX");
        property_set("ro.fsg-id", "lra");
        property_set("ro.telephony.default_network", "9");
        property_set("telephony.lteOnGsmDevice", "1");
        property_set("ro.gsm.data_retry_config", "default_randomization=2000,max_retries=infinite,1000,1000,80000,125000,485000,905000");
	property_set("ro.com.google.clientidbase.ms", "android-motorola");
	property_set("ro.com.google.clientidbase.am", "android-motorola");
	property_set("ro.com.google.clientidbase.yt", "android-motorola");
        property_set("ro.build.description", "quark_lra-user 4.4.4 KXG21.50-11 8 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys");
        INFO("Set properties for \"lra_gsm\"!\n");
    } else if (fsgid =="emea") {
        // XT1225 - Moto Turbo
        property_set("ro.build.product", "quark_umts");
        property_set("ro.product.device", "quark_umts");
        property_set("ro.product.model", "Moto Turbo");
        property_set("ro.telephony.default_network", "9");
        property_set("telephony.lteOnGsmDevice", "1");
        property_set("ro.fsg-id", "emea");
        property_set("ro.gsm.data_retry_config", "default_randomization=2000,max_retries=infinite,1000,1000,80000,125000,485000,905000");
	property_set("ro.com.google.clientidbase.ms", "android-motorola");
	property_set("ro.com.google.clientidbase.am", "android-motorola");
	property_set("ro.com.google.clientidbase.yt", "android-motorola");
        property_set("ro.build.description", "quark_reteu-user 6.0.1 MPG24.107-70.2 2 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_reteu/quark_umts:6.0.1/MPG24.107-70.2/2:user/release-keys");
        INFO("Set properties for \"emea\"!\n");
    } else {
        // XT1225 - Moto MAXX (default)
        property_set("ro.build.product", "quark_umts");
        property_set("ro.product.device", "quark_umts");
        property_set("ro.product.model", "Moto MAXX");
        property_set("ro.telephony.default_network", "9");
        property_set("telephony.lteOnGsmDevice", "1");
        property_set("ro.fsg-id", "singlela");
        property_set("ro.gsm.data_retry_config", "default_randomization=2000,max_retries=infinite,1000,1000,80000,125000,485000,905000");
	property_set("ro.com.google.clientidbase.ms", "android-motorola");
	property_set("ro.com.google.clientidbase.am", "android-motorola");
	property_set("ro.com.google.clientidbase.yt", "android-motorola");
        property_set("ro.build.description", "quark_retbr-user 6.0.1 MPGS24.107-70.2-2 2 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_retbr/quark_umts:6.0.1/MPGS24.107-70.2-2/2:user/release-keys");
        INFO("Set properties for \"singlela\"!\n");
    }
}
