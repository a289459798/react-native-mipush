package com.ichong.zzy.mipush;

import com.facebook.react.bridge.*;
import com.xiaomi.mipush.sdk.MiPushClient;

/**
 * Created by zzy on 16/8/11.
 * Date : 16/8/11 13:22
 */
public class MIPushModule extends ReactContextBaseJavaModule {
    public MIPushModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "MIPushModule";
    }

    @ReactMethod
    public void setAlias(String text) {

        MiPushClient.setAlias(getReactApplicationContext(), text, null);
    }

    @ReactMethod
    public void unsetAlias(String text) {

        MiPushClient.unsetAlias(getReactApplicationContext(), text, null);
    }

    @ReactMethod
    public void subscribe(String text) {

        MiPushClient.subscribe(getReactApplicationContext(), text, null);
    }

    @ReactMethod
    public void unsubscribe(String text) {

        MiPushClient.unsubscribe(getReactApplicationContext(), text, null);
    }

    @ReactMethod
    public void setAccount(String text) {

        MiPushClient.setUserAccount(getReactApplicationContext(), text, null);
    }

    @ReactMethod
    public void unsetAccount(String text) {

        MiPushClient.setAlias(getReactApplicationContext(), text, null);
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

        MiPushClient.clearNotification(getReactApplicationContext(), id);
    }

    @ReactMethod
    public void clearAllNotification() {

        MiPushClient.clearNotification(getReactApplicationContext());
    }

}
