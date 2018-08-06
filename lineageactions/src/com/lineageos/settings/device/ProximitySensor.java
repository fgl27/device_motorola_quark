/*
 * Copyright (c) 2015 The lineageos Project
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

package com.lineageos.settings.device;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.util.Log;

public class ProximitySensor implements ScreenStateNotifier, SensorEventListener {
    private static final String TAG = "LineageActions-ProximitySensor";

    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;
    private final SensorAction mSensorAction;
    private final Sensor mSensor;

    private boolean mEnabled;

    private boolean mSawNear = false;

    private final PowerManager mPowerManager;
    private WakeLock mWakeLock;

    public ProximitySensor(LineageActionsSettings LineageActionsSettings, SensorHelper sensorHelper,
        SensorAction action, Context context) {
        mLineageActionsSettings = LineageActionsSettings;
        mSensorHelper = sensorHelper;
        mSensorAction = action;

        mSensor = sensorHelper.getProximitySensor();

        mPowerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, TAG);
    }

    @Override
    public void screenTurnedOn() {
        if (mEnabled) {
            Log.d(TAG, "Disabling");
            mSensorHelper.unregisterListener(this);
            mEnabled = false;
        }
    }

    @Override
    public void screenTurnedOff() {
        if (mLineageActionsSettings.isIrWakeupEnabled() && !mEnabled) {
            if (mWakeLock == null)
                mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, TAG);

            if (!mWakeLock.isHeld()) {
                mWakeLock.setReferenceCounted(false);
                mWakeLock.acquire();
            }
            Log.d(TAG, "Enabling");
            mSensorHelper.registerListener(mSensor, this);
            mEnabled = true;
            mWakeLock.release();
        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        boolean isNear = event.values[0] < mSensor.getMaximumRange();
        if (mSawNear && !isNear) {
            Log.d(TAG, "wave triggered");
            mSensorAction.action();
        }
        mSawNear = isNear;
    }

    @Override
    public void onAccuracyChanged(Sensor mSensor, int accuracy) {}
}