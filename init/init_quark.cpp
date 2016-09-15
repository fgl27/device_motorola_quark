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

#define ISMATCH(a,b)    (!strncmp(a,b,PROP_VALUE_MAX))

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

static void set_cmdline_properties()
{
    int i, rc;
    char prop[PROP_VALUE_MAX];

    struct {
        const char *src_prop;
        const char *dest_prop;
        const char *def_val;
    } prop_map[] = {
        { "ro.boot.device", "ro.hw.device", "quark", },
        { "ro.boot.hwrev", "ro.hw.hwrev", "0x84A0", },
        { "ro.boot.radio", "ro.hw.radio", "0x5", },
    };

    for (i = 0; i < (int)ARRAY_SIZE(prop_map); i++) {
        memset(prop, 0, PROP_VALUE_MAX);
        rc = property_get(prop_map[i].src_prop, prop);
        if (rc > 0) {
            property_set(prop_map[i].dest_prop, prop);
        } else {
            property_set(prop_map[i].dest_prop, prop_map[i].def_val);
        }
    }
}

void vendor_load_properties()
{
    char platform[PROP_VALUE_MAX];
    char sku[PROP_VALUE_MAX];
    char carrier[PROP_VALUE_MAX];
    char fsgid[PROP_VALUE_MAX];
    const char *fsgid_value;
    int rc;

    rc = property_get("ro.board.platform", platform);
    if (!rc || !ISMATCH(platform, ANDROID_TARGET))
        return;

    set_cmdline_properties();

    // Defaults go to Latin America XT1225
    rc = property_get("ro.boot.hardware.sku", sku);
    if (rc < 0) {
        sku[0] = '\0';
    }
    rc = property_get("ro.boot.carrier", carrier);
    if (rc < 0) {
        carrier[0] = '\0';
    }
    rc = property_get("ro.boot.fsg-id", fsgid);
    if (rc < 0) {
        fsgid[0] = '\0';
    }

    if (fsgid[0] == '\0') {
        if (ISMATCH(sku, "XT1225")) {
            if (ISMATCH(carrier, "reteu")) {
                fsgid_value = "emea";
            } else {
                fsgid_value = "singlela";
            }
        } else if (ISMATCH(sku, "XT1250")) {
            fsgid_value = "lra";
        } else if (ISMATCH(sku, "XT1254")) {
            fsgid_value = "verizon";
        }
        INFO("Determined fsg-id: %s\n", fsgid_value);
    } else {
        fsgid_value = fsgid;
        INFO("Configured fsg-id: %s\n", fsgid_value);
    }

    if (ISMATCH(fsgid_value, "verizon")) {
        // XT1254 - Droid Turbo
        property_set("ro.build.product", "quark");
        property_set("ro.product.device", "quark");
        property_set("ro.product.model", "DROID Turbo");
        property_set("ro.fsg-id", "verizon");
        property_set("ro.telephony.default_network", "10");
        property_set("telephony.lteOnCdmaDevice", "1");
        property_set("ro.build.description", "quark_verizon-user 5.1 SU4TL-49 5 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:5.1/SU4TL-49/5:user/release-keys");
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
        property_set("persist.ims.enableADBLogs", "1");
        property_set("persist.ims.enableDebugLogs", "1");

        // Reduce IMS logging
        //property_set("persist.ims.disableDebugLogs", "1");
        //property_set("persist.ims.disableADBLogs", "2");
        //property_set("persist.ims.disableDebugLogs", "0");
        //property_set("persist.ims.disableQXDMLogs", "0");
        //property_set("persist.ims.disableIMSLogs", "1");
        INFO("Set properties for \"verizon\"!\n");
    } else if (ISMATCH(fsgid_value, "verizon_gsm")) {
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
        property_set("ro.build.description", "quark_verizon-user 5.1 SU4TL-49 5 release-keys");
        property_set("ro.build.fingerprint", "motorola/quark_verizon/quark:5.1/SU4TL-49/5:user/release-keys");
        INFO("Set properties for \"verizon_gsm\"!\n");
    } else if (ISMATCH(fsgid_value, "lra")) {
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
    } else if (ISMATCH(fsgid_value, "lra_gsm")) {
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
    } else if (ISMATCH(fsgid_value, "emea")) {
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
