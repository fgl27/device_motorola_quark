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
import android.telecom.TelecomManager;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;

import static android.telephony.TelephonyManager.*;

public class IrGestureSensor extends SensorBase {
    private static final String TAG = "CMActions-IrGestureSensor";

    // Something occludes the sensor
    public static final int IR_GESTURE_OBJECT_DETECTED     = 1;
    // No occlusion
    public static final int IR_GESTURE_OBJECT_NOT_DETECTED = 2;
    // Swiping above the phone (silence ringer)
    public static final int IR_GESTURE_SWIPE               = 3;
    // Hand wave in front of the phone (send doze)
    public static final int IR_GESTURE_APPROACH            = 4;
    // Gestures not tracked
    public static final int IR_GESTURE_COVER               = 5;
    public static final int IR_GESTURE_DEPART              = 6;
    public static final int IR_GESTURE_HOVER               = 7;
    public static final int IR_GESTURE_HOVER_PULSE         = 8;
    public static final int IR_GESTURE_PROXIMITY_NONE      = 9;
    public static final int IR_GESTURE_HOVER_FIST          = 10;

    public static final int IR_GESTURE_WAKE_ENABLED        = 1;
    public static final int IR_GESTURE_SILENCE_ENABLED     = 2;

    private boolean mIsScreenOn = false;

    private int mLastEventId = -1;
    private int mLastEventWithAction = -1;
    private int mGesture = IR_GESTURE_OBJECT_NOT_DETECTED;

    private boolean mWakeEnabled = false;
    private boolean mSilenceEnabled = false;
    private boolean mIsRinging = false;

    private TelecomManager mTelecomManager;
    private DozeManager mDozeManager;

    static
    {
       System.load("/system/lib/libjni_CMActions.so");
    }

    public IrGestureSensor(Context context, DozeManager dozeManager) {
        super(context);
        mDozeManager = dozeManager;
        mSensorId = SensorBase.SENSOR_TYPE_MMI_IR_GESTURE;
        nativeSetIrDisabled(true);

        mTelecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        telephonyManager.listen(new PhoneStateListener() {
            @Override
            public synchronized void onCallStateChanged(int state, String incomingNumber) {
                if (state == CALL_STATE_RINGING) {
                    mIsRinging = true;
                } else {
                    mIsRinging = false;
                }

                // Toggle IR as necessary
                updateNativeState();
            }
        }, PhoneStateListener.LISTEN_CALL_STATE);
    }

    private final native boolean nativeSetIrDisabled(boolean disabled);

    private final native boolean nativeSetIrWakeConfig(int wakeConfig);

    private synchronized void updateNativeState() {
        // state variables are: mWakeEnabled, mSilenceEnabled, mIsScreenOn, mIsRinging
        boolean canDisableIr = true;

        if (mDozeManager.isDozeEnabled() && mWakeEnabled && !mIsScreenOn) {
            canDisableIr = false;
        } else if (mSilenceEnabled && mIsScreenOn && mIsRinging) {
            canDisableIr = false;
        }

        nativeSetIrDisabled(canDisableIr);
    }

    @Override
    public void setScreenOn(boolean isScreenOn) {
       mIsScreenOn = isScreenOn;
       Log.d(TAG, "mIsScreenOn: " + isScreenOn);

       // If screen is off, make some gestures wake the device
       // IR will be disabled if waking is turned off, so it will not wake
       if (!mIsScreenOn) {
           nativeSetIrWakeConfig(1 << IR_GESTURE_APPROACH);
       } else {
           nativeSetIrWakeConfig(0);
       }
       updateNativeState();
    }

    private void reset(int newEventId) {
        mGesture = IR_GESTURE_OBJECT_NOT_DETECTED;
        mLastEventId = newEventId;
    }

    public void enable(int action) {
       Log.d(TAG, "Enabling " + action);
        switch(action) {
            case IR_GESTURE_WAKE_ENABLED:
                mWakeEnabled = true;
                break;
            case IR_GESTURE_SILENCE_ENABLED:
                mSilenceEnabled = true;
                break;
            default:
                Log.e(TAG, "enable: invalid action " + action);
                return;
        }

        updateNativeState();
        if (!registered() && (mWakeEnabled || mSilenceEnabled)) {
            register();
        }
    }

    public void disable(int action) {
       Log.d(TAG, "Disabling " + action);
        switch(action) {
            case IR_GESTURE_WAKE_ENABLED:
                mWakeEnabled = false;
                break;
            case IR_GESTURE_SILENCE_ENABLED:
                mSilenceEnabled = false;
                break;
            default:
                Log.e(TAG, "disable: invalid action " + action);
                return;
        }

        updateNativeState();
        if (registered() && (!mWakeEnabled && !mSilenceEnabled)) {
            unregister();
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
        boolean actedOnEvent = (eventId == mLastEventWithAction);

        if (!mIsScreenOn && mWakeEnabled && newEvent && !actedOnEvent &&
            (mGesture == IR_GESTURE_APPROACH) ) {
            Log.d(TAG, "mGesture: " + mGesture + ", sending doze");
            mDozeManager.maybeSendDoze();
            mLastEventWithAction = eventId;
        } else if (mIsScreenOn && mSilenceEnabled && mIsRinging && newEvent &&
            !actedOnEvent && (mGesture == IR_GESTURE_SWIPE) ) {
            Log.d(TAG, "mGesture: " + mGesture + ", sending silence");
            mTelecomManager.silenceRinger();
            mLastEventWithAction = eventId;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
