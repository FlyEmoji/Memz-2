//
//  AppDelegate.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "AppDelegate.h"
#import "UIAlertController+MemzAdditions.h"
#import "MZPushNotificationManager.h"
#import "MZMainViewController.h"
#import "MZPageControl.h"
#import "MZQuizManager.h"
#import "MZUser.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// (1) Setup common designs
	[self setupCommonDesigns];

	// (2) Recover and handle last push notification if exists
	UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	[[MZPushNotificationManager sharedManager] handleLocalNotification:localNotification];

	// (3) Generate pending unanswered quizzes since last application session
	NSMutableArray<NSDate *> *pendingQuizDates = [MZQuizManager sharedManager].datesMissedQuizzes.mutableCopy;
	if (localNotification) {
		[pendingQuizDates removeObjectAtIndex:pendingQuizDates.count - 1];
	}
	[[MZUser currentUser] addPendingQuizzesForCreationDates:pendingQuizDates];

	// (4) Setup analytics
	[[MZAnalyticsManager sharedManager] setupAnalytics];

	return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	// (1) Generate pending unanswered quizzes since last application session minus last one being answered now
	NSMutableArray<NSDate *> *pendingQuizDates = [MZQuizManager sharedManager].datesMissedQuizzes.mutableCopy;
	[pendingQuizDates removeObjectAtIndex:pendingQuizDates.count - 1];
	[[MZUser currentUser] addPendingQuizzesForCreationDates:pendingQuizDates];

	// (2) Handle push notification will present quiz
	[[MZPushNotificationManager sharedManager] handleLocalNotification:notification];
}

#pragma mark - Common Setups

- (void)setupCommonDesigns {
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor mainBlueColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
																												 NSForegroundColorAttributeName: [UIColor mainLightBlackColor]}];
}

@end
