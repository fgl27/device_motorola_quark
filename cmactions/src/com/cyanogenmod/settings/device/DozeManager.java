/*
 * Copyright (c) 2015 The CyanogenMod Project
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

import android.content.Context;
import android.content.Intent;
import android.provider.Settings;
import android.util.Log;

public class DozeManager {
    private static final String TAG = "CMActions";
    private static final int DELAY_BETWEEN_DOZES_IN_MS = 2500;

    private Context mContext;
    private long mLastDoze;
    private boolean mIsStowed;
    private boolean mIsScreenOn;

    public DozeManager(Context context) {
        mContext = context;
    }

    private void sendDoze() {
        Log.d(TAG, "Sending doze.pulse intent");
        mContext.sendBroadcast(new Intent("com.android.systemui.doze.pulse"));
        mLastDoze = System.currentTimeMillis();
    }

    public boolean isDozeEnabled() {
        return isDozeEnabled(mContext);
    }

    public static boolean isDozeEnabled(Context context) {
        return Settings.Secure.getInt(context.getContentResolver(),
            Settings.Secure.DOZE_ENABLED, 1) != 0;
    }

    public boolean getIsStowed() {
        return mIsStowed;
    }

    public void setIsStowed(boolean isStowed) {
        mIsStowed = isStowed;
    }

    public boolean getScreenOn() {
        return mIsScreenOn;
    }

    public void setScreenOn(boolean isScreenOn) {
        if (mIsScreenOn && !isScreenOn) {
            // Do not doze immediatelly after screen off
            mLastDoze = System.currentTimeMillis();
        }
        mIsScreenOn = isScreenOn;
    }

    public boolean mayDoze() {
        // No dozing if stowed or screen on
        if (!isDozeEnabled() || mIsStowed || mIsScreenOn) {
            Log.d(TAG, "Denying doze (not allowed)");
            return false;
        }

        long now = System.currentTimeMillis();
        if (now - mLastDoze > DELAY_BETWEEN_DOZES_IN_MS) {
            Log.d(TAG, "Allowing doze");
            return true;
        } else {
            Log.d(TAG, "Denying doze (recently sent)");
            return false;
        }
    }

    public synchronized boolean maybeSendDoze() {
        if (mayDoze()) {
            sendDoze();
            return true;
        }
        return false;
    }
}