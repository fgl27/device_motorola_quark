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
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

public abstract class SensorBase implements SensorEventListener {
    private static final int BATCH_LATENCY_IN_MS = 100;
    private static final String TAG = "CMActions-SensorBase";

    public static final int SENSOR_TYPE_MMI_CAMERA_ACTIVATION = 65540;
    public static final int SENSOR_TYPE_MMI_CHOP_CHOP = 65546;
    public static final int SENSOR_TYPE_MMI_FLAT_UP = 65537;
    public static final int SENSOR_TYPE_MMI_IR_GESTURE = 65541;
    public static final int SENSOR_TYPE_MMI_STOW = 65539;

    private boolean mRegistered;

    protected Context mContext;
    protected SensorManager mSensorManager;
    protected int mSensorId;

    protected SensorBase(Context context) {
        mContext = context;
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        mRegistered = false;
    }

    public final Sensor getSensor() {
        return mSensorManager.getDefaultSensor(mSensorId, true);
    }

    public final boolean registered() {
        return mRegistered;
    }

    public abstract void setScreenOn(boolean isScreenOn);

    public void register() {
        if (!mSensorManager.registerListener(this, getSensor(),
            SensorManager.SENSOR_DELAY_NORMAL, BATCH_LATENCY_IN_MS * 1000)) {
            throw new RuntimeException("Failed to registerListener for sensor " + getSensor());
        }
        Log.d(TAG, getClass().getName() + ": registered.");
        mRegistered = true;
    }

    public void unregister() {
        mSensorManager.unregisterListener(this);
        Log.d(TAG, getClass().getName() + ": unregistered.");
        mRegistered = false;
    }
}