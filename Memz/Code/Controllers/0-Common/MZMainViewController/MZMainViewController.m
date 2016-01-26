//
//  MZMainViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZNavigationController.h"
#import "MZMainViewController.h"
#import "MZFeedViewController.h"
#import "MZMyQuizzesViewController.h"
#import "MZMyDictionaryViewController.h"
#import "MZWordAdditionViewController.h"
#import "MZSettingsViewController.h"
#import "MZPresentableViewController.h"
#import "MZTransitioningDefaultBehavior.h"
#import "NSAttributedString+MemzAdditions.h"
#import "MZQuizManager.h"

NSString * const MZWordAdditionViewControllerSegue = @"MZWordAdditionViewControllerSegue";
NSString * const MZSettingsViewControllerSegue = @"MZSettingsViewControllerSegue";

const NSUInteger kNumberPages = 3;

@interface MZMainViewController () <UIViewControllerTransitioningDelegate,
MZPresentableViewControllerTransitioning>		// TODO: Should be able to remove that

@property (nonatomic, weak) UIBarButtonItem *settingsButton;
@property (nonatomic, weak) UIBarButtonItem *profileButton;

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
	MZTransitioningDefaultBehavior *transitioningBehavior = [[MZTransitioningDefaultBehavior alloc] init];

	MZWordAdditionViewController *wordAdditionViewController = [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:@"MZWordAdditionViewControllerIdentifier"];
	wordAdditionViewController.transitionDelegate = transitioningBehavior;

	MZNavigationController *navigationController = [[MZNavigationController alloc] initWithRootViewController:wordAdditionViewController];
	navigationController.transitioningDelegate = transitioningBehavior;
	navigationController.modalPresentationStyle = UIModalPresentationCustom;
	[self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)gotoSettingsView:(id)sender {
	MZTransitioningDefaultBehavior *transitioningBehavior = [[MZTransitioningDefaultBehavior alloc] init];

	MZSettingsViewController *settingsViewController = [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:@"MZSettingsViewControllerIdentifier"];
	settingsViewController.transitionDelegate = transitioningBehavior;

	MZNavigationController *navigationController = [[MZNavigationController alloc] initWithRootViewController:settingsViewController];
	navigationController.transitioningDelegate = transitioningBehavior;
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

@end
