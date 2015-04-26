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
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.util.Log;

public class FlatUpSensor extends SensorBase {
    private static final String TAG = "CMActions-FlatUpSensor";
    private DozeManager mDozeManager;
    private boolean mLastFlatUp;

    public FlatUpSensor(Context context, DozeManager dozeManager) {
        super(context);
        mDozeManager = dozeManager;
        mSensorId = SensorBase.SENSOR_TYPE_MMI_FLAT_UP;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        boolean flatUp = (event.values[0] != 0);
        Log.d(TAG, "flatUp: " + flatUp + ", mLastFlatUp=" + mLastFlatUp);

        // Only pulse when picked up
        if (flatUp && !mLastFlatUp) {
            mDozeManager.maybeSendDoze();
        }

        mLastFlatUp = flatUp;
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    @Override
    public void setScreenOn(boolean isScreenOn) {
        if (isScreenOn) {
            unregister();
        } else if (mDozeManager.isDozeEnabled()) {
            register();
        }
    }
}
