//
//  MZPullViewControllerTransition.m
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPullViewControllerTransition.h"
#import "UIImage+MemzAdditions.h"

NSTimeInterval const kAnimationDuration = 0.8f;
CGFloat const kTransformScaleValue = 0.95f;

@implementation MZPullViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return kAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *sourceView = sourceViewController.view;
	UIView *destinationView = destinationViewController.view;

	UIImageView *snapshotSourceImageView = [[UIImageView alloc] initWithImage:[UIImage snapshotFromView:sourceView]];
	[sourceView addSubview:snapshotSourceImageView];

	[[sourceView superview] insertSubview:destinationView belowSubview:sourceView];

	[UIView animateWithDuration:kAnimationDuration animations:^{
		sourceView.frame = CGRectMake(0.0f, destinationView.frame.size.height, sourceView.frame.size.width, sourceView.frame.size.height);
		destinationView.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:finished];

		if ([self.delegate respondsToSelector:@selector(pullViewControllerTransitionDidFinish:)]) {
			[self.delegate pullViewControllerTransitionDidFinish:self];
		}
	}];
}

@end
