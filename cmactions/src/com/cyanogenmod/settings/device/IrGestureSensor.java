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
import android.os.PowerManager;
import android.util.Log;

import java.util.Timer;
import java.util.TimerTask;

import static com.cyanogenmod.settings.device.IrGestureManager.*;

public class IrGestureSensor implements ScreenStateNotifier, SensorEventListener {
    private static final String TAG = "CMActions-IRGestureSensor";

    private static final int IR_GESTURES_FOR_SCREEN_OFF = (1 << IR_GESTURE_SWIPE) | (1 << IR_GESTURE_APPROACH);

    private final CMActionsSettings mCMActionsSettings;
    private final SensorHelper mSensorHelper;
    private final SensorAction mSensorAction;
    private final IrGestureVote mIrGestureVote;
    private final Sensor mSensor;

    private final PowerManager mPowerManager;
    private PowerManager.WakeLock mWakeLock;

    private boolean mEnabled, mScreenOn, mtempOn, mtempOff;

    public IrGestureSensor(CMActionsSettings cmActionsSettings, SensorHelper sensorHelper,
                SensorAction action, IrGestureManager irGestureManager, Context context) {
        mCMActionsSettings = cmActionsSettings;
        mSensorHelper = sensorHelper;
        mSensorAction = action;
        mIrGestureVote = new IrGestureVote(irGestureManager);

        mSensor = sensorHelper.getIrGestureSensor();
        mIrGestureVote.voteForSensors(0);

        mPowerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "CMActionsWakeLock");
    }

    @Override
    public void screenTurnedOn() {
        mScreenOn = true;
        if (mEnabled && !mtempOn) {
            mtempOn = true;
            new Timer().schedule(
                new TimerTask() {
                    @Override
                    public void run() {
                        if (mEnabled && mScreenOn) {
                            Log.d(TAG, "Disabling");
                            mSensorHelper.unregisterListener(IrGestureSensor.this);
                            mIrGestureVote.voteForSensors(0);
                            mEnabled = false;
                        }
                        mtempOn = false;
                    }
                },
                1000
            );
        }
    }

    @Override
    public void screenTurnedOff() {
        mScreenOn = false;
        if (mCMActionsSettings.isIrWakeupEnabled() && !mEnabled && !mtempOff) {
            mtempOff = true;
            if (mWakeLock == null)
                mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "CMActionsWakeLock");
            else if (!mWakeLock.isHeld()) {
                mWakeLock.setReferenceCounted(false);
                mWakeLock.acquire();
            }
            new Timer().schedule(
                new TimerTask() {
                    @Override
                    public void run() {
                        if (!mEnabled && !mScreenOn) {
                            Log.d(TAG, "Enabling");
                            mSensorHelper.registerListener(mSensor, IrGestureSensor.this);
                            mIrGestureVote.voteForSensors(IR_GESTURES_FOR_SCREEN_OFF);
                            mEnabled = true;
                        }
                        mtempOff = false;
                        mWakeLock.release();
                    }
                },
                1000
            );
        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        int gesture = (int) event.values[1];

        if (!mScreenOn && (gesture == IR_GESTURE_SWIPE || gesture == IR_GESTURE_APPROACH))
            mSensorAction.action();
    }

    @Override
    public void onAccuracyChanged(Sensor mSensor, int accuracy) {
    }

}
