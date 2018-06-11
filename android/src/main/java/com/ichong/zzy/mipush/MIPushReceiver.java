package com.ichong.zzy.mipush;

import android.content.Context;
import android.content.Intent;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.xiaomi.mipush.sdk.MiPushMessage;
import com.xiaomi.mipush.sdk.PushMessageReceiver;

/**
 * Created by zzy on 16/8/13.
 * Date : 16/8/13 12:11
 */
public class MIPushReceiver extends PushMessageReceiver {

    /**
     * 接受服务端发送过来的透传消息
     * @param context
     * @param miPushMessage
     */
    @Override
    public void onReceivePassThroughMessage(Context context, MiPushMessage miPushMessage) {
        super.onReceivePassThroughMessage(context, miPushMessage);

        sendListener("xmpush_message", miPushMessage);
    }

    /**
     * 监听用户点击通知栏消息
     * @param context
     * @param miPushMessage
     */
    @Override
    public void onNotificationMessageClicked(Context context, MiPushMessage miPushMessage) {
        super.onNotificationMessageClicked(context, miPushMessage);

        Intent intent = new Intent();
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        if(MIPushPackage.sReactContext == null) {
            // 将数据保存
            MIPushPackage.sMiPushMessage = miPushMessage;

            String packageName = context.getApplicationContext().getPackageName();
            Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
            launchIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
            context.startActivity(launchIntent);
            return;
        }
        sendListener("xmpush_click", miPushMessage);

        if(MIPushPackage.sReactContext.getCurrentActivity() != null) {

            intent.setClass(context, MIPushPackage.sReactContext.getCurrentActivity().getClass());
            context.startActivity(intent);
        } else {

            String packageName = context.getApplicationContext().getPackageName();
            Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
            context.startActivity(launchIntent);
        }

    }

    /**
     * 消息达到客户端触发
     * @param context
     * @param miPushMessage
     */
    @Override
    public void onNotificationMessageArrived(Context context, MiPushMessage miPushMessage) {
        super.onNotificationMessageArrived(context, miPushMessage);

        sendListener("xmpush_notify", miPushMessage);
    }

    private void sendListener(String type, MiPushMessage miPushMessage) {

        MIPushPackage.sReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(type, MIPushHelper.parsePushMessage(miPushMessage));
    }

    /*
        注册regid消息
    */
    @Override
    onReceiveRegisterResult(Context context, MiPushCommandMessage message) {
        super.onReceiveRegisterResult(context, message);
        sendListener("RemoteNotificationsRegistered", message);
    }

}
