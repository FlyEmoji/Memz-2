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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
	[[MZPushNotificationManager sharedManager] handleLocalNotification:notification];
}

#pragma mark - Deep Linking

+ (void)pushQuizViewController {
	// TODO: Need to create the Quiz first
	/*
	CHKProfileViewController * viewController = (CHKProfileViewController *)[self topViewController];
	if(!([viewController isKindOfClass:[CHKProfileViewController class]] && viewController.user != [CHKDataManager sharedDataManager].currentUser && [viewController.user.remoteID isEqualToString:encounter.remoteID])) {
		[CHKActivityIndicatorHelper hideAllHUDsForView:[[self class] getMainNavigationController].view animated:YES];
		UINavigationController *navigationController = [self getMainNavigationController];
		[navigationController dismissViewControllerAnimated:YES completion:nil];

		viewController = [[CHKProfileViewController alloc] init];
		viewController.user = encounter;

		dispatch_async(dispatch_get_main_queue(), ^{
			[navigationController pushViewController:viewController animated:YES];
		});
	}*/
}

@end
