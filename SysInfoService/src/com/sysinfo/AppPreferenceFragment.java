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
    private ListPreference mServiceBackground;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.settings_options);
        final ActionBar actionBar = getActivity().getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);

        mSwitchServiceEnable = (SwitchPreference) findPreference(Constants.SWITCH_SERVICE_ENABLE);
        mSwitchServiceEnable.setOnPreferenceChangeListener(this);

        mServicePosition = (ListPreference) findPreference(Constants.SWITCH_SERVICE_POSITION);
        mServicePosition.setOnPreferenceChangeListener(this);

        mServiceBackground = (ListPreference) findPreference(Constants.SWITCH_SERVICE_BACKGROUND);
        mServiceBackground.setOnPreferenceChangeListener(this);

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
                    sharedPreferences.getBoolean(Constants.SWITCH_SERVICE_ENABLE, false)
            );
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object objValue) {
        Context context = getActivity();

        if (preference == mSwitchServiceEnable) StartSysService(context, (Boolean) objValue, null);
        else if (preference == mServicePosition) {

            if (PreferenceManager.getDefaultSharedPreferences(context).getBoolean(Constants.SWITCH_SERVICE_ENABLE, false)) {
                StartSysService(context, true, Constants.ACTION_UPDATE_POSITION);
            }

        } else if (preference == mServiceBackground) {

            if (PreferenceManager.getDefaultSharedPreferences(context).getBoolean(Constants.SWITCH_SERVICE_ENABLE, false)) {
                StartSysService(context, true, Constants.ACTION_UPDATE_BACKGROUND);
            }

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

                    if (Constants.SWITCH_SERVICE_ENABLE.equals(key)) {
                        updateState(sharedPreferences);
                    }

                }
            };
}
