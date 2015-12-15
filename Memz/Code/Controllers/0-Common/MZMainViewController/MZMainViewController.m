//
//  MZMainViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMainViewController.h"
#import "NSAttributedString+MemzAdditions.h"

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

- (void)goToAddWordView:(id)sender {
	/*
	[sender setEnabled:NO];
	CHKProfileViewController *profileViewController = [[CHKProfileViewController alloc] init];
	profileViewController.user = [CHKDataManager sharedDataManager].currentUser;
	[self.navigationController pushViewController:profileViewController animated:YES];*/
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
			return ^{ return [[UIViewController alloc] init]; };
		case CHKMainViewControllerPagePolls:
			return ^{ return [[UIViewController alloc] init]; };
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

@end
