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

#include <stdlib.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

void vendor_load_properties()
{
    std::string platform;
    std::string sku;
    std::string carrier;
    std::string fsgid;
    std::string radio;
    std::string cid;
    std::string camera_enable_vpu;

    platform = property_get("ro.board.platform");
    if (platform != ANDROID_TARGET)
        return;

    // Moto camera app hidden settings "Temporal Noise Reduction" when enable set /data/persist/persist.camera.enable_vpu to 1
    // and that breaks camera support in CM after a reboot, void that during init to prevent camera start bugs
    camera_enable_vpu = property_get("persist.camera.enable_vpu");

    if (camera_enable_vpu == "1")
	property_set("persist.camera.enable_vpu", "0");

    // Multi device support
    fsgid = property_get("ro.boot.fsg-id");
    carrier = property_get("ro.boot.carrier");
    sku = property_get("ro.boot.hardware.sku");
    radio = property_get("ro.boot.radio");
    cid = property_get("ro.boot.cid");

    if (fsgid != "emea" && fsgid != "singlela" && fsgid != "lra" && fsgid != "lra_gsm" && fsgid != "verizon" && fsgid != "verizon_gsm") {
        if (sku == "XT1225") {
            if (carrier == "reteu") {
                fsgid = "emea";
            } else {
                fsgid = "singlela";
            }
        } else if (sku == "XT1250") {
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
        property_set("ro.build.description", "quark_verizon-user 5.1 SU4TL-44 44 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:5.1/SU4TL-44/44:user/release-keys");
        property_set("ro.telephony.default_cdma_sub", "0");
        property_set("ro.cdma.home.operator.numeric", "311480");
        property_set("ro.cdma.home.operator.alpha", "Verizon");
        property_set("ro.cdma.homesystem", "64,65,76,77,78,79,80,81,82,83");
        property_set("ro.ril.force_eri_from_xml", "true");
        property_set("ro.telephony.get_imsi_from_sim", "true");
        property_set("ro.cdma.data_retry_config", "max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000");
        property_set("ro.com.google.clientidbase.ms", "android-verizon");
        property_set("ro.com.google.clientidbase.am", "android-verizon");
        property_set("ro.com.google.clientidbase.yt", "android-verizon");
        property_set("persist.radio.0x9e_not_callname", "1");
        property_set("persist.radio.sib16_support", "1");
        property_set("persist.radio.eri64_as_home", "1");
        property_set("persist.radio.mode_pref_nv10", "1");
        property_set("ro.cdma.nbpcd", "1");
        property_set("ro.cdma.disableVzwNbpcd", "true");
        property_set("ro.cdma.home.operator.isnan", "1");
        property_set("ro.telephony.gsm-routes-us-smsc", "1");
        // XT1254 - IMS Volte related
        property_set("persist.data.iwlan.enable", "true");
        property_set("persist.radio.ignore_ims_wlan", "1");
        property_set("persist.radio.data_con_rprt", "1");
        //property_set("persist.radio.calls.on.ims", "true");
        //property_set("persist.radio.jbims", "1");
        //property_set("persist.radio.VT_ENABLE", "1");
        //property_set("persist.radio.VT_HYBRID_ENABLE", "1");
        //property_set("persist.radio.ROTATION_ENABLE", "1");
        //property_set("persist.radio.RATE_ADAPT_ENABLE", "1");
        //property_set("persist.rcs.supported", "1");
        //property_set("persist.ims.enableADBLogs", "1");
        //property_set("persist.ims.enableDebugLogs", "1");

        // Reduce IMS logging
        //property_set("persist.ims.disableDebugLogs", "1");
        //property_set("persist.ims.disableADBLogs", "2");
        //property_set("persist.ims.disableDebugLogs", "0");
        //property_set("persist.ims.disableQXDMLogs", "0");
        //property_set("persist.ims.disableIMSLogs", "1");
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
        property_set("ro.build.description", "quark_verizon-user 5.1 SU4TL-44 44 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:5.1/SU4TL-44/44:user/release-keys");
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
        property_set("ro.ril.force_eri_from_xml", "true");
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
	property_set("persist.radio.redir_party_num", "0");
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
	property_set("persist.radio.redir_party_num", "0");
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
	property_set("persist.radio.redir_party_num", "0");
        property_set("ro.build.description", "quark_retbr-user 6.0.1 MPG24.107-70.2 2 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_retbr/quark_umts:6.0.1/MPG24.107-70.2/2:user/release-keys");
        INFO("Set properties for \"singlela\"!\n");
    }
}
