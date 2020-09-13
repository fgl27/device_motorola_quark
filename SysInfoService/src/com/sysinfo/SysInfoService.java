/*
 * Copyright (c) 2017-2020 Felipe de Leon <fglfgl27@gmail.com>
 * This file is part of SysInfoService <https://github.com/fgl27/device_motorola_quark>
 *
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

package com.sysinfo;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import androidx.core.graphics.ColorUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Objects;

import static android.os.Process.getFreeMemory;
import static android.os.Process.getTotalMemory;

public class SysInfoService extends Service {
    private View mView;
    private Thread mCurCPUThread;
    private final String TAG = "SysInfoService";
    private Paint mOnlinePaint;
    private Paint mOfflinePaint;
    private int textSize;
    private final String maxWidthStr = " CORE:0 ondemandplus:2880 MHz U 100% T 30°C "; // probably biggest possible

    private class CPUView extends View {

        private float mAscent;
        private int mFH;
        private int mMaxWidth;

        private int mNeededWidth;
        private int mNeededHeight;

        private boolean mDataAvail;

        private MessageObj msgObj;

        private Handler mCurCPUHandler = new Handler() {
            public void handleMessage(Message msg) {
                if (msg.obj == null) return;

                if (msg.what == 1) {
                    msgObj = (MessageObj) msg.obj;
                    mDataAvail = true;
                    updateDisplay(msgObj.LinesOffset);
                }

            }
        };

        CPUView(Context c) {
            super(c);
            SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(c);

            float density = c.getResources().getDisplayMetrics().density;
            int paddingPx = Math.round(5 * density);
            setPadding(paddingPx, paddingPx, paddingPx, paddingPx);
            setBackgroundColor(backgroundColor(sharedPreferences));

            textSize = Math.round(12 * density);

            mOnlinePaint = TextColor(
                    Colors[Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_TEXT_COLOR, "7"))],
                    textSize
            );
            mOfflinePaint = TextColor(
                    Colors[Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_TEXT_OFFLINE_COLOR, "6"))],
                    textSize
            );

            mAscent = mOnlinePaint.ascent();
            float descent = mOnlinePaint.descent();
            mFH = (int)(descent - mAscent + .5f);

            mMaxWidth = (int) mOnlinePaint.measureText(maxWidthStr);
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
            setMeasuredDimension(
                    resolveSize(mNeededWidth, widthMeasureSpec),
                    resolveSize(mNeededHeight, heightMeasureSpec)
            );
        }

        @Override
        public void onDraw(Canvas canvas) {
            super.onDraw(canvas);
            if (!mDataAvail) return;

            int x = (getWidth() - 1) - mPaddingRight - mMaxWidth;
            int y = ((mPaddingTop - (int) mAscent) - 1);

            int i, len = msgObj.TopLinesLen;

            for (i = 0; i < len; i++) {
                canvas.drawText(msgObj.TopLines.get(i), x, y, mOnlinePaint);
                y += mFH;
            }

            len = msgObj.CpuCoreLinesLen;

            for (i = 0; i < len; i++) {
                if (msgObj.CpuCoreLines[i] != null) {
                    canvas.drawText("CORE:" + i + " " + msgObj.CpuCoreLines[i], x, y, mOnlinePaint);
                } else {
                    canvas.drawText("CORE:" + i + " offline", x, y, mOfflinePaint);
                }
                y += mFH;
            }
            mDataAvail = false;
        }

        //Call updateDisplay to force a call of onDraw
        void updateDisplay(int LinesOffset) {
            int neededWidth = mPaddingLeft + mPaddingRight + mMaxWidth;
            int neededHeight = mPaddingTop + mPaddingBottom + (mFH * (LinesOffset));

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
        private final long totalMem;
        private final Handler mHandler;
        private final int numCpus;

        private int mBatAmperage = 0;
        private String currFreq, currGov;
        private String[] CpuCoreLines;
        private ArrayList<String> TopLines;
        private StringBuilder TopLinesBuilder;
        private StringBuilder CpuCoreLinesBuilder;

        public CurCPUThread(Handler handler, int numCpus) {
            this.mHandler = handler;
            this.numCpus = numCpus;
            this.totalMem = getTotalMemory();
        }

        public void interrupt() {
            mInterrupt = true;
        }

        @Override
        public void run() {
            try {
                while (!mInterrupt) {
                    sleep(500);
                    TopLines = new ArrayList<>();

                    mBatAmperage = Integer.valueOf(SysInfoService.readOneLine(Constants.BAT_AMP)) / 1000;
                    TopLinesBuilder = new StringBuilder();
                    TopLinesBuilder
                            .append("BAT: ")
                            .append(Integer.valueOf(SysInfoService.readOneLine(Constants.BAT_VOLTS)) / 1000)
                            .append("mV ")
                            .append(mBatAmperage > 0 ? "+" : "")
                            .append(mBatAmperage)
                            .append("mA ")
                            .append(Integer.valueOf(SysInfoService.readOneLine(Constants.BAT_TEMP)) / 10)
                            .append("°C ")
                            .append(SysInfoService.readOneLine(Constants.BAT_CAPACITY))
                            .append("%");
                    TopLines.add(TopLinesBuilder.toString());

                    TopLinesBuilder = new StringBuilder();
                    TopLinesBuilder
                            .append("RAM: ")
                            .append(SysInfoService.readOneLine(Constants.RAM_GOV))
                            .append(": ")
                            .append(Math.rint(Integer.valueOf(SysInfoService.readOneLine(Constants.RAM_CUR_FREQ)) / 15.255))
                            .append("MHz ")
                            .append(((totalMem - getFreeMemory()) * 100L) / totalMem)
                            .append("%");
                    TopLines.add(TopLinesBuilder.toString());

                    TopLinesBuilder = new StringBuilder();
                    TopLinesBuilder
                            .append("GPU: ")
                            .append(SysInfoService.readOneLine(Constants.GPU_GOV))
                            .append(": ")
                            .append(Integer.valueOf(SysInfoService.readOneLine(Constants.GPU_FREQ)) / 1000000)
                            .append("MHz ")
                            .append(SysInfoService.readOneLine(Constants.THERMAL_ZONE + "10/temp"))
                            .append("°C")
                            .append(SysInfoService.getGPUBusy(Constants.GPU_BUSY));
                    TopLines.add(TopLinesBuilder.toString());

                    CpuCoreLines = new String[numCpus];
                    for (int i = 0; i < numCpus; i++) {

                        currFreq = SysInfoService.readOneLine(Constants.CPU_ROOT + i + Constants.CPU_CUR_TAIL);

                        if (currFreq.equals("0")) CpuCoreLines[i] = null;//core is offline
                        else {

                            CpuCoreLinesBuilder = new StringBuilder();
                            CpuCoreLinesBuilder
                                    .append(SysInfoService.readOneLine(Constants.CPU_ROOT + i + Constants.CPU_GOV_TAIL))
                                    .append(": ")
                                    .append(Integer.valueOf(currFreq) / 1000)
                                    .append("MHz ")
                                    .append(SysInfoService.readOneLine(Constants.THERMAL_ZONE + (i + 6) + "/temp"))
                                    .append("°C ")
                                    .append(SysInfoService.readOneLine(Constants.CPU_ROOT + i + Constants.CPU_UTI_TAIL))
                                    .append("%");

                            CpuCoreLines[i] = CpuCoreLinesBuilder.toString();

                        }

                    }

                    mHandler.sendMessage(
                            mHandler.obtainMessage(
                                    1,
                                    new MessageObj(
                                            TopLines,
                                            CpuCoreLines
                                    )
                            )
                    );
                }
            } catch (InterruptedException e) {
                return;
            }
        }
    };

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (mView == null) return START_NOT_STICKY;

        String action = intent.getAction();
        Context context = this.getApplicationContext();
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);

        if (Objects.equals(action, Constants.SERVICE_POSITION)) {

            WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
            wm.updateViewLayout(mView, getViewLayout(context));

        } else if (Objects.equals(action, Constants.SERVICE_BACKGROUND_OPACITY) || Objects.equals(action, Constants.SERVICE_BACKGROUND_COLOR)) {

            mView.setBackgroundColor(backgroundColor(sharedPreferences));

        } else if (Objects.equals(action, Constants.SERVICE_TEXT_COLOR)) {

            mOnlinePaint = TextColor(
                    Colors[Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_TEXT_COLOR, "7"))],
                    textSize
            );

        }else if (Objects.equals(action, Constants.SERVICE_TEXT_OFFLINE_COLOR)) {

            mOfflinePaint = TextColor(
                    Colors[Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_TEXT_OFFLINE_COLOR, "6"))],
                    textSize
            );

        }

        return START_NOT_STICKY;
    }

    private final int[] GravityPositions = {
            Gravity.START | Gravity.TOP,//0
            Gravity.CENTER | Gravity.TOP,//1
            Gravity.END | Gravity.TOP,//2
            Gravity.START | Gravity.BOTTOM,//3
            Gravity.CENTER | Gravity.BOTTOM,//4
            Gravity.END | Gravity.BOTTOM//5
    };

    @Override
    public void onCreate() {
        super.onCreate();

        mView = new CPUView(this);

        mCurCPUThread = new CurCPUThread(mView.getHandler(), Runtime.getRuntime().availableProcessors());
        mCurCPUThread.start();

        WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        wm.addView(mView, getViewLayout(this.getApplicationContext()));

        Log.d(TAG, "started CurCPUThread");
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

    private WindowManager.LayoutParams getViewLayout(Context context) {
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_SECURE_SYSTEM_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                PixelFormat.TRANSLUCENT
        );
        params.gravity =
                GravityPositions[Integer.valueOf(PreferenceManager.getDefaultSharedPreferences(context).getString(Constants.SERVICE_POSITION, "1"))];
        params.setTitle(TAG);

        return params;
    }

    private final int[] Colors = {
            Color.BLACK,//0
            Color.BLUE,//1
            Color.CYAN,//2
            Color.GRAY,//3
            Color.GREEN,//4
            Color.MAGENTA,//5
            Color.RED,//6
            Color.WHITE,//7
            Color.YELLOW//8
    };

    private int backgroundColor(SharedPreferences sharedPreferences) {
        float percentage = (float) (Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_BACKGROUND_OPACITY, "4")) / 10.0f);

        return ColorUtils.setAlphaComponent(
                Colors[Integer.valueOf(sharedPreferences.getString(Constants.SERVICE_BACKGROUND_COLOR, "0"))],
                (int) (255 * percentage)
        );
    }

    private Paint TextColor(int color, int textSize) {
        Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setTextSize(textSize);
        paint.setColor(color);
        paint.setShadowLayer(5.0f, 0.0f, 0.0f, Color.BLACK);

        return paint;
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
        String[] val = SysInfoService.readOneLine(path).trim().split("\\s+");
        if (val.length == 2) {

            float arg1 = Float.valueOf(val[0]);
            float arg2 = Float.valueOf(val[1]);

            return arg2 == 0 ? " 0%" : (" " + Math.round((arg1 / arg2 * 100) + 0.5f) + "%");
        } else return "";
    }

    public static class MessageObj {
        private final ArrayList<String> TopLines;
        private final int TopLinesLen;//BAT, RAM, GPU
        private final int CpuCoreLinesLen;
        private final int LinesOffset;
        private final String[] CpuCoreLines;

        public MessageObj(ArrayList<String> TopLines, String[] CpuCoreLines) {
            this.TopLines = TopLines;
            this.CpuCoreLines = CpuCoreLines;
            this.CpuCoreLinesLen = CpuCoreLines.length;
            this.TopLinesLen = TopLines.size();
            this.LinesOffset = this.CpuCoreLinesLen + TopLinesLen;
        }

    }
}
