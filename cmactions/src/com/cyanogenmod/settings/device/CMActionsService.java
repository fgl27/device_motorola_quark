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

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.os.PowerManager;
import android.util.Log;

public class CMActionsService extends IntentService implements ScreenStateNotifier {
    private static final String TAG = "CMActions";

    private static final String GESTURE_IR_WAKE_KEY = "gesture_ir_wake";
    private static final String GESTURE_IR_SILENCE_KEY = "gesture_ir_silence";
    private static final String GESTURE_CAMERA_KEY = "gesture_camera";

    private DozeManager mDozeManager;
    private ScreenReceiver mScreenReceiver;

    private CameraActivationSensor mCameraActivationSensor;
    private IrGestureSensor mIrGestureSensor;
    private SensorBase[] mAllSensors;

    private Context mContext;

    private boolean mGestureIrWakeEnabled;
    private boolean mGestureIrSilenceEnabled;
    private boolean mGestureCameraEnabled;

    public CMActionsService(Context context) {
        super("CMActionService");
        mContext = context;

        Log.d(TAG, "Starting");

        mDozeManager = new DozeManager(context);
        mScreenReceiver = new ScreenReceiver(context, this);
        mAllSensors = new SensorBase[4];

        mCameraActivationSensor = new CameraActivationSensor(mContext);
        mAllSensors[0] = mCameraActivationSensor;

        mIrGestureSensor = new IrGestureSensor(mContext, mDozeManager);
        mAllSensors[1] = mIrGestureSensor;

        FlatUpSensor flatUpSensor = new FlatUpSensor(mContext, mDozeManager);
        mAllSensors[2] = flatUpSensor;

        StowSensor stowSensor = new StowSensor(mContext, mDozeManager);
        mAllSensors[3] = stowSensor;

        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(mContext);
        loadPreferences(sharedPrefs);
        sharedPrefs.registerOnSharedPreferenceChangeListener(mPrefListener);

        if (mGestureCameraEnabled) {
            mCameraActivationSensor.register();
        }
        if (mGestureIrWakeEnabled) {
            mIrGestureSensor.enable(IrGestureSensor.IR_GESTURE_WAKE_ENABLED);
        }
        if (mGestureIrSilenceEnabled) {
            mIrGestureSensor.enable(IrGestureSensor.IR_GESTURE_SILENCE_ENABLED);
        }

        stowSensor.register();

        PowerManager powerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        if (powerManager.isInteractive()) {
            screenTurnedOn();
        } else {
            screenTurnedOff();
        }
    }

    @Override
    protected void onHandleIntent(Intent intent) {
    }

    @Override
    public void screenTurnedOn() {
        mDozeManager.setScreenOn(true);
        for (int i = 0; i < mAllSensors.length; i++) {
            mAllSensors[i].setScreenOn(true);
        }
    }

    @Override
    public void screenTurnedOff() {
        mDozeManager.setScreenOn(false);
        for (int i = 0; i < mAllSensors.length; i++) {
            mAllSensors[i].setScreenOn(false);
        }
    }

    private void loadPreferences(SharedPreferences sharedPreferences) {
        mGestureIrWakeEnabled = sharedPreferences.getBoolean(GESTURE_IR_WAKE_KEY, true);
        mGestureIrSilenceEnabled = sharedPreferences.getBoolean(GESTURE_IR_SILENCE_KEY, true);
        mGestureCameraEnabled = sharedPreferences.getBoolean(GESTURE_CAMERA_KEY, true);
    }

    private SharedPreferences.OnSharedPreferenceChangeListener mPrefListener =
            new SharedPreferences.OnSharedPreferenceChangeListener() {
        @Override
        public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
            if (GESTURE_IR_WAKE_KEY.equals(key)) {
                mGestureIrWakeEnabled = sharedPreferences.getBoolean(GESTURE_IR_WAKE_KEY, true);
                if (mGestureIrWakeEnabled) {
                    mIrGestureSensor.enable(IrGestureSensor.IR_GESTURE_WAKE_ENABLED);
                } else {
                    mIrGestureSensor.disable(IrGestureSensor.IR_GESTURE_WAKE_ENABLED);
                }
            } else if (GESTURE_IR_SILENCE_KEY.equals(key)) {
                mGestureIrSilenceEnabled = sharedPreferences.getBoolean(GESTURE_IR_SILENCE_KEY, true);
                if (mGestureIrSilenceEnabled) {
                    mIrGestureSensor.enable(IrGestureSensor.IR_GESTURE_SILENCE_ENABLED);
                } else {
                    mIrGestureSensor.disable(IrGestureSensor.IR_GESTURE_SILENCE_ENABLED);
                }
            } else if (GESTURE_CAMERA_KEY.equals(key)) {
                mGestureCameraEnabled = sharedPreferences.getBoolean(GESTURE_CAMERA_KEY, true);
                if (mGestureCameraEnabled) {
                    mCameraActivationSensor.register();
                } else {
                    mCameraActivationSensor.unregister();
                }
            }
        }
    };
}
