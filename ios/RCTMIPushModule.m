//
//  RCTMIPushModule.m
//  RCTMIPushModule
//
//  Created by zhangzy on 2016/10/24.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import "RCTMIPushModule.h"
#import <UMPush/UMessage.h>

@implementation RCTMIPushModule

static NSDictionary *_launchOptions;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initPush)
{
    NSDictionary *userInfo = _launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo != nil) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"xmpush_click" object:userInfo];
    }

    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:_launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {

    }];
    NSLog(@"注册");
}

RCT_EXPORT_METHOD(setAlias:(NSString *)text)
{
    [UMessage setAlias:text type:@"default" response:^(id  _Nullable responseObject, NSError * _Nullable error) {

    }];
}

RCT_EXPORT_METHOD(unsetAlias:(NSString *)text)
{
    [UMessage removeAlias:text type:@"default" response:^(id  _Nullable responseObject, NSError * _Nullable error) {

    }];
}

RCT_EXPORT_METHOD(subscribe:(NSString *)text)
{
    [UMessage addTags:text response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {

    }];
}

RCT_EXPORT_METHOD(unsubscribe:(NSString *)text)
{
    [UMessage deleteTags:text response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {

    }];
}

RCT_EXPORT_METHOD(setAccount:(NSString *)text)
{

}

RCT_EXPORT_METHOD(unsetAccount:(NSString *)text)
{

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
    _launchOptions = launchOptions;
}

+ (void)application:(id)application didRegisterUserNotificationSettings:(id)notificationSettings {

    [RNCPushNotificationIOS didRegisterUserNotificationSettings:notificationSettings];
}

+ (void)application:(id)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    if(![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes =(const unsigned*)[deviceToken bytes];
    NSString *hexToken =[NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    [RNCPushNotificationIOS didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)application:(id)application didReceiveRemoteNotification:(NSDictionary *)notification {

    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue]<10){
        [UMessage didReceiveRemoteNotification:notification];
    }

    [RNCPushNotificationIOS didReceiveRemoteNotification:notification];
}

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    [RNCPushNotificationIOS didReceiveLocalNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmpush_click" object:notification.userInfo];
}

// 应用在前台收到通知
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

    [UMessage setAutoAlert:NO];
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [RNCPushNotificationIOS didReceiveRemoteNotification:userInfo];
    } else {
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
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
