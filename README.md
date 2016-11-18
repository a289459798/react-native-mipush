# react-native-mipush

该项目基于小米推送，使用前，请先在小米开发者后台注册app，并获取对应的appid与appkey。

开发环境：xcode8、react-native 0.35

##作者

QQ: 289459798
QQ群: 161263093

欢迎更多的喜欢开源的小伙伴加入

##安装

npm install react-native-xmpush --save

##android

打开`android`工程，`settings.gradle`，增加代码：

```
include ':react-native-xmpush'
project(':react-native-xmpush').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-xmpush/android')

```
修改`app`下面的的`build.gradle`，在`dependencies`区块下增加代码：

```
dependencies {
    ...
    compile project(':react-native-xmpush')
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

==必须通过xcode8开发的项目==

ios需要先制作推送证书，具体教程请自行百度。

本项目是基于`RCTPushNotification`，请将RCTPushNotification拖动到`Libraries`目录下。

添加所需依赖库：
- UserNotifications.framework
- libresolv.dylib(tbd)
- libxml2.dylib(tbd)
- libz.dylib(tbd)
- SystemConfiguration.framework
- MobileCoreServices.framework
- CFNetwork.framework
- CoreTelephony.framework

在`target`的`Capabilities`选项卡打开`Push Notifications`

在`target`的`Build Phases`选项卡添加`Link Binary With Libraries`:

> libRCTPushNotification.a
> libRCTMIPushModule.a

在targets->Build Settings下面搜索 Header Search Paths，添加

> $(SRCROOT)/../node_modules/react-native-xmpush/ios/RCTMIPushModule
>
> $(SRCROOT)/../node_modules/react-native/Libraries/PushNotificationIOS

设置为 `recursive`

打开工程下`Info.plist`文件为源代码形式打开，添加以下信息:

```
<key>MiSDKAppID</key>
<string>1000888</string>
<key>MiSDKAppKey</key>
<string>500088888888</string>
<key>MiSDKRun</key>
<string>Online</string>
```

修改 AppDelegate.m 文件：

```
...
#import "MIPushModule.h"
#import "RCTPushNotificationManager.h"
...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	...
  	[RCTMIPushModule application:application didFinishLaunchingWithOptions:launchOptions];
    ...
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

  [RCTMIPushModule application:application didRegisterUserNotificationSettings:notificationSettings];
  ...
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [RCTMIPushModule application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  ...
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
{
  [RCTMIPushModule application:application didReceiveRemoteNotification:notification];
  ...
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  [RCTMIPushModule application:application didReceiveLocalNotification:notification];
  ...
}

// ios 10
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  [RCTMIPushModule userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
  ...
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  [RCTMIPushModule userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
  ....
  completionHandler();
}

```


##RN中使用

Demo：

**android**

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

**ios**

```
...
componentWillUnmount() {

    MIPush.unsetAlias("bbbbbb");
    MIPush.removeEventListener("notification");
  }

  componentDidMount() {

    MIPush.setAlias("bbbbbb");

	MIPush.setBadgeNumber(0);   // 每次进入app将角标设置为0
    MIPush.addEventListener("notification", (notification) => {

      console.log("app接收到通知:", notification);
      
      // 弹出确认框
    });

    MIPush.getInitialNotification((notification) => {

      console.log("app关闭时获取点击通知消息:", notification);
	  // 弹出确认框
    });

  }
  ...
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