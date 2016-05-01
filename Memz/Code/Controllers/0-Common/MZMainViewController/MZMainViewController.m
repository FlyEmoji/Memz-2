//
//  MZMainViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMainViewController.h"
#import "NSAttributedString+MemzAdditions.h"
#import "MZQuizManager.h"
#import "MZUser.h"

NSString * const MZFeedViewControllerIdentifier = @"MZFeedViewControllerIdentifier";
NSString * const MZMyQuizzesViewControllerIdentifier = @"MZMyQuizzesViewControllerIdentifier";
NSString * const MZMyDictionaryViewControllerIdentifier = @"MZMyDictionaryViewControllerIdentifier";

NSString * const MZWordAdditionViewControllerSegue = @"MZWordAdditionViewControllerSegue";
NSString * const MZSettingsViewControllerSegue = @"MZSettingsViewControllerSegue";
NSString * const MZUserEntranceViewControllerSegue = @"MZUserEntranceViewControllerSegue";

const NSUInteger kNumberPages = 3;

@interface MZMainViewController ()

@property (nonatomic, weak) UIBarButtonItem *settingsButton;
@property (nonatomic, weak) UIBarButtonItem *profileButton;

@end

@implementation MZMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// (1) Add right button (add new word or expression)
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationAdd]
																																	style:UIBarButtonItemStylePlain
																																 target:self
																																 action:@selector(goToAddWordView:)];
	[self.navigationItem setRightBarButtonItem:rightButton];

	self.profileButton = rightButton;

	// (2) Add left button (change settings)
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationSettings]
																																 style:UIBarButtonItemStylePlain
																																target:self
																																action:@selector(gotoSettingsView:)];
	[self.navigationItem setLeftBarButtonItem:leftButton];

	self.settingsButton = leftButton;

	// (3) Initialize managers
	[[MZQuizManager sharedManager] scheduleQuizNotifications];

	// (4) Initialize main designs
	self.view.backgroundColor = [UIColor mainMediumGrayColor];

	// (5) Present user entrance flow if no user connected
	if (![MZUser currentUser]) {
		[self performSegueWithIdentifier:MZUserEntranceViewControllerSegue sender:self];
	}
}

- (void)goToAddWordView:(id)sender {
	[self performSegueWithIdentifier:MZWordAdditionViewControllerSegue sender:self];
}

- (void)gotoSettingsView:(id)sender {
	[self performSegueWithIdentifier:MZSettingsViewControllerSegue sender:self];
}

- (MZPageViewControllerFactoryBlock)viewControllerFactoryForPage:(NSInteger)page {
	switch (page) {
		case MZMainViewControllerPageFeed:
			return ^{ UIViewController *viewController = [self pageViewControllerWithStoryboard:MZFeedStoryboard identifier:MZFeedViewControllerIdentifier]; return viewController; };
		case MZMainViewControllerPageQuizzes:
			return ^{ UIViewController *viewController = [self pageViewControllerWithStoryboard:MZQuizStoryboard identifier:MZMyQuizzesViewControllerIdentifier]; return viewController; };
		case MZMainViewControllerPageMyDictionary:
			return ^{ UIViewController *viewController = [self pageViewControllerWithStoryboard:MZDictionaryStoryboard identifier:MZMyDictionaryViewControllerIdentifier]; return viewController; };	}
	return nil;
}

- (NSAttributedString *)attributedTitleForViewControllerForPage:(NSInteger)page {
	NSString * title = nil;
	switch (page) {
		case MZMainViewControllerPageFeed:
			title = NSLocalizedString(@"NavigationFeedTitle", @"");
			break;
		case MZMainViewControllerPageQuizzes:
			title = NSLocalizedString(@"NavigationQuizzesTitle", @"");
			break;
		case MZMainViewControllerPageMyDictionary:
			title = NSLocalizedString(@"NavigationMyDictionaryTitle", @"");
			break;
		default:
			break;
	}

	return [NSAttributedString attributedStringWithString:title
																									 font:[[UINavigationBar appearance] titleTextAttributes][NSFontAttributeName]
																									color:[[UINavigationBar appearance] titleTextAttributes][NSForegroundColorAttributeName]
																							kernValue:0.0f];
}

- (NSInteger)numberOfPage {
	return kNumberPages;
}

#pragma mark - Helpers

- (UIViewController *)pageViewControllerWithStoryboard:(NSString *)storyboard
																						identifier:(NSString *)identifier {
	return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

@end
