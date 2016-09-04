//
//  MZPresentableViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPresentableViewController.h"
#import "MZTutorialView.h"

NSString * const kHasPresentableViewAlreadyOpenedKey = @"MZHasPresentableViewAlreadyOpenedKey";

const NSTimeInterval kDismissAnimationDuration = 0.15;

@interface MZPresentableViewController () <MZTutorialViewProtocol>

@property (nonatomic, strong) MZTutorialView *tutorialView;

@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, assign) BOOL hasPresentableViewAlreadyOpened;

@end

@implementation MZPresentableViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewControllerDidStartPresentAnimatedTransition:)]) {
		[self.transitionDelegate presentableViewControllerDidStartPresentAnimatedTransition:self];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (!self.hasPresentableViewAlreadyOpened) {
		[MZTutorialView showInView:self.view withType:MZTutorialViewTypePresentableView delegate:self];
		self.hasPresentableViewAlreadyOpened = YES;
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewControllerDidFinishPresentAnimatedTransition:)]) {
		[self.transitionDelegate presentableViewControllerDidFinishPresentAnimatedTransition:self];
	}
}

#pragma mark - Trigger Dismiss Behavior

- (void)dismissViewControllerWithCompletion:(void (^)())completionHandler {
	[self.transitionDelegate presentableViewControllerDidStartDismissalAnimatedTransition:self];

	[UIView animateWithDuration:kDismissAnimationDuration animations:^{
		[self.transitionDelegate presentableViewController:self didUpdateDismissalAnimatedTransition:1.0f];
	} completion:^(BOOL finished) {
		[self.transitionDelegate presentableViewController:self didFinishDismissalAnimatedTransitionWithDirection:MZPullViewControllerTransitionDown];
		if (completionHandler) {
			completionHandler();
		}
	}];
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

#pragma mark - Custom Getters & Setters 

- (BOOL)hasPresentableViewAlreadyOpened {
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kHasPresentableViewAlreadyOpenedKey] boolValue];
}

- (void)setHasPresentableViewAlreadyOpened:(BOOL)hasPresentableViewAlreadyOpened {
	[[NSUserDefaults standardUserDefaults] setObject:@(hasPresentableViewAlreadyOpened) forKey:kHasPresentableViewAlreadyOpenedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Tutorial View Delegate 

- (void)tutorialView:(MZTutorialView *)view didRequestDismissForType:(MZTutorialViewType)type {
	[view dismiss];
}

#pragma mark - Table View Transition Delegate Methods

- (void)tableViewDidStartScrollOutOfBounds:(MZTableView *)tableView {
	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewControllerDidStartDismissalAnimatedTransition:)]) {
		[self.transitionDelegate presentableViewControllerDidStartDismissalAnimatedTransition:self];
	}
}

- (void)tableView:(MZTableView *)tableView didScrollOutOfBoundsPercentage:(CGFloat)percentage goingUp:(BOOL)goingUp {
	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewController:didUpdateDismissalAnimatedTransition:)]
			&& percentage >= 0.0f && percentage < 1.0f) {
		[self.transitionDelegate presentableViewController:self didUpdateDismissalAnimatedTransition:percentage];
	}
}

- (void)tableView:(MZTableView *)tableView didEndScrollOutOfBoundsPercentage:(CGFloat)percentage goingUp:(BOOL)goingUp {
	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewController:didFinishDismissalAnimatedTransitionWithDirection:)]
			&& percentage >= 1.0f) {
		MZPullViewControllerTransitionDirection direction = goingUp ? MZPullViewControllerTransitionUp : MZPullViewControllerTransitionDown;
		[self.transitionDelegate presentableViewController:self didFinishDismissalAnimatedTransitionWithDirection:direction];
	}

	if ([self.transitionDelegate respondsToSelector:@selector(presentableViewControllerDidCancelDismissalAnimatedTransition:)]
			&& percentage < 1.0f) {
		[self.transitionDelegate presentableViewControllerDidCancelDismissalAnimatedTransition:self];
	}
}

@end
