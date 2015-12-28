//
//  MZPushNotificationManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MZLocalPushNotificationType) {
	MZLocalPushNotificationTypeNone = 0,
	MZLocalPushNotificationTypeQuizz
};

@interface MZPushNotificationManager : NSObject

+ (MZPushNotificationManager *)sharedManager;

- (void)scheduleLocalNotifications:(MZLocalPushNotificationType)notificationType forDate:(NSDate *)date repeat:(BOOL)repeat;
- (void)cancelLocalNotifications:(MZLocalPushNotificationType)notificationType;
- (void)cancelAllLocalNotifications;

@end
