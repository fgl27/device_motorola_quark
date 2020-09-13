/*
 * Copyright (c) 2017-2020 Felipe de Leon <fglfgl27@gmail.com>
 *
 * This file is part of SysInfoService <https://github.com/fgl27/device_motorola_quark>
 *
 */

package com.sysinfo;

import android.app.ActionBar;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;

import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.Preference.OnPreferenceChangeListener;
import androidx.preference.PreferenceFragment;
import androidx.preference.SwitchPreference;

public class AppPreferenceFragment extends PreferenceFragment implements Preference.OnPreferenceChangeListener {

    private SwitchPreference mSwitchServiceEnable;
    private ListPreference mServicePosition;
    private ListPreference mServiceBackgroundOpacity;
    private ListPreference mServiceBackgroundColor;
    private ListPreference mServiceTextColor;
    private ListPreference mServiceTextOfflineColor;
    private ListPreference mServiceTextSize;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.settings_options);
        final ActionBar actionBar = getActivity().getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);

        mSwitchServiceEnable = (SwitchPreference) findPreference(Constants.SERVICE_ENABLE);
        mSwitchServiceEnable.setOnPreferenceChangeListener(this);

        mServicePosition = (ListPreference) findPreference(Constants.SERVICE_POSITION);
        mServicePosition.setOnPreferenceChangeListener(this);

        mServiceBackgroundOpacity = (ListPreference) findPreference(Constants.SERVICE_BACKGROUND_OPACITY);
        mServiceBackgroundOpacity.setOnPreferenceChangeListener(this);

        mServiceBackgroundColor = (ListPreference) findPreference(Constants.SERVICE_BACKGROUND_COLOR);
        mServiceBackgroundColor.setOnPreferenceChangeListener(this);

        mServiceTextColor = (ListPreference) findPreference(Constants.SERVICE_TEXT_COLOR);
        mServiceTextColor.setOnPreferenceChangeListener(this);

        mServiceTextOfflineColor = (ListPreference) findPreference(Constants.SERVICE_TEXT_OFFLINE_COLOR);
        mServiceTextOfflineColor.setOnPreferenceChangeListener(this);

        mServiceTextSize = (ListPreference) findPreference(Constants.SERVICE_TEXT_SIZE);
        mServiceTextSize.setOnPreferenceChangeListener(this);

        PreferenceManager.getDefaultSharedPreferences(getActivity()).registerOnSharedPreferenceChangeListener(mPrefListener);
    }

    @Override
    public void onResume() {
        super.onResume();
        PreferenceManager.getDefaultSharedPreferences(getActivity()).registerOnSharedPreferenceChangeListener(mPrefListener);
    }

    @Override
    public void onStop() {
        super.onStop();
        PreferenceManager.getDefaultSharedPreferences(getActivity()).unregisterOnSharedPreferenceChangeListener(mPrefListener);
    }

    private void updateState(SharedPreferences sharedPreferences) {
        if (mSwitchServiceEnable != null) {
            mSwitchServiceEnable.setChecked(
                    sharedPreferences.getBoolean(Constants.SERVICE_ENABLE, false)
            );
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object objValue) {
        Context context = getActivity();
        boolean serviceEnable = PreferenceManager.getDefaultSharedPreferences(context).getBoolean(Constants.SERVICE_ENABLE, false);

        if (preference == mSwitchServiceEnable) StartSysService(context, (Boolean) objValue, null);
        else if (preference == mServicePosition && serviceEnable) {

            StartSysService(context, true, Constants.SERVICE_POSITION);

        } else if ((preference == mServiceBackgroundOpacity || preference == mServiceBackgroundColor) && serviceEnable) {

            StartSysService(context, true, Constants.SERVICE_BACKGROUND_OPACITY);

        } else if (preference == mServiceTextColor && serviceEnable) {

            StartSysService(context, true, Constants.SERVICE_TEXT_COLOR);

        } else if (preference == mServiceTextOfflineColor && serviceEnable) {

            StartSysService(context, true, Constants.SERVICE_TEXT_OFFLINE_COLOR);

        } else if (preference == mServiceTextSize && serviceEnable) {

            StartSysService(context, true, Constants.SERVICE_TEXT_SIZE);

        }

        return true;
    }

    public static void StartSysService(Context context, boolean enable, String action) {
        Intent service = new Intent(context, SysInfoService.class);
        if (action != null) service.setAction(action);

        if (enable) context.startService(service);
        else context.stopService(service);
    }

    //This is here so the switch updates when the tile changes the service state and the app is visible
    private SharedPreferences.OnSharedPreferenceChangeListener mPrefListener =
            new SharedPreferences.OnSharedPreferenceChangeListener() {
                @Override
                public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {

                    if (Constants.SERVICE_ENABLE.equals(key)) {
                        updateState(sharedPreferences);
                    }

                }
            };
}
