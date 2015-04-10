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
import android.content.Intent;
import android.telephony.PhoneStateListener;
import android.telecom.TelecomManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import static android.telephony.TelephonyManager.*;

public class SilenceAction extends PhoneStateListener implements SensorAction {
    private static final String TAG = "CMActions";

    private Context mContext;
    private TelecomManager mTelecomManager;
    private boolean mIsRinging = false;

    public SilenceAction(Context context) {
        mContext = context;

        mTelecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        telephonyManager.listen(this, LISTEN_CALL_STATE);
    }

    @Override
    public void action() {
         if (mIsRinging) {
            Log.d(TAG, "Silencing ringer");
            // Safe to silence it again after it was silenced
            mTelecomManager.silenceRinger();
        }
    }

    @Override
    public synchronized void onCallStateChanged(int state, String incomingNumber) {
        if (state == CALL_STATE_RINGING && !mIsRinging) {
            mIsRinging = true;
        } else if (state != CALL_STATE_RINGING && mIsRinging) {
            mIsRinging = false;
        }
    }
}
