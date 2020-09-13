/*
 * Copyright (c) 2017-2020 Felipe de Leon <fglfgl27@gmail.com>
 *
 * This file is part of SysInfoService <https://github.com/fgl27/device_motorola_quark>
 *
 */

package com.sysinfo;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;

public class AppTile extends TileService {

    @Override
    public void onClick() {
        Context context = this.getApplicationContext();
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);

        boolean enable = !sharedPreferences.getBoolean(Constants.SERVICE_ENABLE, false);
        AppPreferenceFragment.StartSysService(context, enable, null);

        setState(enable);
        sharedPreferences.edit().putBoolean(Constants.SERVICE_ENABLE, enable).commit();
    }

    @Override
    public void onTileAdded() {
        super.onTileAdded();
        setState();
    }

    @Override
    public void onStartListening() {
        super.onStartListening();
        setState();
    }

    private void setState() {
        setState(
                PreferenceManager.getDefaultSharedPreferences(this.getApplicationContext()).getBoolean(Constants.SERVICE_ENABLE, false)
        );
    }

    private void setState(boolean enable) {
        Tile mTile = getQsTile();
        mTile.setState(enable ? mTile.STATE_ACTIVE : mTile.STATE_INACTIVE);
        mTile.updateTile();
    }

}
