//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "UILabel+MemzAdditions.h"
#import "MZLanguageDefinition.h"
#import "MZPageControl.h"
#import "MZDataManager.h"
#import "MZUser.h"
#import "MZSwitch.h"

@interface MZUserEntranceViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *enterNavigationButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet MZPageControl *pageControl;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *descriptionLabels;

@end

@implementation MZUserEntranceViewController

#pragma mark - Actions

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[self.descriptionLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
		[label applyParagraphStyle];
	}];

	[[MZAnalyticsManager sharedManager] trackScreen:MZAnalyticsScreenUserEntrance];
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[MZUser signUpUserKnownLanguage:MZLanguageEnglish newLanguage:MZLanguageFrench];

	[[MZDataManager sharedDataManager] saveChanges];
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
	self.pageControl.currentPage = page;
}

@end
