# react-native-mipush

[TOC]

##安装

==暂未上传到npm，待更新==

##android

打开`android`工程，`settings.gradle`，增加代码：

```
include ':react-native-mipush'
project(':react-native-mipush').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-mipush/android')

```
修改`app`下面的的`build.gradle`，在`dependencies`区块下增加代码：

```
dependencies {
    ...
    compile project(':react-native-mipush')
}
```
修改`MainApplication`文件，修改`getPackages`方法，添加`MIPushPackage`：

```
@Override
protected List<ReactPackage> getPackages() {

  return Arrays.<ReactPackage>asList(
      ...
      new MIPushPackage()
  );
}
```

最后在项目的`AndroidManifest.xml`文件中增加下面代码：

```
// 一下代码放在 applacation 标签下
<meta-data android:name="MIPUSH_APPID" android:value=":1111"/>
        <meta-data android:name="MIPUSH_APPKEY" android:value=":2222"/>

// 1111 替换成在小米申请的appid
// 2222 替换成在小米申请的appkey

// 千万注意要保留数字前面的冒号
```


以上，android的集成完成。

##ios

==正在开发，待更新==

##RN中使用

Demo：

```
...

import MIPush from 'react-native-mipush';

...
componentWillUnmount() {

    MIPush.unsetAlias("oooooo");
    MIPush.removeEventListener("xmpush_click");
    MIPush.removeEventListener("xmpush_notify");
}

componentDidMount() {

    MIPush.setAlias("oooooo");

    MIPush.addEventListener("xmpush_click", (notification) => {

      console.log("app运行过程中点击通知:", notification);
    });

    MIPush.addEventListener("xmpush_notify", (notification) => {

      console.log("app接收到通知:", notification);
    });

    MIPush.getInitialNotification((notification) => {

      console.log("app关闭时获取点击通知消息:", notification);

    });

  }
```

暂支持的所有方法：

```
/**
 * 设置别名
 * @param text
 */
setAlias(text);

/**
 * 注销别名
 * @param text
 */
unsetAlias(text);

/**
 * 设置主题,类似tag
 * @param text
 */
subscribe(text);

/**
 * 注销主题
 * @param text
 */
unsubscribe(text);

/**
 * 设置账号,一个账号需要多台设备接收通知
 * @param text
 */
setAccount(text);

/**
 * 注销账号
 * @param text
 */
unsetAccount(text);

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
addEventListener(type, handler);

removeEventListener(type);

/**
 * 发送一个本地通知
 * @param notification
 */
presentLocalNotification(notification);

/**
 * 清除指定通知
 * @param notifyId
 * ios : userInfo
 * android : id
 */
clearNotification(notifyId);

/**
 * 清除所有通知
 */
clearNotifications();

/**
 * 设置角标,仅支持ios
 * @param num
 */
setBadgeNumber(num);

/**
 * 通过点击通知启动app
 * @param handler
 */
getInitialNotification(handler);

```