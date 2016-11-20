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

import android.app.ActionBar;
import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.view.Menu;
import android.view.MenuItem;

import org.cyanogenmod.internal.util.ScreenType;

public class TouchscreenGestureSettings extends PreferenceActivity {
    private static final String CATEGORY_AMBIENT_DISPLAY = "ambient_display_key";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.gesture_panel);
        PreferenceCategory ambientDisplayCat = (PreferenceCategory)
                findPreference(CATEGORY_AMBIENT_DISPLAY);
        if (ambientDisplayCat != null) {
            ambientDisplayCat.setEnabled(CMActionsSettings.isDozeEnabled(getContentResolver()));
            if (!CMActionsSettings.isDozeEnabled(getContentResolver()))
                ambientDisplayCat.setTitle(getString(R.string.ambient_display_title) + " " + getString(R.string.feedback_intensity_none) + " " + getString(R.string.enable_in_setting_display));
        }
        final ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    @Override
    protected void onResume() {
        super.onResume();

        // If running on a phone, remove padding around the listview
        if (!ScreenType.isTablet(this)) {
            getListView().setPadding(0, 0, 0, 0);
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
            return true;
        }
        return false;
    }
}
