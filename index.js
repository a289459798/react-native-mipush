/**
 * Created by zhangzy on 16/7/27.
 */

'use strict';

import {
    NativeModules,
    Platform,
    PushNotificationIOS,
    NativeEventEmitter,
    PermissionsAndroid,
} from 'react-native';

const MIPushModule = NativeModules.MIPushModule;

/**
 * 获取app的版本名称\版本号和渠道名
 */
class MIPush extends NativeEventEmitter {

    // 构造
    constructor(props) {
        super(MIPushModule);
        // 初始状态
        this.state = {};
    }

    init(appid, appkey) {

        if (Platform.OS == 'android') {
            PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE).then((state) => {
                if (state) {
                    MIPushModule.init(appid, appkey);
                } else {
                    PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE).then((granted) => {
                        if (granted === PermissionsAndroid.RESULTS.GRANTED) {
                            MIPushModule.init(appid, appkey);
                        }
                    });
                }
            });
        }
    }

    /**
     * 设置别名
     * @param text
     */
    setAlias(text) {

        MIPushModule.setAlias(text);
    }

    /**
     * 注销别名
     * @param text
     */
    unsetAlias(text) {

        MIPushModule.unsetAlias(text);
    }

    /**
     * 设置主题,类似tag
     * @param text
     */
    subscribe(text) {

        MIPushModule.subscribe(text);
    }

    /**
     * 注销主题
     * @param text
     */
    unsubscribe(text) {

        MIPushModule.unsubscribe(text);
    }

    /**
     * 设置账号,一个账号需要多台设备接收通知
     * @param text
     */
    setAccount(text) {

        MIPushModule.setAccount(text);
    }

    /**
     * 注销账号
     * @param text
     */
    unsetAccount(text) {

        MIPushModule.unsetAccount(text);
    }

    /**
     *
     * @param type
     * ios :
     * notification => 监听收到apns通知
     * localNotification => 监听收到本地通知
     * register => 注册deviceToken 通知
     *
     * android :
     * xmpush_notify => 监听收到推送
     * xmpush_click => 监听推送被点击
     * xmpush_message => 监听收到透传消息
     * @param handler
     */
    addEventListener(type, handler) {

        if (Platform.OS == 'ios') {

            switch (type) {
                case 'notification':
                case 'localNotification':
                case 'register':
                    PushNotificationIOS.addEventListener(type, handler);
                    break;
                default:
                    this.addListener(type, handler);
                    break;
            }

        } else {

            this.addListener(type, handler);
        }
    }

    removeEventListener(type) {

        if (Platform.OS == 'ios') {

            switch (type) {
                case 'notification':
                case 'localNotification':
                case 'register':
                    PushNotificationIOS.removeEventListener(type);
                    break;
                default:
                    this.removeListener(type);
                    break;
            }

        } else {

            this.removeListener(type);
        }
    }

    /**
     * 发送一个本地通知
     * @param notification
     */
    presentLocalNotification(notification) {

        if (Platform.OS == 'ios') {

            PushNotificationIOS.presentLocalNotification({

                alertBody: notification.alertBody,
                alertAction: '查看',
                category: 'push',
                userInfo: notification.userInfo,

            });
        } else {

            MIPushModule.presentLocalNotification({});
        }
    }

    /**
     * 清除指定通知
     * @param notifyId
     * ios : userInfo
     * android : id
     */
    clearNotification(notifyId) {

        if (Platform.OS == 'ios') {

            PushNotificationIOS.cancelLocalNotifications(notifyId);
        } else {

            MIPushModule.clearNotification(notifyId);
        }

    }

    /**
     * 清除所有通知
     */
    clearNotifications() {

        if (Platform.OS == 'ios') {

            PushNotificationIOS.cancelAllLocalNotifications();
        } else {

            MIPushModule.clearAllNotification();
        }
    }

    /**
     * 设置角标,仅支持ios
     * @param num
     */
    setBadgeNumber(num) {

        if (Platform.OS == 'ios') {

            PushNotificationIOS.setApplicationIconBadgeNumber(num);
        }

    }

    /**
     * 通过点击通知启动app
     * @param handler
     */
    getInitialNotification(handler) {

        if (Platform.OS == 'ios') {

            PushNotificationIOS.getInitialNotification()
                .then(handler);
        } else {

            MIPushModule.getInitialNotification()
                .then(handler);
        }
    }

}

MIPush = new MIPush();

module.exports = MIPush;
