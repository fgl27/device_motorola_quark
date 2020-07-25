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

#include <android-base/properties.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;
using android::base::SetProperty;

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_overrride_triple(char const product_prop[], char const system_prop[], char const vendor_prop[], char const value[])
{
    property_override(product_prop, value);
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

void property_change_base(char const type[], char const device[], char const model[], char const description[], char const fingerprint[], char const clientidbase[])
{
    SetProperty("ro.fsg-id", type);

    property_overrride_triple("ro.product.device", "ro.build.product", "ro.vendor.product.device", device);

    property_override("ro.product.model", model);
    property_override("ro.vendor.product.model", model);

    property_override("ro.build.description", description);

    property_overrride_triple("ro.build.fingerprint", "ro.system.build.fingerprint", "ro.vendor.build.fingerprint", fingerprint);

    SetProperty("ro.com.google.clientidbase.ms", clientidbase);
    SetProperty("ro.com.google.clientidbase.am", clientidbase);
    SetProperty("ro.com.google.clientidbase.yt", clientidbase);
}

void SetProperty_base_gsm(char const type[])
{
    SetProperty("ro.telephony.default_network", type);
    SetProperty("telephony.lteOnGsmDevice", "1");
    SetProperty("ro.gsm.data_retry_config", "default_randomization=2000,max_retries=infinite,1000,1000,80000,125000,485000,905000");
}

void SetProperty_base_cdma()
{
    SetProperty("ro.telephony.default_network", "10");
    SetProperty("telephony.lteOnCdmaDevice", "1");
    SetProperty("ro.telephony.default_cdma_sub", "0");
    SetProperty("ro.telephony.get_imsi_from_sim", "true");
    SetProperty("ro.cdma.data_retry_config", "max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000");
}

static int read_file2(const char *fname, char *data, int max_size)
{
    int fd, rc;

    if (max_size < 1)
        return 0;

    fd = open(fname, O_RDONLY);
    if (fd < 0) return 0;

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
    char const *boot_reason_file = "/proc/sys/kernel/boot_reason";
    char const *power_off_alarm_file = "/persist/alarm/powerOffAlarmSet";
    char boot_reason[64];
    char power_off_alarm[64];
    std::string tmp = GetProperty("ro.boot.alarmboot", "");

    if (read_file2(boot_reason_file, boot_reason, sizeof(boot_reason))
            && read_file2(power_off_alarm_file, power_off_alarm, sizeof(power_off_alarm))) {
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
        if ((boot_reason[0] == '3' || tmp == "true")
                && power_off_alarm[0] == '1')
            SetProperty("ro.alarm_boot", "true");
        else
            SetProperty("ro.alarm_boot", "false");
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

    init_alarm_boot_properties();

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

    fsgid = GetProperty("ro.boot.fsg-id", "");
    carrier = GetProperty("ro.boot.carrier", "");
    sku = GetProperty("ro.boot.hardware.sku", "");
    radio = GetProperty("ro.boot.radio", "");
    cid = GetProperty("ro.boot.cid", "");

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
        property_change_base("verizon", "quark", "DROID Turbo", "quark_verizon-user 6.0.1 MCG24.251-5 9 release-keys", "motorola/quark_verizon/quark:6.0.1/MCG24.251-5/9:user/release-keys", "android-verizon");

        SetProperty_base_cdma();

        SetProperty("ro.cdma.home.operator.numeric", "311480");
        SetProperty("ro.cdma.home.operator.alpha", "Verizon");
        SetProperty("ro.cdma.homesystem", "64,65,76,77,78,79,80,81,82,83");

    } else if (fsgid =="verizon_gsm") {
        // XT1254 - Droid Turbo, but set as gsm phone

        property_change_base("verizon", "quark", "DROID Turbo", "quark_verizon-user 6.0.1 MCG24.251-5 9 release-keys", "motorola/quark_verizon/quark:6.0.1/MCG24.251-5/9:user/release-keys", "android-verizon");

        SetProperty_base_gsm("10");
    } else if (fsgid =="lra") {
        // XT1250 - Moto MAXX

        property_change_base("lra", "quark", "Moto MAXX", "quark_lra-user 4.4.4 KXG21.50-11 8 release-keys", "motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys", "android-motorola");

        SetProperty_base_cdma();

        SetProperty("ro.cdma.home.operator.isnan", "1");
    } else if (fsgid =="lra_gsm") {
        // XT1250 - Moto MAXX, but set as gsm phone

        property_change_base("lra", "quark", "Moto MAXX", "quark_lra-user 4.4.4 KXG21.50-11 8 release-keys", "motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys", "android-motorola");

        SetProperty_base_gsm("9");
    } else if (fsgid =="emea") {
        // XT1225 - Moto Turbo

        property_change_base("emea", "quark_umts", "Moto Turbo", "quark_reteu-user 6.0.1 MPG24.107-70.2 2 release-keys", "motorola/quark_reteu/quark_umts:6.0.1/MPG24.107-70.2/2:user/release-keys", "android-motorola");

        SetProperty_base_gsm("9");
    } else {
        // XT1225 - Moto MAXX (default)

        property_change_base("singlela", "quark_umts", "Moto MAXX", "quark_retbr-user 6.0.1 MPGS24.107-70.2-2 2 release-keys", "motorola/quark_retbr/quark_umts:6.0.1/MPGS24.107-70.2-2/2:user/release-keys", "android-motorola");

        SetProperty_base_gsm("9");
    }
}
