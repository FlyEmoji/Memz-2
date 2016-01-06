//
//  UIViewController+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "UIViewController+MemzAdditions.h"
#import "UINavigationController+MemzTransitions.h"
#import "MZMainViewController.h"

@implementation UIViewController (MemzAdditions)

+ (UIViewController *)topMostViewController {
	UIViewController *topController = nil;
	NSArray *windows = [UIApplication sharedApplication].windows;

	for (NSUInteger i = windows.count; i > 0;) {
		--i;
		if ((topController = [windows[i] rootViewController]) != nil) {
			break;
		}
	}

	while (topController.presentedViewController != nil) {
		if ([topController.presentedViewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *topNavigationViewController = (UINavigationController *)topController.presentedViewController;
			if (topNavigationViewController.visibleViewController != nil) {
				topController = topNavigationViewController.visibleViewController;
			} else {
				topController = topController.presentedViewController;
			}
		} else if ([topController.presentedViewController isKindOfClass:[UITabBarController class]]) {
			UITabBarController *topTabBarViewController = (UITabBarController *)topController.presentedViewController;
			if (topTabBarViewController.selectedViewController != nil) {
				topController = topTabBarViewController.selectedViewController;
			} else {
				topController = topController.presentedViewController;
			}
		} else if ([topController.presentedViewController isKindOfClass:[MZMainViewController class]]) {
			topController = [(MZMainViewController *)topController viewControllerForPage:[(MZMainViewController *)topController currentPage]];
		} else {
			topController = topController.presentedViewController;
		}
	}

	return topController;
}

@end
