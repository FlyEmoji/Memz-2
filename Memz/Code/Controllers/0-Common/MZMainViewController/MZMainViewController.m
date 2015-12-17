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
	[navigationController setNavigationBarHidden:YES animated:NO];

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
		case CHKMainViewControllerPageFeed:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZFeedViewControllerIdentifier"]; return viewController; };
		case CHKMainViewControllerPagePolls:
			return ^{ UIViewController *viewController = [self pageViewControllerWithIdentifier:@"MZPollsViewControllerIdentifier"]; return viewController; };
		case CHKMainViewControllerPageToBeDecided:
			return ^{ return [[UIViewController alloc] init]; };
	}
	return nil;
}

- (NSAttributedString *)attributedTitleForViewControllerForPage:(NSInteger)page {
	NSString * title = nil;
	switch(page) {
		case CHKMainViewControllerPageFeed:
			title = [NSLocalizedString(@"HeatMapTitle", @"") uppercaseString];
			break;
		case CHKMainViewControllerPagePolls:
			title = [NSLocalizedString(@"MissedTitle", @"") uppercaseString];
			break;
		case CHKMainViewControllerPageToBeDecided:
			title = [NSLocalizedString(@"ConnectionsTitle", @"") uppercaseString];
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
