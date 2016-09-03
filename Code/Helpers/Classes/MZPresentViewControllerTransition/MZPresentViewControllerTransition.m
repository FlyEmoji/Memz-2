//
//  MZPresentViewControllerTransition.m
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPresentViewControllerTransition.h"

typedef void (^MZAnimationCompletionBlock)(void);

NSString * const kPresentFrameAnimationKey = @"PresentFrameAnimationKey";
NSString * const kPresentTransformAnimationKey = @"PresentTransformAnimationKey";
NSString * const kPresentAlphaAnimationKey = @"PresentAlphaAnimationKey";
NSString * const kPresentAnimationCompletionBlockKey = @"PresentAnimationCompletionBlockKey";

NSTimeInterval const kPresentAnimationDuration = 0.3f;
CGFloat const kPresentTransformScaleValue = 0.96f;

@implementation MZPresentViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return kPresentAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	// (1) Get source & destination view controllers and views
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	UIView *sourceView = sourceViewController.view;
	UIView *destinationView = destinationViewController.view;

	// (2) Insert and prepare views to their final state before animation
	destinationView.frame = CGRectMake(0.0f, 0.0f, destinationView.frame.size.width, destinationView.frame.size.height);
	sourceView.transform = CGAffineTransformMakeScale(kPresentTransformScaleValue, kPresentTransformScaleValue);
	[sourceView.superview addSubview:destinationView];

	// (3) Prepare fade view over source view controller
	UIView *fadeView = [[UIView alloc] initWithFrame:destinationView.frame];
	fadeView.backgroundColor = [UIColor blackColor];
	[sourceView.superview insertSubview:fadeView belowSubview:destinationView];

	// (4) Prepare completion block
	MZAnimationCompletionBlock completionBlock = ^(void) {
		[fadeView removeFromSuperview];
		[transitionContext completeTransition:YES];
	};

	// (5) Destination view appearance using Core Animation
	CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	frameAnimation.fromValue = @(destinationView.layer.position.y + sourceView.frame.size.height);
	frameAnimation.toValue = @(destinationView.layer.position.y);
	frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	frameAnimation.duration = kPresentAnimationDuration;
	[destinationView.layer addAnimation:frameAnimation forKey:kPresentFrameAnimationKey];

	// (6) Animate source transform using Core Animation
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
	transformAnimation.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(kPresentTransformScaleValue,
																																															kPresentTransformScaleValue)];
	transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transformAnimation.duration = kPresentAnimationDuration;
	transformAnimation.delegate = self;
	[transformAnimation setValue:completionBlock forKey:kPresentAnimationCompletionBlockKey];
	[sourceView.layer addAnimation:transformAnimation forKey:kPresentTransformAnimationKey];

	// (7) Animate fade view over source view controller
	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.fromValue = @0.0f;
	alphaAnimation.toValue = @1.0f;
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	alphaAnimation.duration = kPresentAnimationDuration;
	[fadeView.layer addAnimation:alphaAnimation forKey:kPresentAlphaAnimationKey];
}

#pragma mark - Core Animation Delegate Methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	// (8) Complete transition when animations done
	MZAnimationCompletionBlock completionBlock = [anim valueForKey:kPresentAnimationCompletionBlockKey];
	if (completionBlock) {
		completionBlock();
	}
}

@end
