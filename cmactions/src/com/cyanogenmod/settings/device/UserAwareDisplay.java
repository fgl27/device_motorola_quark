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
import android.os.Handler;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;

import android.app.KeyguardManager;

import android.util.Log;

import static com.cyanogenmod.settings.device.IrGestureManager.*;

public class UserAwareDisplay implements ScreenStateNotifier {
    private static final String TAG = "CMActions-UAD";

    private static final int KEYGUARD_POLL_MS = 1000;
    private static final int DELAYED_BRIGHT_SCREEN_TIMEOUT = 2000; // Screen kept on after screen lock disabled
    private static final int DELAYED_OFF_MS = 6000;
    private static final int SCREEN_BRIGHT_LOCK_TIMEOUT = 170000; // Screen on time limit when "user aware display" enabled
    private static final int SCREEN_DIM_LOCK_TIMEOUT = SCREEN_BRIGHT_LOCK_TIMEOUT + 10000; // // A few more seconds with low brightness before the device goes to sleep


    private static final int IR_GESTURES_FOR_SCREEN_ON = (1 << IR_GESTURE_OBJECT_DETECTED) |
            (1 << IR_GESTURE_OBJECT_NOT_DETECTED);
    private static final int IR_GESTURES_FOR_SCREEN_OFF = 0;

    private final CMActionsSettings mCMActionsSettings;
    private final SensorHelper mSensorHelper;
    private final IrGestureVote mIrGestureVote;
    private final PowerManager mPowerManager;
    private final KeyguardManager mKeyguardManager;
    private final Sensor mIrGestureSensor;
    private final Sensor mStowSensor;
    private final WakeLock mWakeLock;
    private final WakeLock mDelayedOffWakeLock;
    private Handler mHandler;

    private boolean mEnabled;
    private boolean mScreenIsLocked;
    private boolean mObjectIsDetected;
    private boolean mIsStowed;

    public UserAwareDisplay(CMActionsSettings cmActionsSettings, SensorHelper sensorHelper,
                IrGestureManager irGestureManager, Context context) {
        mCMActionsSettings = cmActionsSettings;
        mSensorHelper = sensorHelper;
        mIrGestureVote = new IrGestureVote(irGestureManager);
        mPowerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);

        mKeyguardManager = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);

        mWakeLock = mPowerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK, TAG);
        mDelayedOffWakeLock = mPowerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK, TAG);
        mHandler = new Handler();

        mIrGestureSensor = sensorHelper.getIrGestureSensor();
        mStowSensor = sensorHelper.getStowSensor();
        mIrGestureVote.voteForSensors(0);
    }

    @Override
    public void screenTurnedOn() {
        if (mCMActionsSettings.isUserAwareDisplayEnabled()) {
            if (mKeyguardManager.inKeyguardRestrictedInputMode()) {
                scheduleKeyguardPoll();
            } else {
                enableSensors();
            }
        } else {
            // Option was potentially disabled while the screen is on, make
            // sure everything is turned off if it was enabled.
            screenTurnedOff();
        }
    }

    @Override
    public void screenTurnedOff() {
        disableKeyguardPolling();
        disableSensors();
        disableScreenLock();
    }

    private void scheduleKeyguardPoll() {
        mHandler.postDelayed(mCheckKeyguard, KEYGUARD_POLL_MS);
    }

    private void disableKeyguardPolling() {
        mHandler.removeCallbacks(mCheckKeyguard);
    }

    private void enableSensors() {
        if (! mEnabled) {
            Log.d(TAG, "Enabling");

            mEnabled = true;
            mObjectIsDetected = false;
            mIsStowed = false;

            mSensorHelper.registerListener(mIrGestureSensor, mIrGestureListener);
            mSensorHelper.registerListener(mStowSensor, mStowListener);
            mIrGestureVote.voteForSensors(IR_GESTURES_FOR_SCREEN_ON);
        }
    }

    private void disableSensors() {
        if (mEnabled) {
            Log.d(TAG, "Disabling");
            mSensorHelper.unregisterListener(mStowListener);
            mSensorHelper.unregisterListener(mIrGestureListener);
            mIrGestureVote.voteForSensors(IR_GESTURES_FOR_SCREEN_OFF);
            mEnabled = false;
        }
    }

    private synchronized void setIsStowed(boolean isStowed) {
        Log.d(TAG, "Stowed: " + isStowed);
        mIsStowed = isStowed;
        updateScreenLock();
    }

    private synchronized void setObjectIsDetected(boolean objectIsDetected) {
        Log.d(TAG, "IR object is detected: " + objectIsDetected);
        mObjectIsDetected = objectIsDetected;
        updateScreenLock();
    }

    private synchronized void updateScreenLock() {
        boolean isLocked = mObjectIsDetected && ! mIsStowed;

        if (isLocked) {
            enableScreenLock();
        } else {
            disableScreenLock();
        }
    }

    private synchronized void enableScreenLock() {
        if (! mScreenIsLocked) {
            Log.d(TAG, "Acquiring screen wakelock with timeout and low brightness at the end");
            mScreenIsLocked = true;
            mWakeLock.acquire();
            // Screen will not stay on full brightness indefinitely as they are some false positive situation
            // (eg: flower pot at 20 centimeters from the IR sensors that trigger user-aware display) that
            // could drain the battery until the phones shuts down. So there is a time out for the wakelock.
            mWakeLock.acquire(SCREEN_BRIGHT_LOCK_TIMEOUT);
            // After the full brightness wakelock expires, the phone will stay on low brightness a few more seconds
            mDelayedOffWakeLock.acquire(SCREEN_DIM_LOCK_TIMEOUT);
        }
    }

    private synchronized void disableScreenLock() {
        if (mScreenIsLocked) {
            mScreenIsLocked = false;
            // Release the "mWakelock" wakelock that might be still active because of enableScreenLock() method
            if (mWakeLock.isHeld()) {
                mWakeLock.release();
                Log.d(TAG, "Released screen wakelock");
            }            
            // Same for "mDelayedOffWakelock"
            if (mDelayedOffWakeLock.isHeld()) {
                mDelayedOffWakeLock.release();
                Log.d(TAG, "Released low brightness screen wakelock");
            }
            // Keep the screen awake a few seconds for user comfort
            Log.d(TAG, "Acquiring screen wakelock during " + DELAYED_BRIGHT_SCREEN_TIMEOUT + " ms plus " + DELAYED_OFF_MS + " ms of low brightness at the end");
            mWakeLock.acquire(DELAYED_BRIGHT_SCREEN_TIMEOUT);
            mDelayedOffWakeLock.acquire(DELAYED_OFF_MS);            
        }
    }

    private SensorEventListener mIrGestureListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            int gesture = (int) event.values[1];

            if (gesture == IR_GESTURE_OBJECT_DETECTED) {
                setObjectIsDetected(true);
            } else if (gesture == IR_GESTURE_OBJECT_NOT_DETECTED) {
                setObjectIsDetected(false);
            }
        }

        @Override
        public void onAccuracyChanged(Sensor mSensor, int accuracy) {
        }
    };

    private SensorEventListener mStowListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            setIsStowed(event.values[0] != 0);
        }

        @Override
        public void onAccuracyChanged(Sensor mSensor, int accuracy) {
        }
    };

    private Runnable mCheckKeyguard = new Runnable() {
        @Override
        public void run() {
            if (! mKeyguardManager.inKeyguardRestrictedInputMode()) {
                enableSensors();
            } else {
                scheduleKeyguardPoll();
            }
        }
    };
}
