package com.ichong.zzy.mipush;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Process;
import android.util.Log;
import com.facebook.react.bridge.*;
import com.xiaomi.channel.commonutils.logger.LoggerInterface;
import com.xiaomi.mipush.sdk.Logger;
import com.xiaomi.mipush.sdk.MiPushClient;

import java.util.List;

import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by zzy on 16/8/11.
 * Date : 16/8/11 13:22
 */
public class MIPushModule extends ReactContextBaseJavaModule {

    private Context mContext;

    public MIPushModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = getReactApplicationContext();
    }

    @Override
    public String getName() {
        return "MIPushModule";
    }

    @ReactMethod
    public void init(String appid, String appkey) {

        try {

            if (shouldInit(mContext)) {

                MiPushClient.registerPush(mContext, appid, appkey);
            }

            //打开Log
            LoggerInterface newLogger = new LoggerInterface() {

                @Override
                public void setTag(String tag) {
                    // ignore
                }

                @Override
                public void log(String content, Throwable t) {
                    Log.d(TAG, content, t);
                }

                @Override
                public void log(String content) {
                    Log.d(TAG, content);
                }
            };
            Logger.setLogger(mContext, newLogger);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void setAlias(String text) {

        MiPushClient.setAlias(mContext, text, null);
    }

    @ReactMethod
    public void unsetAlias(String text) {

        MiPushClient.unsetAlias(mContext, text, null);
    }

    @ReactMethod
    public void subscribe(String text) {

        MiPushClient.subscribe(mContext, text, null);
    }

    @ReactMethod
    public void unsubscribe(String text) {

        MiPushClient.unsubscribe(mContext, text, null);
    }

    @ReactMethod
    public void setAccount(String text) {

        MiPushClient.setUserAccount(mContext, text, null);
    }

    @ReactMethod
    public void unsetAccount(String text) {

        MiPushClient.setAlias(mContext, text, null);
    }


    @ReactMethod
    public void presentLocalNotification(ReadableMap notification) {

    }

    @ReactMethod
    public void getInitialNotification(
        Promise promise) {

        promise.resolve(MIPushHelper.parsePushMessage(MIPushPackage.sMiPushMessage));

        MIPushPackage.sMiPushMessage = null;
    }

    @ReactMethod
    public void clearNotification(int id) {

        MiPushClient.clearNotification(mContext, id);
    }

    @ReactMethod
    public void clearAllNotification() {

        MiPushClient.clearNotification(mContext);
    }

    private boolean shouldInit(Context context) {
        ActivityManager am = ((ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE));
        List<ActivityManager.RunningAppProcessInfo> processInfos = am.getRunningAppProcesses();
        String mainProcessName = context.getPackageName();
        int myPid = Process.myPid();
        for (ActivityManager.RunningAppProcessInfo info : processInfos) {
            if (info.pid == myPid && mainProcessName.equals(info.processName)) {
                return true;
            }
        }
        return false;
    }

}
