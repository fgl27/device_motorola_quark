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
import android.os.UserHandle;
import android.util.Log;

public class DozePulseAction implements SensorAction, ScreenStateNotifier {
    private static final String TAG = "CMActions";
    private static final int DELAY_BETWEEN_DOZES_IN_MS = 1500;

    private static boolean sCanDoze = true;
    private final Context mContext;
    private long mLastDoze;

    public DozePulseAction(Context context) {
        mContext = context;
    }

    @Override
    public void screenTurnedOn() {
    }

    @Override
    public void screenTurnedOff() {
        mLastDoze = System.currentTimeMillis();
    }

    public void action() {
         if (mayDoze()) {
            Log.d(TAG, "Sending doze.pulse intent");
            mContext.sendBroadcastAsUser(new Intent("com.android.systemui.doze.pulse"),
                new UserHandle(UserHandle.USER_CURRENT));
        }
    }

    public static boolean getCanDoze() {
        return sCanDoze;
    }

    public static void setCanDoze(boolean canDoze) {
        sCanDoze = canDoze;
    }

    public synchronized boolean mayDoze() {
        if (!sCanDoze) {
            Log.d(TAG, "Denying doze (stowed)");
            return false;
        }

        long now = System.currentTimeMillis();
        if (now - mLastDoze > DELAY_BETWEEN_DOZES_IN_MS) {
            Log.d(TAG, "Allowing doze");
            mLastDoze = now;
            return true;
        } else {
            Log.d(TAG, "Denying doze (time)");
            return false;
        }
    }
}
