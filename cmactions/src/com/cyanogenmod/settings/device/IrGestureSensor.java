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

    public static final int IR_GESTURE_WAKE_ENABLED                = 1;
    public static final int IR_GESTURE_SILENCE_ENABLED             = 2;

    private SensorHelper mSensorHelper;
    private SensorAction mDozePulseAction;
    private SensorAction mSilenceAction;
    private Sensor mSensor;
    private boolean mIsScreenOn;

    private int mLastEventId;
    private int mGesture = IR_GESTURE_GESTURE_OBJECT_NOT_DETECTED;

    private boolean mWakeEnabled = false;
    private boolean mSilenceEnabled = false;
    private boolean mRegistered = false;

    static
    {
       System.load("/system/lib/libjni_CMActions.so");
    }

    public IrGestureSensor(SensorHelper sensorHelper, SensorAction dozePulseAction, SensorAction silenceAction) {
        mSensorHelper = sensorHelper;
        mDozePulseAction = dozePulseAction;
        mSilenceAction = silenceAction;

        mSensor = sensorHelper.getIrGestureSensor();
        nativeSetIrDisabled(true);
    }

    private final native boolean nativeSetIrDisabled(boolean disabled);

    private final native boolean nativeSetIrWakeConfig(int wakeConfig);

    public void setScreenOn(boolean isScreenOn) {
       mIsScreenOn = isScreenOn;
       Log.d(TAG, "mIsScreenOn: " + isScreenOn);

       // If screen is off, make some gestures wake the device
       // IR will be disabled if waking is turned off, so it will not wake
       if (!mIsScreenOn) {
           nativeSetIrWakeConfig((1 << IR_GESTURE_SWIPE) | (1 << IR_GESTURE_APPROACH));
           if (!mWakeEnabled) {
               nativeSetIrDisabled(true);
           } else {
               nativeSetIrDisabled(false);
           }
       } else {
           nativeSetIrWakeConfig(0);
           if (!mSilenceEnabled) {
               nativeSetIrDisabled(true);
           } else {
               nativeSetIrDisabled(false);
           }
       }
    }

    private void reset(int newEventId) {
        mGesture = IR_GESTURE_GESTURE_OBJECT_NOT_DETECTED;
        mLastEventId = newEventId;
    }

    @Override
    public void enable() {
        Log.d(TAG, "Enabling");
        mWakeEnabled = true;
        mSilenceEnabled = true;
        mSensorHelper.registerListener(mSensor, this);
        nativeSetIrDisabled(false);
        mRegistered = true;
    }

    public void enable(int action) {
       Log.d(TAG, "Enabling " + action);
        switch(action) {
            case IR_GESTURE_WAKE_ENABLED:
                mWakeEnabled = true;
                if (!mIsScreenOn) {
                    nativeSetIrDisabled(false);
                }
                break;
            case IR_GESTURE_SILENCE_ENABLED:
                mSilenceEnabled = true;
                if (mIsScreenOn) {
                    nativeSetIrDisabled(false);
                }
                break;
            default:
                Log.e(TAG, "enable: invalid action " + action);
                return;
        }

        if (!mRegistered && (mWakeEnabled || mSilenceEnabled)) {
            mSensorHelper.registerListener(mSensor, this);
            mRegistered = true;
        }
    }

    @Override
    public void disable() {
        Log.d(TAG, "Disabling");
        mWakeEnabled = false;
        mSilenceEnabled = false;
        mSensorHelper.unregisterListener(this);
        nativeSetIrDisabled(true);
        mRegistered = false;
    }

    public void disable(int action) {
       Log.d(TAG, "Disabling " + action);
        switch(action) {
            case IR_GESTURE_WAKE_ENABLED:
                mWakeEnabled = false;
                if (!mIsScreenOn) {
                    nativeSetIrDisabled(true);
                }
                break;
            case IR_GESTURE_SILENCE_ENABLED:
                mSilenceEnabled = false;
                if (mIsScreenOn) {
                    nativeSetIrDisabled(true);
                }
                break;
            default:
                Log.e(TAG, "disable: invalid action " + action);
                return;
        }

        if (mRegistered && (!mWakeEnabled && !mSilenceEnabled)) {
            mSensorHelper.unregisterListener(this);
            mRegistered = false;
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

        if (!mIsScreenOn && mWakeEnabled && newEvent &&
            (mGesture == IR_GESTURE_SWIPE || mGesture == IR_GESTURE_APPROACH) ) {
            Log.d(TAG, "mGesture: " + mGesture + ", sending doze");
            mDozePulseAction.action();
        } else if (mIsScreenOn && mSilenceEnabled && newEvent && (mGesture == IR_GESTURE_SWIPE)) {
            Log.d(TAG, "mGesture: " + mGesture + ", sending silence");
            mSilenceAction.action();
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
