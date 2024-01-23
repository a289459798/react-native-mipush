export default class MIPush {

    // 构

    init(appid: string, appkey: string);

    /**
     * 设置别名
     * @param text
     */
    setAlias(text: string);

    /**
     * 注销别名
     * @param text
     */
    unsetAlias(text: string);

    /**
     * 设置主题,类似tag
     * @param text
     */
    subscribe(text: string);

    /**
     * 注销主题
     * @param text
     */
    unsubscribe(text: string);

    /**
     * 设置账号,一个账号需要多台设备接收通知
     * @param text
     */
    setAccount(text: string);

    /**
     * 注销账号
     * @param text
     */
    unsetAccount(text: string);

    enablePush();

    disablePush();

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
    addEventListener(type: string, handler: Function);

    removeEventListener(type: string);

    /**
     * 发送一个本地通知
     * @param notification
     */
    presentLocalNotification(notification: any);

    /**
     * 清除指定通知
     * @param notifyId
     * ios : userInfo
     * android : id
     */
    clearNotification(notifyId: string);

    /**
     * 清除所有通知
     */
    clearNotifications();

    /**
     * 设置角标,仅支持ios
     * @param num
     */
    setBadgeNumber(num: number);

    /**
     * 通过点击通知启动app
     * @param handler
     */
    getInitialNotification(handler: Function);

}
