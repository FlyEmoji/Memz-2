//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "MZMainViewController.h"
#import "MZLanguageManager.h"
#import "UINavigationController+MemzTransitions.h"

NSString * const MZMainViewControllerIdentifier = @"MZMainViewControllerIdentifier";
NSString * const MZMainViewControllerSegue = @"MZMainViewControllerSegue";

@interface MZUserEntranceViewController ()

@property (nonatomic, strong) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[MZLanguageManager sharedManager];
}

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[self goToNavigationController];
}

#pragma mark - Helpers

- (void)goToNavigationController {
	UIStoryboard *navigationStoryboard = [UIStoryboard storyboardWithName:MZNavigationStoryboard bundle:nil];
	MZMainViewController *mainViewController = [navigationStoryboard instantiateViewControllerWithIdentifier:MZMainViewControllerIdentifier];

	NSArray *viewControllers = @[mainViewController];

	UINavigationController *navigationController = [navigationStoryboard instantiateInitialViewController];
	navigationController.viewControllers = viewControllers;

	UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
	UINavigationController *mainNavigationController = [mainWindow.rootViewController safeCastToClass:[UINavigationController class]];

	[mainNavigationController transitionToNewRootViewController:navigationController
																											options:MZAnimatedTransitionNewRootOptionNone
																						 transitionOption:UIViewAnimationOptionTransitionCrossDissolve
																									 completion:nil];
}

@end
