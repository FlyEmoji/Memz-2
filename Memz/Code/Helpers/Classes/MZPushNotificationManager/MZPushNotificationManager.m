//
//  MZPushNotificationManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPushNotificationManager.h"

const NSUInteger kScheduleLocalNotificationsDaysAhead = 7;

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

- (void)scheduleLocalNotifications:(MZLocalPushNotificationType)notificationType forDate:(NSDate *)date {
	switch (notificationType) {
		case MZLocalPushNotificationTypeQuizz: {
			[self scheduleLocalNotificationWithMessage:NSLocalizedString(@"LocalPushNotificationQuizz", nil) forDate:date];
			break;
		}
	}
}

- (void)cancelLocalNotifications:(MZLocalPushNotificationType)notificationType {
	// TODO: Replace by cancelLocalNotification:
	// Local notifications will be stored locally and recovered before being deleted.
	[self cancelAllLocalNotifications];
}

- (void)cancelAllLocalNotifications {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Private Methods

- (void)scheduleLocalNotificationWithMessage:(NSString *)message forDate:(NSDate *)date {
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	localNotification.fireDate = date;
	localNotification.alertBody = message;
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	//[UIApplication sharedApplication].applicationIconBadgeNumber++;		// Handle Separately
}

@end
