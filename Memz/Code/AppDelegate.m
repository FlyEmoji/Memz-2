//
//  AppDelegate.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "AppDelegate.h"
#import "MZPushNotificationManager.h"
#import "MZMainViewController.h"
#import "MZPageControl.h"
#import "MZInjector.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// (1) Setup appearance designs throughout
	[self setupCommonDesigns];

	// (2) Register for local push notifications
	[[MZPushNotificationManager sharedManager] registerLocalNotifications];

	// (3) Recover and handle last push notification if exists
	UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	[[MZPushNotificationManager sharedManager] handleLocalNotification:localNotif];

	/*
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(applicationWillEnterBackground:)
																							 name:UIApplicationWillResignActiveNotification
																						 object:nil];
	 */

	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(applicationWillTerminate:)
																							 name:UIApplicationWillTerminateNotification
																						 object:nil];
	return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
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
