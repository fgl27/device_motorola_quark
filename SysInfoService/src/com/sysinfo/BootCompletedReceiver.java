/*
 * Copyright (c) 2017-2020 Felipe de Leon <fglfgl27@gmail.com>
 *
 * This file is part of SysInfoService <https://github.com/fgl27/device_motorola_quark>
 *
 */

package com.sysinfo;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.preference.PreferenceManager;
import android.util.Log;

public class BootCompletedReceiver extends BroadcastReceiver {
    static final String TAG = "sysinfoBootComplete";

    @Override
    public void onReceive(final Context context, Intent intent) {
        Log.i(TAG, "Booting");

        if (PreferenceManager.getDefaultSharedPreferences(context).getBoolean(Constants.SERVICE_ENABLE, false))
            context.startService(new Intent(context, SysInfoService.class));
    }

}
