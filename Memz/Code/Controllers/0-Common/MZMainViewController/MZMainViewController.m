//
//  MZMainViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMainViewController.h"
#import "MZFeedViewController.h"
#import "MZPollsViewController.h"
#import "MZMyDictionaryViewController.h"
#import "MZWordAdditionViewController.h"
#import "NSAttributedString+MemzAdditions.h"

NSString * const MZWordAdditionViewControllerSegue = @"MZWordAdditionViewControllerSegue";

const NSUInteger kNumberPages = 3;

@interface MZMainViewController ()

@property (nonatomic, weak) UIBarButtonItem * settingsButton;
@property (nonatomic, weak) UIBarButtonItem * profileButton;

@end

@implementation MZMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Add right button (add new word or expression)
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Add"]
																																	style:UIBarButtonItemStylePlain
																																 target:self
																																 action:@selector(goToAddWordView:)];
	[self.navigationItem setRightBarButtonItem:rightButton];

	self.profileButton = rightButton;

	// Add left button (change settings)
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Settings"]
																																 style:UIBarButtonItemStylePlain
																																target:self
																																action:@selector(gotoSettingsView:)];
	[self.navigationItem setLeftBarButtonItem:leftButton];

	self.settingsButton = leftButton;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.settingsButton.enabled = YES;
	self.profileButton.enabled = YES;
}

- (void)goToAddWordView:(id)sender {		// TODO: Use segue instead if possible
	[sender setEnabled:NO];
	MZWordAdditionViewController *wordAdditionViewController = [[UIStoryboard storyboardWithName:@"Navigation" bundle:nil] instantiateViewControllerWithIdentifier:@"MZWordAdditionViewControllerIdentifier"];

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wordAdditionViewController];
	[self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)gotoSettingsView:(id)sender {
	/*
	[sender setEnabled:NO];
	CHKSettingsViewController *settingsViewController = [[CHKSettingsViewController alloc] init];
	UINavigationController * navigationController = [[ETHFramework injector] instanceForClass:[UINavigationController class]];
	navigationController.viewControllers = @[settingsViewController];
	[self.navigationController presentViewController:navigationController animated:YES completion:nil];*/
}

- (MZPageViewControllerFactoryBlock)viewControllerFactoryForPage:(NSInteger)page {
	switch (page) {
		case MZMainViewControllerPageFeed:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZFeedViewControllerIdentifier"]; return viewController; };
		case MZMainViewControllerPagePolls:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZPollsViewControllerIdentifier"]; return viewController; };
		case MZMainViewControllerPageMyDictionary:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZMyDictionaryViewControllerIdentifier"]; return viewController; };	}
	return nil;
}

- (NSAttributedString *)attributedTitleForViewControllerForPage:(NSInteger)page {
	NSString * title = nil;
	switch (page) {
		case MZMainViewControllerPageFeed:
			title = [NSLocalizedString(@"FeedTitle", @"") uppercaseString];
			break;
		case MZMainViewControllerPagePolls:
			title = [NSLocalizedString(@"PollsTitle", @"") uppercaseString];
			break;
		case MZMainViewControllerPageMyDictionary:
			title = [NSLocalizedString(@"MyDictionaryTitle", @"") uppercaseString];
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
