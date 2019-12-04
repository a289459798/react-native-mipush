//
//  RCTMIPushModule.m
//  RCTMIPushModule
//
//  Created by zhangzy on 2016/10/24.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import "RCTMIPushModule.h"

@implementation RCTMIPushModule

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(setAlias:(NSString *)text)
{
    
    
    [MiPushSDK setAlias:text];
}

RCT_EXPORT_METHOD(unsetAlias:(NSString *)text)
{
    
    [MiPushSDK unsetAlias:text];
}

RCT_EXPORT_METHOD(subscribe:(NSString *)text)
{
    
    [MiPushSDK subscribe:text];
}

RCT_EXPORT_METHOD(unsubscribe:(NSString *)text)
{
    
    [MiPushSDK unsubscribe:text];
}

RCT_EXPORT_METHOD(setAccount:(NSString *)text)
{
    
    [MiPushSDK setAccount:text];
}

RCT_EXPORT_METHOD(unsetAccount:(NSString *)text)
{
    
    [MiPushSDK unsetAccount:text];
}

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    NSLog(@"data:%@", data);
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
    NSLog(@"error:%@", error);
}

- (void)miPushReceiveNotification:(NSDictionary *)data {
    NSLog(@"data2:%@", data);
}

+ (void)application:(id)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MiPushSDK registerMiPush:self];
    NSLog(@"注册");
}

+ (void)application:(id)application didRegisterUserNotificationSettings:(id)notificationSettings {
    
    [RNCPushNotificationIOS didRegisterUserNotificationSettings:notificationSettings];
}

+ (void)application:(id)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [MiPushSDK bindDeviceToken:deviceToken];
    [RNCPushNotificationIOS didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)application:(id)application didReceiveRemoteNotification:(NSDictionary *)notification {

    [RNCPushNotificationIOS didReceiveRemoteNotification:notification];
}

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    [RNCPushNotificationIOS didReceiveLocalNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmpush_click" object:notification.userInfo];
}

// 应用在前台收到通知
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [RNCPushNotificationIOS didReceiveRemoteNotification:userInfo];
    }
}

// 点击通知进入应用
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [RNCPushNotificationIOS didReceiveRemoteNotification:userInfo];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmpush_click" object:userInfo];
    completionHandler();
}

- (void) handleSend:(NSNotification *)notification {

    [self sendEventWithName:notification.name body:notification.object];
}

- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSend:)
                                                 name:@"xmpush_click"
                                               object:nil];

}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray<NSString *> *)supportedEvents {
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    [arr addObject:@"xmpush_click"];

    return arr;
}

@end
