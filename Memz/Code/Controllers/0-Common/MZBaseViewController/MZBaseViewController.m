//
//  MZBaseViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZBaseViewController ()

@property (nonatomic, assign) BOOL shouldHideStatusBar;

@end

@implementation MZBaseViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self.transitionDelegate respondsToSelector:@selector(baseViewControllerDidStartPresenting:)]) {
		[self.transitionDelegate baseViewControllerDidStartPresenting:self];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	if ([self.transitionDelegate respondsToSelector:@selector(baseViewControllerDidFinishPresenting:)]) {
		[self.transitionDelegate baseViewControllerDidFinishPresenting:self];
	}
}

#pragma mark - Statius Bar Handling

- (void)showStatusBar:(BOOL)show {
	self.shouldHideStatusBar = !show;
	[self setNeedsStatusBarAppearanceUpdate];

	// TODO: Remove that deprecated code
	[[UIApplication sharedApplication] setStatusBarHidden:!show withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
	return self.shouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationFade;
}

@end
