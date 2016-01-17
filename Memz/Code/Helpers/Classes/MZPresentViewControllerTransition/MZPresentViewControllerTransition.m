//
//  MZPresentViewControllerTransition.m
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPresentViewControllerTransition.h"

NSTimeInterval const kAnimationDuration = 0.8f;
CGFloat const kTransformScaleValue = 0.97f;

@implementation MZPresentViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return kAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *sourceView = sourceViewController.view;
	UIView *destinationView = destinationViewController.view;

	destinationView.frame = CGRectMake(0.0f, sourceView.frame.size.height, destinationView.frame.size.width, destinationView.frame.size.height);
	[[sourceView superview] addSubview:destinationView];

	[UIView animateWithDuration:kAnimationDuration animations:^{
		destinationView.frame = CGRectMake(0.0f, 0.0f, destinationView.frame.size.width, destinationView.frame.size.height);
		sourceView.transform = CGAffineTransformMakeScale(kTransformScaleValue, kTransformScaleValue);
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:finished];
	}];
}

@end
