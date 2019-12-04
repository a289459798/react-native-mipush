//
//  MiPushNotificationServiceSDK.h
//  MiPushNotificationServiceSDK
//
//  Created by zzl on 2019/10/14.
//  Copyright © 2019 Xiaomi. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

@interface MiPushApnsAckSDK : NSObject

+ (void)reportApnsAck:(NSDictionary *)userInfo;

@end
