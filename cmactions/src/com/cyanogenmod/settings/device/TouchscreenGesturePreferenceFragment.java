/*
 * Copyright (C) 2015 The CyanogenMod Project
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

package com.cyanogenmod.settings.device;

import android.os.Bundle;
import android.support.v7.preference.PreferenceCategory;
import android.support.v14.preference.PreferenceFragment;

public class TouchscreenGesturePreferenceFragment extends PreferenceFragment {
    private static final String CATEGORY_AMBIENT_DISPLAY = "ambient_display_key";

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.gesture_panel);
        PreferenceCategory ambientDisplayCat = (PreferenceCategory)
                findPreference(CATEGORY_AMBIENT_DISPLAY);
        if (ambientDisplayCat != null) {
            String crdroid_settings = getString(R.string.crdroid_settings);
            ambientDisplayCat.setEnabled(CMActionsSettings.isDozeEnabled(getActivity().getContentResolver()));
            if (!CMActionsSettings.isDozeEnabled(getActivity().getContentResolver()))
                ambientDisplayCat.setTitle(getString(R.string.ambient_display_title) + " " + getString(R.string.feedback_intensity_none) + " " + getString(R.string.enable_in_setting_display, crdroid_settings));
        }
    }
}
