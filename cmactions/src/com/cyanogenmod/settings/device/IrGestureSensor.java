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

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.telecom.TelecomManager;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.os.SystemProperties;

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

    // Alarm snoozing
    private static final String ALARM_ALERT_ACTION = "com.android.deskclock.ALARM_ALERT";
    private static final String ALARM_DISMISS_ACTION = "com.android.deskclock.ALARM_DISMISS";
    private static final String ALARM_SNOOZE_ACTION = "com.android.deskclock.ALARM_SNOOZE";
    private static final String ALARM_DONE_ACTION = "com.android.deskclock.ALARM_DONE";

    private static boolean IR_NO_DISABLE_WHEN_UNUSED = SystemProperties.getBoolean("persist.sys.cmactions.ir_nooff", false);

    private boolean mIsScreenOn = false;

    private int mLastEventId = -1;
    private int mLastEventWithAction = -1;
    private int mGesture = IR_GESTURE_OBJECT_NOT_DETECTED;

    private boolean mWakeEnabled = false;
    private boolean mSilenceEnabled = false;
    private boolean mPhoneRinging = false;
    private boolean mAlarmRinging = false;

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
        nativeSetIrDisabled(!IR_NO_DISABLE_WHEN_UNUSED);

        mTelecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        telephonyManager.listen(new PhoneStateListener() {
            @Override
            public synchronized void onCallStateChanged(int state, String incomingNumber) {
                if (state == CALL_STATE_RINGING) {
                    mPhoneRinging = true;
                } else {
                    mPhoneRinging = false;
                }

                // Toggle IR as necessary
                updateNativeState();
            }
        }, PhoneStateListener.LISTEN_CALL_STATE);

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ALARM_ALERT_ACTION);
        intentFilter.addAction(ALARM_DISMISS_ACTION);
        intentFilter.addAction(ALARM_SNOOZE_ACTION);
        intentFilter.addAction(ALARM_DONE_ACTION);
        mContext.registerReceiver(mAlarmStateReceiver, intentFilter);
    }

    private final native boolean nativeSetIrDisabled(boolean disabled);

    private final native boolean nativeSetIrWakeConfig(int wakeConfig);

    private synchronized void updateNativeState() {
        // state variables are: mWakeEnabled, mSilenceEnabled, mIsScreenOn, mPhoneRinging, mAlarmRinging
        boolean canDisableIr = true;

        if (IR_NO_DISABLE_WHEN_UNUSED) {
            canDisableIr = false;
        } else if (mDozeManager.isDozeEnabled() && mWakeEnabled && !mIsScreenOn) {
            canDisableIr = false;
        } else if (mSilenceEnabled && mIsScreenOn && mPhoneRinging) {
            canDisableIr = false;
        } else if (mSilenceEnabled && mAlarmRinging) {
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
        } else if (mIsScreenOn && mSilenceEnabled && mPhoneRinging && newEvent &&
            !actedOnEvent && (mGesture == IR_GESTURE_SWIPE) ) {
            Log.d(TAG, "mGesture: " + mGesture + ", silencing ringer");
            mTelecomManager.silenceRinger();
            mLastEventWithAction = eventId;
        } else if (mSilenceEnabled && mAlarmRinging && newEvent &&
            !actedOnEvent && (mGesture == IR_GESTURE_SWIPE) ) {
            Log.d(TAG, "mGesture: " + mGesture + ", silencing alarm");
            mContext.sendBroadcast(new Intent(ALARM_SNOOZE_ACTION));
            mLastEventWithAction = eventId;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    private BroadcastReceiver mAlarmStateReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
           String action = intent.getAction();
           if (ALARM_ALERT_ACTION.equals(action)) {
               mAlarmRinging = true;
           } else {
               mAlarmRinging = false;
           }
           updateNativeState();
        }
    };
}
