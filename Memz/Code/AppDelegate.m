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
	[self setupCommonDesigns];
	[self setupInjections];
	
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

- (void)setupInjections {
	MZInjector *injector = [[MZInjector alloc] init];
	[injector bindClass:[MZPageControl class] toClass:[UIPageControl class]];
}

@end
