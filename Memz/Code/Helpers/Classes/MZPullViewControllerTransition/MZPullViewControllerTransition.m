//
//  MZPullViewControllerTransition.m
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPullViewControllerTransition.h"

NSTimeInterval const kAnimationDuration = 1.0f;

@implementation MZPullViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return kAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *sourceView = sourceViewController.view;
	UIView *destinationView = destinationViewController.view;

	destinationView.alpha = 0.0f;
	[[sourceView superview] addSubview:destinationView];

	[UIView animateWithDuration:kAnimationDuration animations:^{
		destinationView.alpha = 1.0f;
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:finished];
	}];
}

@end
