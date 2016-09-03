//
//  MZNavigationController.m
//  Memz
//
//  Created by Bastien Falcou on 1/23/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNavigationController.h"

@interface MZNavigationController ()

@property (nonatomic, assign) BOOL shouldHideStatusBar;

@end

@implementation MZNavigationController

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
