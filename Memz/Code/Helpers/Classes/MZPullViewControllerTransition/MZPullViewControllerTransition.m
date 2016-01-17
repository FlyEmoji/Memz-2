//
//  MZPullViewControllerTransition.m
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPullViewControllerTransition.h"
#import "UIImage+MemzAdditions.h"

typedef void (^MZAnimationCompletionBlock)(void);

NSString * const kPullFrameAnimationKey = @"PullFrameAnimationKey";
NSString * const kPullTransformAnimationKey = @"PullTransformAnimationKey";
NSString * const kPullAnimationCompletionBlockKey = @"PullAnimationCompletionBlockKey";

NSTimeInterval const kPullAnimationDuration = 0.5f;
CGFloat const kPullTransformScaleValue = 0.96f;

@implementation MZPullViewControllerTransition

- (instancetype)initWithTransitionDirection:(MZPullViewControllerTransitionDirection)transitionDirection {
	if (self = [self init]) {
		_transitionDirection = transitionDirection;
	}
	return self;
}

#pragma mark - Transition Delegate Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return kPullAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	// (1) Get source & destination view controllers and views
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *sourceView = sourceViewController.view;
	UIView *destinationView = destinationViewController.view;

	// (2) Freeze source view setting snapshot on top before animation
	UIImageView *snapshotSourceImageView = [[UIImageView alloc] initWithImage:[UIImage snapshotFromView:sourceView]];
	[sourceView addSubview:snapshotSourceImageView];

	// (3) Insert and prepare views to their final state before animation
	sourceView.frame = CGRectMake(0.0f, destinationView.frame.size.height, sourceView.frame.size.width, sourceView.frame.size.height);
	destinationView.transform = CGAffineTransformIdentity;
	[[sourceView superview] insertSubview:destinationView belowSubview:sourceView];

	// (4) Prepare completion block
	MZAnimationCompletionBlock completionBlock = ^(void) {
		[transitionContext completeTransition:YES];
		if ([self.delegate respondsToSelector:@selector(pullViewControllerTransitionDidFinish:)]) {
			[self.delegate pullViewControllerTransitionDidFinish:self];
		}
	};

	// (5) Destination view appearance using Core Animation
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(kPullTransformScaleValue,
																																																kPullTransformScaleValue)];
	transformAnimation.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
	transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transformAnimation.duration = kPullAnimationDuration;
	transformAnimation.delegate = self;
	[transformAnimation setValue:completionBlock forKey:kPullAnimationCompletionBlockKey];
	[destinationView.layer addAnimation:transformAnimation forKey:kPullTransformAnimationKey];

	// (6) Animate source disappearance using Core Animation
	NSNumber *toValue = self.transitionDirection == MZPullViewControllerTransitionDown ? @(destinationView.layer.position.y
		+ sourceView.frame.size.height) : @(destinationView.layer.position.y - sourceView.frame.size.height);

	CABasicAnimation *frameAnimation = [CABasicAnimation animation];
	frameAnimation.keyPath = @"position.y";
	frameAnimation.fromValue = @(destinationView.layer.position.y);
	frameAnimation.toValue = toValue;
	frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	frameAnimation.duration = kPullAnimationDuration;
	[sourceView.layer addAnimation:frameAnimation forKey:kPullFrameAnimationKey];
}

#pragma mark - Core Animation Delegate Methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	// (7) Complete transition when animations done
	MZAnimationCompletionBlock completionBlock = [anim valueForKey:kPullAnimationCompletionBlockKey];
	if (completionBlock) {
		completionBlock();
	}
}

@end
