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

import java.util.Timer;
import java.util.TimerTask;

import static com.lineageos.settings.device.IrGestureManager.*;

public class IrGestureSensor implements ScreenStateNotifier, SensorEventListener {
    private static final String TAG = "LineageActions-IRGestureSensor";

    private static final int IR_GESTURES_FOR_SCREEN_OFF = (1 << IR_GESTURE_SWIPE) | (1 << IR_GESTURE_APPROACH);

    private final LineageActionsSettings mLineageActionsSettings;
    private final SensorHelper mSensorHelper;
    private final SensorAction mSensorAction;
    private final IrGestureVote mIrGestureVote;
    private final Sensor mSensor;

    private final PowerManager mPowerManager;
    private WakeLock mWakeLock;

    private boolean mEnabled, mScreenOn;

    private Timer setScreenTimer = new Timer();

    public IrGestureSensor(LineageActionsSettings LineageActionsSettings, SensorHelper sensorHelper,
        SensorAction action, IrGestureManager irGestureManager, Context context) {
        mLineageActionsSettings = LineageActionsSettings;
        mSensorHelper = sensorHelper;
        mSensorAction = action;
        mIrGestureVote = new IrGestureVote(irGestureManager);

        mSensor = sensorHelper.getIrGestureSensor();
        mIrGestureVote.voteForSensors(0);

        mPowerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, TAG);
    }

    @Override
    public void screenTurnedOn() {
        mScreenOn = true;

        setScreenTimer.cancel();
        setScreenTimer.purge();
        setScreenTimer = new Timer();

        if (mEnabled) {
            setScreenTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    if (mEnabled && mScreenOn) {
                        mSensorHelper.unregisterListener(IrGestureSensor.this);
                        mIrGestureVote.voteForSensors(0);
                        mEnabled = false;
                    }
                }
            }, 1000);

        }
    }

    @Override
    public void screenTurnedOff() {
        mScreenOn = false;

        setScreenTimer.cancel();
        setScreenTimer.purge();
        setScreenTimer = new Timer();

        if (mLineageActionsSettings.isIrWakeupEnabled() && !mEnabled) {
            if (mWakeLock == null)
                mWakeLock = mPowerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, TAG);

            if (!mWakeLock.isHeld()) {
                mWakeLock.setReferenceCounted(false);
                mWakeLock.acquire();
            }

            setScreenTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    if (!mEnabled && !mScreenOn) {
                        mSensorHelper.registerListener(mSensor, IrGestureSensor.this);
                        mIrGestureVote.voteForSensors(IR_GESTURES_FOR_SCREEN_OFF);
                        mEnabled = true;
                    }
                    mWakeLock.release();
                }
            }, 1000);

        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        int gesture = (int) event.values[1];

        if (!mScreenOn && (gesture == IR_GESTURE_SWIPE || gesture == IR_GESTURE_APPROACH))
            mSensorAction.action();
    }

    @Override
    public void onAccuracyChanged(Sensor mSensor, int accuracy) {}

}