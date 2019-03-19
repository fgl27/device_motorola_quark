/*
 * Copyright (C) 2007 The Android Open Source Project
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
package com.android.systemui;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import java.lang.StringBuffer;

public class CPUInfoService extends Service {
    private View mView;
    private Thread mCurCPUThread;
    private final String TAG = "CPUInfoService";
    private int mNumCpus = 1;
    private String[] mCurrFreq = null;
    private String[] mCurrGov = null;

    private class CPUView extends View {
        private Paint mOnlinePaint;
        private Paint mOfflinePaint;
        private float mAscent;
        private int mFH;
        private int mMaxWidth;

        private int mNeededWidth;
        private int mNeededHeight;

        private String mBAT;
        private String mGPU;
        private String mRAM;
        private boolean mDataAvail;

        private int LinesOffset = 3; // +1 for it initial line mBAT, mGPU and mRAM etc etc

        private Handler mCurCPUHandler = new Handler() {
            public void handleMessage(Message msg) {
                if (msg.obj == null) {
                    return;
                }
                if (msg.what == 1) {
                    String msgData = (String) msg.obj;
                    try {
                        String[] parts = msgData.split(";");
                        mBAT = parts[0];
                        mRAM = parts[1];
                        mGPU = parts[2];

                        String[] cpuParts = parts[3].split("\\|");
                        for (int i = 0; i < cpuParts.length; i++) {
                            String cpuInfo = cpuParts[i];
                            String cpuInfoParts[] = cpuInfo.split(":");
                            if (cpuInfoParts.length == 2) {
                                mCurrFreq[i] = cpuInfoParts[0];
                                mCurrGov[i] = cpuInfoParts[1];
                            } else {
                                mCurrFreq[i] = "0";
                                mCurrGov[i] = "";
                            }
                        }
                        mDataAvail = true;
                        updateDisplay();
                    } catch (ArrayIndexOutOfBoundsException e) {
                        Log.e(TAG, "illegal data " + msgData);
                    }
                }
            }
        };

        CPUView(Context c) {
            super(c);
            float density = c.getResources().getDisplayMetrics().density;
            int paddingPx = Math.round(5 * density);
            setPadding(paddingPx, paddingPx, paddingPx, paddingPx);
            setBackgroundColor(Color.argb(0x60, 0, 0, 0));

            final int textSize = Math.round(12 * density);

            mOnlinePaint = new Paint();
            mOnlinePaint.setAntiAlias(true);
            mOnlinePaint.setTextSize(textSize);
            mOnlinePaint.setColor(Color.WHITE);
            mOnlinePaint.setShadowLayer(5.0f, 0.0f, 0.0f, Color.BLACK);

            mOfflinePaint = new Paint();
            mOfflinePaint.setAntiAlias(true);
            mOfflinePaint.setTextSize(textSize);
            mOfflinePaint.setColor(Color.RED);

            mAscent = mOnlinePaint.ascent();
            float descent = mOnlinePaint.descent();
            mFH = (int)(descent - mAscent + .5f);

            final String maxWidthStr = " CORE:0 ondemandplus:2880 MHz U 100% T 30°C "; // probably biggest possible
            mMaxWidth = (int) mOnlinePaint.measureText(maxWidthStr);

            updateDisplay();
        }

        @Override
        protected void onAttachedToWindow() {
            super.onAttachedToWindow();
        }

        @Override
        protected void onDetachedFromWindow() {
            super.onDetachedFromWindow();
            mCurCPUHandler.removeMessages(1);
        }

        @Override
        protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
            setMeasuredDimension(resolveSize(mNeededWidth, widthMeasureSpec),
                resolveSize(mNeededHeight, heightMeasureSpec));
        }

        private String getCPUInfoString(int i) {
            String freq = mCurrFreq[i];
            String gov = mCurrGov[i];
            return "CORE:" + i + " " + gov + ": " + freq;
        }

        @Override
        public void onDraw(Canvas canvas) {
            super.onDraw(canvas);
            if (!mDataAvail) {
                return;
            }

            int x = (getWidth() - 1) - mPaddingRight - mMaxWidth;
            int y = ((mPaddingTop - (int) mAscent) - 1);

            canvas.drawText("BAT: " + mBAT, x, y, mOnlinePaint);
            y += mFH;
            canvas.drawText("RAM: " + mRAM, x, y, mOnlinePaint);
            y += mFH;
            canvas.drawText("GPU: " + mGPU, x, y, mOnlinePaint);
            y += mFH;

            for (int i = 0; i < mCurrFreq.length; i++) {
                String s = getCPUInfoString(i);
                String freq = mCurrFreq[i];
                if (!freq.equals("0")) {
                    canvas.drawText(s, x, y, mOnlinePaint);
                } else {
                    canvas.drawText(s, x, y, mOfflinePaint);
                }
                y += mFH;
            }

        }

        void updateDisplay() {
            if (!mDataAvail) {
                return;
            }
            final int NW = mNumCpus + LinesOffset;

            int neededWidth = mPaddingLeft + mPaddingRight + mMaxWidth;
            int neededHeight = mPaddingTop + mPaddingBottom + (mFH * (NW));
            if (neededWidth != mNeededWidth || neededHeight != mNeededHeight) {
                mNeededWidth = neededWidth;
                mNeededHeight = neededHeight;
                requestLayout();
            } else {
                invalidate();
            }
        }

        public Handler getHandler() {
            return mCurCPUHandler;
        }
    }

    protected class CurCPUThread extends Thread {
        private boolean mInterrupt = false;
        private Handler mHandler;

        //Common paths
        private String CURRENT_CPU = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq";
        private String CPU_ROOT = "/sys/devices/system/cpu/cpu";
        private String CPU_CUR_TAIL = "/cpufreq/scaling_cur_freq";
        private String CPU_UTI_TAIL = "/cpufreq/cpu_utilization";
        private String CPU_GOV_TAIL = "/cpufreq/scaling_governor";
        private String BATTERY_PARAMETERS = "/sys/class/power_supply/battery";
        private String BAT_VOLTS = BATTERY_PARAMETERS + "/voltage_now";
        private String BAT_AMP = BATTERY_PARAMETERS + "/current_avg";
        private String BAT_TEMP = BATTERY_PARAMETERS + "/temp";
        private String TEMP = "/sys/class/thermal/thermal_zone"; //apq8084 zones bat=0, cpu_soq=1, core0-3=6-9, gpu=10
        //Bellow are the apq8084/quark path others devices may be different path all together or just the end eg qcom,cpubw.**
        private String GPU_FREQ = "/sys/devices/fdb00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/gpuclk";
        private String GPU_GOV = "/sys/class/kgsl/kgsl-3d0/devfreq/governor";
        private String GPU_BUSY = "/sys/class/kgsl/kgsl-3d0/gpubusy";
        private String RAM_CUR_FREQ = "/sys/class/devfreq/qcom,cpubw.35/cur_freq";
        private String RAM_GOV = "/sys/class/devfreq/qcom,cpubw.35/governor";

        private String currFreq, currGov;
        private StringBuffer sb;

        private int mBatAmperage = 0;

        public CurCPUThread(Handler handler, int numCpus) {
            mHandler = handler;
            mNumCpus = numCpus;
        }

        public void interrupt() {
            mInterrupt = true;
        }

        @Override
        public void run() {
            try {
                while (!mInterrupt) {
                    sleep(500);
                    sb = new StringBuffer();

                    //TEMP Battery and CPU SOCKET
                    mBatAmperage = Integer.valueOf(CPUInfoService.readOneLine(BAT_AMP)) / 1000;
                    sb.append((Integer.valueOf(CPUInfoService.readOneLine(BAT_VOLTS)) / 1000) + "mV " +
                        (mBatAmperage > 0 ? "+" : "") + mBatAmperage + "mA " +
                        (Integer.valueOf(CPUInfoService.readOneLine(BAT_TEMP)) / 10) + "°C;");

                    //RAM
                    sb.append(CPUInfoService.readOneLine(RAM_GOV) + ": " +
                        ((int) Math.rint(Integer.valueOf(CPUInfoService.readOneLine(RAM_CUR_FREQ)) / 15.255) + "MHz;"));

                    //GPU
                    sb.append(CPUInfoService.readOneLine(GPU_GOV) + ": " +
                        ((Integer.valueOf(CPUInfoService.readOneLine(GPU_FREQ)) / 1000000) + "MHz ") +
                        (CPUInfoService.readOneLine(TEMP + "10/temp") + "°C") +
                        CPUInfoService.getGPUBusy(GPU_BUSY));

                    //CPU CORES
                    for (int i = 0; i < mNumCpus; i++) {
                        currFreq = CPUInfoService.readOneLine(CPU_ROOT + i + CPU_CUR_TAIL);
                        if (currFreq == "0") currGov = "";
                        else {
                            currGov = CPUInfoService.readOneLine(CPU_ROOT + i + CPU_GOV_TAIL);
                            currFreq = (Integer.valueOf(currFreq) / 1000) + "MHz " +
                                (CPUInfoService.readOneLine(TEMP + (i + 6) + "/temp") + "°C ") +
                                (CPUInfoService.readOneLine(CPU_ROOT + i + CPU_UTI_TAIL) + "%");
                        }
                        sb.append(currFreq + ":" + currGov + "|");
                    }

                    sb.deleteCharAt(sb.length() - 1);
                    mHandler.sendMessage(mHandler.obtainMessage(1, sb.toString()));
                }
            } catch (InterruptedException e) {
                return;
            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        mNumCpus = Runtime.getRuntime().availableProcessors();
        mCurrFreq = new String[mNumCpus];
        mCurrGov = new String[mNumCpus];

        mView = new CPUView(this);
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_SECURE_SYSTEM_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            PixelFormat.TRANSLUCENT);
        params.gravity = Gravity.START | Gravity.TOP;
        params.setTitle("CPU Info");

        mCurCPUThread = new CurCPUThread(mView.getHandler(), mNumCpus);
        mCurCPUThread.start();

        Log.d(TAG, "started CurCPUThread");

        WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        wm.addView(mView, params);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mCurCPUThread.isAlive()) {
            mCurCPUThread.interrupt();
            try {
                mCurCPUThread.join();
            } catch (InterruptedException e) {}
        }
        Log.d(TAG, "stopped CurCPUThread");
        ((WindowManager) getSystemService(WINDOW_SERVICE)).removeView(mView);
        mView = null;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private static String readOneLine(String fname) {
        BufferedReader br;
        String line = "0";
        try {
            br = new BufferedReader(new FileReader(fname), 512);
            try {
                line = br.readLine();
            } finally {
                br.close();
            }
        } catch (Exception e) {
            return "0";
        }
        return line;
    }

    public static String getGPUBusy(String path) {
        String[] val = CPUInfoService.readOneLine(path).trim().split("\\s+");
        if (val.length == 2) {

            float arg1 = Float.valueOf(val[0]);
            float arg2 = Float.valueOf(val[1]);

            return arg2 == 0 ? " 0%;" : (" " + Math.round((arg1 / arg2 * 100) + 0.5f) + "%;");
        } else return ";";
    }
}
