//
//  RCTMIPushModule.h
//  RCTMIPushModule
//
//  Created by zhangzy on 2016/10/24.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <React/RCTEventEmitter.h>
#import "RCTPushNotificationManager.h"
#import "MiPushSDK.h"

@interface RCTMIPushModule : RCTEventEmitter <RCTBridgeModule, MiPushSDKDelegate>

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification;

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;


+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;

+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler;

@end
