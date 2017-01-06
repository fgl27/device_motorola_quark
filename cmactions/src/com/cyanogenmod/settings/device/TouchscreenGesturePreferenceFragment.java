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

import android.app.AlertDialog;
import android.app.NotificationManager;
import android.os.Bundle;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.provider.Settings;
import android.support.v7.preference.Preference;
import android.support.v7.preference.PreferenceCategory;
import android.support.v7.preference.Preference.OnPreferenceChangeListener;
import android.support.v14.preference.PreferenceFragment;
import android.support.v14.preference.SwitchPreference;

public class TouchscreenGesturePreferenceFragment extends PreferenceFragment implements
Preference.OnPreferenceChangeListener {

    private static final String CATEGORY_AMBIENT_DISPLAY = "ambient_display_key";
    private static final String SWITCH_AMBIENT_DISPLAY = "ambient_display_switch";
    private static final String SWITCH_GESTURE_PICKUP = "gesture_pick_up";
    private static final String SWITCH_GESTURE_IR = "gesture_ir_wake_up";
    private SwitchPreference mFlipPref;
    private NotificationManager mNotificationManager;
    private boolean mFlipClick = false;

    private SwitchPreference mSwitchAmbientDisplay, mSwitchGestureIr, mSwitchGesturePick;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
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
        mNotificationManager = (NotificationManager) getActivity().getSystemService(Context.NOTIFICATION_SERVICE);
        mFlipPref = (SwitchPreference) findPreference("gesture_flip_to_mute");
        mFlipPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
            public boolean onPreferenceClick(Preference preference) {
                if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
                    mFlipPref.setChecked(false);
                    new AlertDialog.Builder(getContext())
                        .setTitle(getString(R.string.flip_to_mute_title))
                        .setMessage(getString(R.string.dnd_access))
                        .setNegativeButton(android.R.string.cancel, null)
                        .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                mFlipClick = true;
                                startActivity(new Intent(
                                   android.provider.Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS));
                            }
                        }).show();
                }
                return true;
            }
       });

       //Users may deny DND access after giving it
       if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
           mFlipPref.setChecked(false);
       }
    }

    @Override
    public void onResume() {
        super.onResume();
        updateState();
    }

    private void updateState() {
        if (mSwitchAmbientDisplay != null) {
            int DozeValue = Settings.Secure.getInt(getActivity().getContentResolver(), Settings.Secure.DOZE_ENABLED,
                getActivity().getResources().getBoolean(
                    com.android.internal.R.bool.config_doze_enabled_by_default) ? 1 : 0);
            mSwitchAmbientDisplay.setChecked(DozeValue != 0);
        }
        if (mNotificationManager.isNotificationPolicyAccessGranted() && mFlipClick) {
            mFlipPref.setChecked(true);
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
