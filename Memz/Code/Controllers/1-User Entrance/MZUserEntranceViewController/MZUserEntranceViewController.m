//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "MZMainViewController.h"
#import "MZInjector.h"
#import "UINavigationController+MemzTransitions.h"

@interface MZUserEntranceViewController ()

@property (nonatomic, weak) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

#pragma mark - Helpers 

- (void)goToNavigationController {
	NSArray *viewControllers = @[[[MZMainViewController alloc] init]];

	UINavigationController *navigationController = [[MZInjector alloc] instanceForClass:[UINavigationController class]];
	navigationController.viewControllers = viewControllers;
	UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
	UINavigationController *mainNavigationController = (UINavigationController *)mainWindow.rootViewController;

	[mainNavigationController transitionToNewRootViewController:navigationController
																											options:MZAnimatedTransitionNewRootOptionNone
																						 transitionOption:UIViewAnimationOptionTransitionFlipFromLeft
																									 completion:nil];
}

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[self goToNavigationController];
}

@end
