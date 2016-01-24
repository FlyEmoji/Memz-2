//
//  MZPresenterViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/23/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPresenterViewController.h"
#import "MZPresentViewControllerTransition.h"
#import "MZPullViewControllerTransition.h"
#import "MZNavigationController.h"
#import "MZBaseViewController.h"

@interface MZPresenterViewController () <UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate,
MZBaseViewControllerTransitioning>

@property (nonatomic, strong) MZPullViewControllerTransition *iterativeDismissalTransition;

@end

@implementation MZPresenterViewController

#pragma mark - Base View Controller Delegate Methods

- (void)baseViewControllerDidStartPresenting:(MZBaseViewController *)viewController {
	MZNavigationController *navigationController = [viewController.navigationController safeCastToClass:[MZNavigationController class]];
	[navigationController showStatusBar:NO];
	[viewController showStatusBar:YES];
}

- (void)baseViewControllerDidStartDismissalAnimatedTransition:(MZBaseViewController *)viewController {
	[viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)baseViewController:(MZBaseViewController *)viewController didUpdateDismissalAnimatedTransition:(CGFloat)percent {
	[self.iterativeDismissalTransition updateInteractiveTransition:percent];
}

- (void)baseViewController:(MZBaseViewController *)viewController didFinishDismissalAnimatedTransitionWithDirection:(MZPullViewControllerTransitionDirection)direction {
	MZNavigationController *navigationController = [viewController.navigationController safeCastToClass:[MZNavigationController class]];
	[navigationController showStatusBar:YES];
	[viewController showStatusBar:YES];

	self.iterativeDismissalTransition.transitionDirection = direction;
	[self.iterativeDismissalTransition finishInteractiveTransition];
}

- (void)baseViewControllerDidCancelDismissalAnimatedTransition:(MZBaseViewController *)viewController {
	[self.iterativeDismissalTransition cancelInteractiveTransition];
}

#pragma mark - Custom Presentation/Dismissal Transition Animations

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																																	presentingController:(UIViewController *)presenting
																																			sourceController:(UIViewController *)source {
	return [[MZPresentViewControllerTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return self.iterativeDismissalTransition = [[MZPullViewControllerTransition alloc] init];
}

#pragma mark - Custom Dismissal Interactive Transition Animation Delegate Method

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
	return self.iterativeDismissalTransition;
}

@end
