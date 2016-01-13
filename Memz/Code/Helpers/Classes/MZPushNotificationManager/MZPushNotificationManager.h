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

extern NSString * const MZNotificationTypeKey;

@interface MZPushNotificationManager : NSObject

+ (MZPushNotificationManager *)sharedManager;

@property (nonatomic, assign, getter=isActivated) BOOL activated;		// Defaut is activated
@property (nonatomic, assign) NSUInteger startHour;		// Defaut 8 (8am)
@property (nonatomic, assign) NSUInteger endHour;		// Defaut 20 (8pm)

- (void)scheduleLocalNotifications:(MZLocalPushNotificationType)notificationType forDate:(NSDate *)date repeat:(BOOL)repeat;
- (void)cancelLocalNotifications:(MZLocalPushNotificationType)notificationType;
- (void)cancelAllLocalNotifications;

- (void)handleLocalNotification:(UILocalNotification *)notification;

@end
