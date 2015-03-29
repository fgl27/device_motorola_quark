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

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.util.Log;

public class IrGestureSensor implements ActionableSensor, SensorEventListener {
    private static final String TAG = "CMActions-IRGestureSensor";

    // Something occludes the sensor
    public static final int IR_GESTURE_OBJECT_DETECTED             = 1;
    // No occlusion
    public static final int IR_GESTURE_GESTURE_OBJECT_NOT_DETECTED = 2;
    // Swiping above the phone (send doze)
    public static final int IR_GESTURE_SWIPE                       = 3;
    // Hand wave in front of the phone (send doze)
    public static final int IR_GESTURE_APPROACH                    = 4;
    // Gestures not tracked
    public static final int IR_GESTURE_COVER                       = 5;
    public static final int IR_GESTURE_DEPART                      = 6;
    public static final int IR_GESTURE_HOVER                       = 7;
    public static final int IR_GESTURE_HOVER_PULSE                 = 8;
    public static final int IR_GESTURE_PROXIMITY_NONE              = 9;
    public static final int IR_GESTURE_HOVER_FIST                  = 10;

    private SensorHelper mSensorHelper;
    private SensorAction mDozeAction;
    private Sensor mSensor;
    private boolean mIsScreenOn;

    private int mLastEventId;
    private int mGesture = IR_GESTURE_GESTURE_OBJECT_NOT_DETECTED;

    static
    {
       System.load("/system/lib/libjni_CMActions.so");
    }

    public IrGestureSensor(SensorHelper sensorHelper, SensorAction dozeAction) {
        mSensorHelper = sensorHelper;
        mDozeAction = dozeAction;

        mSensor = sensorHelper.getIrGestureSensor();
        nativeSetIrDisabled(true);
    }

    private final native boolean nativeSetIrDisabled(boolean disabled);

    private final native boolean nativeSetIrWakeConfig(int wakeConfig);

    public void setScreenOn(boolean isScreenOn) {
       mIsScreenOn = isScreenOn;
       Log.d(TAG, "mIsScreenOn: " + isScreenOn);
       boolean success = false;

       // If screen is off, make some gestures wake the device
       if (!mIsScreenOn) {
           success = nativeSetIrWakeConfig((1 << IR_GESTURE_SWIPE) | (1 << IR_GESTURE_APPROACH));
       } else {
           success = nativeSetIrWakeConfig(0);
       }

       if (!success) {
           Log.e(TAG, "Failed setting IR wake config!");
       }
    }

    private void reset(int newEventId) {
        mGesture = IR_GESTURE_GESTURE_OBJECT_NOT_DETECTED;
        mLastEventId = newEventId;
    }

    @Override
    public void enable() {
        Log.d(TAG, "Enabling");
        mSensorHelper.registerListener(mSensor, this);
        if (!nativeSetIrDisabled(false)) {
            Log.e(TAG, "Failed enabling IR sensor!");
        }
    }

    @Override
    public void disable() {
        Log.d(TAG, "Disabling");
        mSensorHelper.unregisterListener(this);
        if (!nativeSetIrDisabled(true)) {
            Log.e(TAG, "Failed disabling IR sensor!");
        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        /*Log.d(TAG, "events num: " + event.values.length);
        for (int i = 0; i < event.values.length; i++) {
            Log.d(TAG, "event[" + i + "]: " + event.values[i]);
        }*/

        int eventId = (int)event.values[0];
        boolean newEvent = true;
        if (eventId != mLastEventId) {
            reset(eventId);
            newEvent = false;
        }

        mGesture = (int)event.values[1];

        if (!mIsScreenOn && newEvent &&
            (mGesture == IR_GESTURE_SWIPE || mGesture == IR_GESTURE_APPROACH) ) {
            Log.d(TAG, "mGesture: " + mGesture);
            mDozeAction.action();
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
