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

@interface MZUserEntranceViewController ()

@property (nonatomic, weak) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[MZLanguageManager sharedManager];
}

#pragma mark - Helpers 

- (void)goToNavigationController {
	NSArray *viewControllers = @[[[MZMainViewController alloc] init]];

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Navigation" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateInitialViewController];
	navigationController.viewControllers = viewControllers;

	UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
	UINavigationController *mainNavigationController = [mainWindow.rootViewController safeCastToClass:[UINavigationController class]];

	[mainNavigationController transitionToNewRootViewController:navigationController
																											options:MZAnimatedTransitionNewRootOptionNone
																						 transitionOption:UIViewAnimationOptionTransitionCrossDissolve
																									 completion:nil];
}

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[self goToNavigationController];
}

@end
