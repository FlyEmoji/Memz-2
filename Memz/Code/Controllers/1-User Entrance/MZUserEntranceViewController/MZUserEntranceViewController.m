//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "MZLanguageDefinition.h"
#import "MZPageControl.h"
#import "MZDataManager.h"
#import "MZUser.h"
#import "MZSwitch.h"

@interface MZUserEntranceViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *enterNavigationButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet MZPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MZSwitch *theSwitch;

@end

@implementation MZUserEntranceViewController

#pragma mark - Actions

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.theSwitch.on = NO;

	self.theSwitch.onTintColor = [UIColor redColor];
	self.theSwitch.on = YES;

	if (self.theSwitch.backgroundColor == [UIColor redColor]) {
		NSLog(@"YAY");
	}
}

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[MZUser signUpUserKnownLanguage:MZLanguageEnglish newLanguage:MZLanguageFrench];

	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
	self.pageControl.currentPage = page;
}

@end
