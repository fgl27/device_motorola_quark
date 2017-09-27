/*
 * Copyright (C) 2014 The CyanogenMod Project <http://www.cyanogenmod.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#pragma push_macro("PROPERTY_VALUE_MAX")

#include <cutils/properties.h>
#include <string.h>

inline const char* BtmGetDefaultName()
{
	char fsg[PROPERTY_VALUE_MAX];
	property_get("ro.fsg-id", fsg, "");

	if (!strcmp("lra", fsg))
		return "Moto MAXX";
	else if (!strcmp("verizon", fsg))
		return "DROID Turbo";
	else if (!strcmp("singlela", fsg))
		return "Moto MAXX";
	else if (!strcmp("emea", fsg))
		return "Moto Turbo";
	else return "Moto MAXX";
}
#pragma pop_macro("PROPERTY_VALUE_MAX")

#define BTM_DEF_LOCAL_NAME BtmGetDefaultName()

// Enables interleaved scan
#define BTA_HOST_INTERLEAVE_SEARCH TRUE

#define BTA_SKIP_BLE_READ_REMOTE_FEAT FALSE
#define MAX_ACL_CONNECTIONS    16
#define MAX_L2CAP_CHANNELS    MAX_ACL_CONNECTIONS
#define BTIF_HF_WBS_PREFERRED FALSE /* Don't prefer WBS    */
#define BLE_VND_INCLUDED   TRUE

#endif
