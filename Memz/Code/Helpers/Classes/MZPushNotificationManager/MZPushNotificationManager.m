//
//  MZPushNotificationManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPushNotificationManager.h"
#import "UIViewController+MemzAdditions.h"
#import "MZQuizViewController.h"
#import "MZMainViewController.h"
#import "MZLanguageManager.h"
#import "MZQuiz.h"

NSString * const MZNotificationTypeKey = @"MZNotificationTypeKey";

@implementation MZPushNotificationManager

+ (MZPushNotificationManager *)sharedManager {
	static MZPushNotificationManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
			[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
																																					 settingsForTypes:(UIUserNotificationTypeSound
																																														 | UIUserNotificationTypeAlert
																																														 | UIUserNotificationTypeBadge)
																																					 categories:nil]];
			[[UIApplication sharedApplication] registerForRemoteNotifications];
		}
	}
	return self;
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
		case MZLocalPushNotificationTypeQuizz: {
			MZQuiz *quiz = [MZQuiz randomQuizFromLanguage:[MZLanguageManager sharedManager].fromLanguage
																				 toLanguage:[MZLanguageManager sharedManager].toLanguage];
			[MZQuizViewController askQuiz:quiz fromViewController:[UIViewController topMostViewController] completionBlock:nil];
			break;
		}
		default:
			break;
	}
}

+ (UINavigationController *)getMainNavigationController {
	UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
	UINavigationController *navigationController = (UINavigationController *)mainWindow.rootViewController;
	return navigationController;
}

+ (UIViewController *)topViewController {
	UINavigationController *navigationController = [self getMainNavigationController];
	UIViewController * topViewController = navigationController.topViewController;
	if ([topViewController isKindOfClass:[MZMainViewController class]]) {
		topViewController = [(MZMainViewController *)topViewController viewControllerForPage:[(MZMainViewController *)topViewController currentPage]];
	}
	return topViewController;
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
	[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)TEST {
	NSDictionary *userInfo = @{MZNotificationTypeKey: @(MZLocalPushNotificationTypeQuizz)};

	[self scheduleLocalNotificationWithTitle:nil
																			body:NSLocalizedString(@"LocalPushNotificationQuizBody", nil)
															 alertAction:NSLocalizedString(@"LocalPushNotificationQuizAlertAction", nil)
													startingfromDate:[NSDate date]
														repeatInterval:NSCalendarUnitDay
																	userInfo:userInfo];
}

@end
