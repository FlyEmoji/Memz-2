//
//  MZPushNotificationManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPushNotificationManager.h"

NSString * const kNotificationTypeKey = @"MVNotificationTypeKey";

@implementation MZPushNotificationManager

+ (MZPushNotificationManager *)sharedManager {
	static MZPushNotificationManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

#pragma mark - Public Methods 

- (void)scheduleLocalNotifications:(MZLocalPushNotificationType)notificationType forDate:(NSDate *)date repeat:(BOOL)repeat {
	NSDictionary *userInfo = @{kNotificationTypeKey: @(notificationType)};

	switch (notificationType) {
		case MZLocalPushNotificationTypeQuizz: {
			[self scheduleLocalNotificationWithTitle:nil
																					body:NSLocalizedString(@"LocalPushNotificationQuizBody", nil)
																	 alertAction:NSLocalizedString(@"LocalPushNotificationQuizAlertAction", nil)
															startingfromDate:date
																repeatInterval:repeat ? NSCalendarUnitDay : 0
																			userInfo:userInfo];
			break;
		}
		default:
			break;
	}
}

- (void)cancelLocalNotifications:(MZLocalPushNotificationType)notificationType {
	NSMutableArray<UILocalNotification *> *notificationsOfSpecifiedType = [[NSMutableArray alloc] init];

	[[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:
			^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
				if ([notification.userInfo[kNotificationTypeKey] integerValue] == notificationType) {
					[notificationsOfSpecifiedType addObject:notification];
				}
	}];

	[notificationsOfSpecifiedType enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
		[[UIApplication sharedApplication] cancelLocalNotification:notification];
	}];
}

- (void)cancelAllLocalNotifications {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Private Methods

- (void)scheduleLocalNotificationWithTitle:(NSString *)title
																			body:(NSString *)message
															 alertAction:(NSString *)alertAction
													startingfromDate:(NSDate *)date
														repeatInterval:(NSCalendarUnit)repeatInterval
																	userInfo:(NSDictionary *)userInfo {
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];

	localNotification.fireDate = date;
	localNotification.repeatInterval = repeatInterval;
	localNotification.repeatCalendar = [NSCalendar autoupdatingCurrentCalendar];

	localNotification.alertTitle = title;
	localNotification.alertAction = alertAction;
	localNotification.alertBody = message;

	localNotification.soundName = UILocalNotificationDefaultSoundName;
	localNotification.userInfo = userInfo;

	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
