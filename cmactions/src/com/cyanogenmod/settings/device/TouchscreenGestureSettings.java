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
import android.provider.Settings;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener; 
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.SwitchPreference;
import android.view.Menu;
import android.view.MenuItem;

import org.cyanogenmod.internal.util.ScreenType;

public class TouchscreenGestureSettings extends PreferenceActivity implements
Preference.OnPreferenceChangeListener {
    private static final String CATEGORY_AMBIENT_DISPLAY = "ambient_display_key";
    private static final String SWITCH_AMBIENT_DISPLAY = "ambient_display_switch";
    private static final String SWITCH_GESTURE_PICKUP = "gesture_pick_up";
    private static final String SWITCH_GESTURE_IR = "gesture_ir_wake_up";

    private SwitchPreference mSwitchAmbientDisplay, mSwitchGestureIr, mSwitchGesturePick;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.gesture_panel);
        PreferenceCategory ambientDisplayCat = (PreferenceCategory)
                findPreference(CATEGORY_AMBIENT_DISPLAY);

        mSwitchAmbientDisplay = (SwitchPreference) findPreference(SWITCH_AMBIENT_DISPLAY);
        mSwitchAmbientDisplay.setOnPreferenceChangeListener(this);

        mSwitchGestureIr = (SwitchPreference) findPreference(SWITCH_GESTURE_PICKUP);
        mSwitchGesturePick = (SwitchPreference) findPreference(SWITCH_GESTURE_IR);

        if (ambientDisplayCat != null) {
            boolean DozeValue = CMActionsSettings.isDozeEnabled(getActivity().getContentResolver());
            mSwitchGestureIr.setEnabled(DozeValue);
            mSwitchGesturePick.setEnabled(DozeValue);
        }
        final ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateState();
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

    private void updateState() {
        if (mSwitchAmbientDisplay != null) {
            int DozeValue = Settings.Secure.getInt(getActivity().getContentResolver(), Settings.Secure.DOZE_ENABLED,
                getActivity().getResources().getBoolean(
                    com.android.internal.R.bool.config_doze_enabled_by_default) ? 1 : 0);
            mSwitchAmbientDisplay.setChecked(DozeValue != 0);
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object objValue) {
        final String key = preference.getKey();
        if (preference == mSwitchAmbientDisplay) {
            boolean DozeValue = (Boolean) objValue;
            Settings.Secure.putInt(getActivity().getContentResolver(), Settings.Secure.DOZE_ENABLED, DozeValue ? 1 : 0);
            mSwitchGestureIr.setEnabled(DozeValue);
            mSwitchGesturePick.setEnabled(DozeValue);
         }
        return true;
     }
}
