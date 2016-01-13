//
//  MZPushNotificationManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPushNotificationManager.h"

NSString * const MZNotificationTypeKey = @"MZNotificationTypeKey";

NSString * const kSettingsIsActivatedKey = @"MZSettingsIsActivatedKey";
NSString * const kSettingsStartHourKey = @"SettingsStartHourKey";
NSString * const kSettingsEndHourHey = @"SettingsEndHourHey";

const BOOL kDefaultIsActivated = YES;
const NSUInteger kDefaultStartTimeHour = 8;
const NSUInteger kDefaultEndTimeHour = 20;

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
	NSDictionary *userInfo = @{MZNotificationTypeKey: @(notificationType)};

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
				if ([notification.userInfo[MZNotificationTypeKey] integerValue] == notificationType) {
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

- (void)handleLocalNotification:(UILocalNotification *)notification {
	MZLocalPushNotificationType notificationType = [notification.userInfo[MZNotificationTypeKey] integerValue];
	switch (notificationType) {
		case MZLocalPushNotificationTypeQuizz:
			// TODO: To Implement
			break;
		default:
			break;
	}
}

#pragma mark - Settings Persistance

- (BOOL)isActivated {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsActivatedKey] == nil) {
		self.activated = kDefaultIsActivated;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsActivatedKey] integerValue];
}

- (void)setActivated:(BOOL)activated {
	[[NSUserDefaults standardUserDefaults] setObject:@(activated) forKey:kSettingsIsActivatedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)startHour {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsStartHourKey] == nil) {
		self.startHour = kDefaultStartTimeHour;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsStartHourKey] integerValue];
}

- (void)setStartHour:(NSUInteger)startHour {
	[[NSUserDefaults standardUserDefaults] setObject:@(startHour) forKey:kSettingsStartHourKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)endHour {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsEndHourHey] == nil) {
		self.endHour = kDefaultEndTimeHour;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsEndHourHey] integerValue];
}

- (void)setEndHour:(NSUInteger)endHour {
	[[NSUserDefaults standardUserDefaults] setObject:@(endHour) forKey:kSettingsEndHourHey];
	[[NSUserDefaults standardUserDefaults] synchronize];
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
