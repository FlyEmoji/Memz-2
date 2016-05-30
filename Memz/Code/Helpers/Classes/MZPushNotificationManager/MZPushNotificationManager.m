//
//  MZPushNotificationManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPushNotificationManager.h"
#import "UIViewController+MemzAdditions.h"
#import "UIAlertController+MemzAdditions.h"
#import "MZQuizViewController.h"
#import "MZMainViewController.h"
#import "MZLanguageDefinition.h"
#import "MZDataManager.h"
#import "MZQuiz.h"

NSString * const MZNotificationTypeKey = @"MZNotificationTypeKey";
NSString * const MZQuizKey = @"MZQuizKey";

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

- (void)registerLocalNotifications {
	UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];

	[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

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
	if (notification == nil) {
		return;
	}

	MZLocalPushNotificationType notificationType = [notification.userInfo[MZNotificationTypeKey] integerValue];
	UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;

	switch (notificationType) {
		case MZLocalPushNotificationTypeQuizz: {
			MZQuiz *quiz = [MZQuiz randomQuizForUser:[MZUser currentUser] creationDate:nil];
			if (!quiz) {
				return;
			}

			[[MZDataManager sharedDataManager] saveChanges];

			dispatch_async(dispatch_get_main_queue(),^{
				if (applicationState == UIApplicationStateActive) {
					[self showAlertForNotificationType:notificationType
														inViewController:[UIViewController topMostViewController]
																		userInfo:@{MZQuizKey: quiz}];
				} else {
					[MZQuizViewController askQuiz:quiz
										 fromViewController:[UIViewController topMostViewController]
												completionBlock:nil];
				}
			});
			break;
		}
		default:
			break;
	}
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

#pragma mark - Alert Display

- (void)showAlertForNotificationType:(MZLocalPushNotificationType)type
										inViewController:(UIViewController *)viewController
														userInfo:(NSDictionary *)userInfo {
	switch (type) {
		case MZLocalPushNotificationTypeQuizz: {
			[UIAlertController showWithStyle:UIAlertControllerStyleAlert
																 title:NSLocalizedString(@"LocalPushNotificationAlertTitle", @"")
															 message:NSLocalizedString(@"LocalPushNotificationAlertDescription", @"")
																 block:^(UIAlertController *alertController, NSUInteger indexes) {
																	if (MZCancelButtonIndex(indexes) == MZTappedButtonIndex(indexes)) {
																		return;
																	}

																	[MZQuizViewController askQuiz:userInfo[MZQuizKey]
																						 fromViewController:[UIViewController topMostViewController]
																								completionBlock:nil];
																}
										cancelButtonTitle:NSLocalizedString(@"CommonCancel", @"")
										otherButtonTitles:NSLocalizedString(@"LocalPushNotificationAlertButtonTitle", @""), nil];
			break;
		}
		default:
			break;
	}
}

@end
