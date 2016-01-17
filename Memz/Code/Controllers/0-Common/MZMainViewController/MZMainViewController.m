//
//  MZMainViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMainViewController.h"
#import "MZBaseViewController.h"
#import "MZFeedViewController.h"
#import "MZMyQuizzesViewController.h"
#import "MZMyDictionaryViewController.h"
#import "MZWordAdditionViewController.h"
#import "MZSettingsViewController.h"
#import "MZPresentViewControllerTransition.h"
#import "MZPullViewControllerTransition.h"
#import "NSAttributedString+MemzAdditions.h"
#import "MZQuizManager.h"

NSString * const MZWordAdditionViewControllerSegue = @"MZWordAdditionViewControllerSegue";
NSString * const MZSettingsViewControllerSegue = @"MZSettingsViewControllerSegue";

const NSUInteger kNumberPages = 3;

@interface MZMainViewController () <UIViewControllerTransitioningDelegate,
MZBaseViewControllerDelegate>

@property (nonatomic, weak) UIBarButtonItem *settingsButton;
@property (nonatomic, weak) UIBarButtonItem *profileButton;

@property (nonatomic, assign) MZPullViewControllerTransitionDirection currentDismissAnimationTransitionDirection;

@end

@implementation MZMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Add right button (add new word or expression)
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationAdd]
																																	style:UIBarButtonItemStylePlain
																																 target:self
																																 action:@selector(goToAddWordView:)];
	[self.navigationItem setRightBarButtonItem:rightButton];

	self.profileButton = rightButton;

	// Add left button (change settings)
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationSettings]
																																 style:UIBarButtonItemStylePlain
																																target:self
																																action:@selector(gotoSettingsView:)];
	[self.navigationItem setLeftBarButtonItem:leftButton];

	self.settingsButton = leftButton;

	// Initialize managers
	[[MZQuizManager sharedManager] scheduleQuizNotifications];
}

- (void)goToAddWordView:(id)sender {		// TODO: Use segue instead if possible
	MZWordAdditionViewController *wordAdditionViewController = [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:@"MZWordAdditionViewControllerIdentifier"];

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wordAdditionViewController];
	navigationController.transitioningDelegate = self;
	navigationController.modalPresentationStyle = UIModalPresentationCustom;
	[self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)gotoSettingsView:(id)sender {
	MZSettingsViewController *settingsViewController = [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:@"MZSettingsViewControllerIdentifier"];
	settingsViewController.delegate = self;

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	navigationController.transitioningDelegate = self;
	navigationController.modalPresentationStyle = UIModalPresentationCustom;
	[self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (MZPageViewControllerFactoryBlock)viewControllerFactoryForPage:(NSInteger)page {
	switch (page) {
		case MZMainViewControllerPageFeed:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZFeedViewControllerIdentifier"]; return viewController; };
		case MZMainViewControllerPageQuizzes:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZMyQuizzesViewControllerIdentifier"]; return viewController; };
		case MZMainViewControllerPageMyDictionary:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZMyDictionaryViewControllerIdentifier"]; return viewController; };	}
	return nil;
}

- (NSAttributedString *)attributedTitleForViewControllerForPage:(NSInteger)page {
	NSString * title = nil;
	switch (page) {
		case MZMainViewControllerPageFeed:
			title = [NSLocalizedString(@"NavigationFeedTitle", @"") uppercaseString];
			break;
		case MZMainViewControllerPageQuizzes:
			title = [NSLocalizedString(@"NavigationQuizzesTitle", @"") uppercaseString];
			break;
		case MZMainViewControllerPageMyDictionary:
			title = [NSLocalizedString(@"NavigationMyDictionaryTitle", @"") uppercaseString];
			break;
		default:
			break;
	}

	return [NSAttributedString attributedStringWithString:title
																									 font:[[UINavigationBar appearance] titleTextAttributes][NSFontAttributeName]
																									color:[[UINavigationBar appearance] titleTextAttributes][NSForegroundColorAttributeName]
																							kernValue:2.0f];
}

- (NSInteger)numberOfPage {
	return kNumberPages;
}

#pragma mark - Helpers

- (UIViewController *)pageViewControllerWithIdentifier:(NSString *)identifier {
	return [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark - Base View Controller Delegate Methods

- (void)baseViewController:(MZBaseViewController *)viewController didRequestDismissAnimatedTransitionWithDirection:(MZPullViewControllerTransitionDirection)direction {
	self.currentDismissAnimationTransitionDirection = direction;
	[viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Presentation Animation

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																																	presentingController:(UIViewController *)presenting
																																			sourceController:(UIViewController *)source {
	return [[MZPresentViewControllerTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[MZPullViewControllerTransition alloc] initWithTransitionDirection:self.currentDismissAnimationTransitionDirection];
}

@end
