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

public class StowSensor extends SensorBase {
    private static final String TAG = "CMActions-StowSensor";
    private DozeManager mDozeManager;

    public StowSensor(Context context, DozeManager dozeManager) {
        super(context);
        mDozeManager = dozeManager;
        mSensorId = SensorBase.SENSOR_TYPE_MMI_STOW;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        boolean stowed = (event.values[0] != 0);
        Log.d(TAG, "stowed: " + stowed);
        mDozeManager.setIsStowed(stowed);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    @Override
    public void setScreenOn(boolean isScreenOn) {
        // Nothing - we can get stowed / unstowed regardless of screen on or off
    }
}
