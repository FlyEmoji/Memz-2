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
NSString * const kPullOpacityAnimationKey = @"PullOpacityAnimationKey";
NSString * const kPullAnimationCompletionBlockKey = @"PullAnimationCompletionBlockKey";

NSTimeInterval const kPullAnimationDuration = 0.5f;
NSTimeInterval const kCancelAnimationDuration = 0.3f;
CGFloat const kPullTransformScaleValue = 0.96f;
CGFloat const kPercentageShortenAnimation = 0.1f;

@interface MZPullViewControllerTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIView *destinationView;

@property (nonatomic, strong) UIView *fadeView;

@end

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
	[transitionContext.containerView addSubview:snapshotSourceImageView];

	// (3) Insert and prepare views to their final state before animation
	sourceView.frame = CGRectMake(0.0f, destinationView.frame.size.height, sourceView.frame.size.width, sourceView.frame.size.height);
	destinationView.transform = CGAffineTransformIdentity;
	[transitionContext.containerView insertSubview:destinationView belowSubview:sourceView];		// Refactor using transitionContext.containerView and finalFrameForViewController

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

	CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	frameAnimation.fromValue = @(destinationView.layer.position.y);
	frameAnimation.toValue = toValue;
	frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	frameAnimation.duration = kPullAnimationDuration;
	[sourceView.layer addAnimation:frameAnimation forKey:kPullFrameAnimationKey];
}

#pragma mark - Interactive Transition Delegate Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	// (1) Save transition context
	self.transitionContext = transitionContext;

	// (2) Get source & destination view controllers and views
	UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	self.sourceView = sourceViewController.view;
	self.destinationView = destinationViewController.view;

	// (3) Prepare fade view over destination view controller
	CGRect fadeViewFrame = CGRectMake(0.0f, 0.0f, self.sourceView.frame.size.width, self.sourceView.frame.size.height);
	self.fadeView = [[UIView alloc] initWithFrame:fadeViewFrame];
	self.fadeView.backgroundColor = [UIColor blackColor];
	[transitionContext.containerView insertSubview:self.fadeView aboveSubview:self.destinationView];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
	// (4) Update fade view progress
	self.fadeView.layer.opacity = 1.0f - percentComplete;
}

- (void)finishInteractiveTransition {
	// (5) Send transition confirmation
	if ([self.delegate respondsToSelector:@selector(pullViewControllerTransitionDidConfirm:)]) {
		[self.delegate pullViewControllerTransitionDidConfirm:self];
	}

	// (6) Insert and prepare views to their final state before animation
	self.sourceView.frame = CGRectMake(0.0f, self.destinationView.frame.size.height, self.sourceView.frame.size.width, self.sourceView.frame.size.height);
	self.destinationView.transform = CGAffineTransformIdentity;

	// (7) Freeze source view setting and using snapshot instead
	UIImageView *snapshotSourceImageView = [[UIImageView alloc] initWithImage:[UIImage snapshotFromView:self.sourceView]];
	snapshotSourceImageView.frame = self.sourceView.frame;
	[self.sourceView.superview insertSubview:snapshotSourceImageView belowSubview:self.sourceView];
	[self.sourceView removeFromSuperview];

	// (8) Prepare completion block
	MZAnimationCompletionBlock completionBlock = ^(void) {
		[self.fadeView removeFromSuperview];
		[snapshotSourceImageView removeFromSuperview];
		[self.transitionContext completeTransition:YES];
		if ([self.delegate respondsToSelector:@selector(pullViewControllerTransitionDidFinish:)]) {
			[self.delegate pullViewControllerTransitionDidFinish:self];
		}
	};

	// (9) Destination view appearance using Core Animation
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.fromValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(kPullTransformScaleValue,
																																																kPullTransformScaleValue)];
	transformAnimation.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
	transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transformAnimation.duration = kPullAnimationDuration;
	transformAnimation.delegate = self;
	[transformAnimation setValue:completionBlock forKey:kPullAnimationCompletionBlockKey];
	[self.destinationView.layer addAnimation:transformAnimation forKey:kPullTransformAnimationKey];

	// (10) Animate source disappearance using Core Animation
	NSNumber *toValue = self.transitionDirection == MZPullViewControllerTransitionDown ? @(self.destinationView.layer.position.y
		+ snapshotSourceImageView.frame.size.height) : @(self.destinationView.layer.position.y - snapshotSourceImageView.frame.size.height);

	CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	frameAnimation.fromValue = @(self.destinationView.layer.position.y);
	frameAnimation.toValue = toValue;
	frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	frameAnimation.duration = kPullAnimationDuration;
	[snapshotSourceImageView.layer addAnimation:frameAnimation forKey:kPullFrameAnimationKey];

	// (11) Animate fade view over source view controller
	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.fromValue = @(self.fadeView.layer.opacity);
	alphaAnimation.toValue = @0.0f;
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	alphaAnimation.duration = kPullAnimationDuration + kPullAnimationDuration * kPercentageShortenAnimation;
	[self.fadeView.layer addAnimation:alphaAnimation forKey:kPullOpacityAnimationKey];
}

- (void)cancelInteractiveTransition {
	// (5) Prepare views to their final positions
	self.sourceView.frame = CGRectMake(0.0f, 0.0f, self.sourceView.frame.size.width, self.sourceView.frame.size.height);

	// (6) Prepare completion block
	MZAnimationCompletionBlock completionBlock = ^(void) {
		[self.fadeView removeFromSuperview];
		[self.transitionContext completeTransition:YES];
		if ([self.delegate respondsToSelector:@selector(pullViewControllerTransitionDidFinish:)]) {
			[self.delegate pullViewControllerTransitionDidFinish:self];
		}
	};

	// (7) To write
	CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	frameAnimation.fromValue = @(self.sourceView.layer.position.y);
	frameAnimation.toValue = @(self.destinationView.layer.position.y);
	frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	frameAnimation.duration = kCancelAnimationDuration;
	[frameAnimation setValue:completionBlock forKey:kPullAnimationCompletionBlockKey];
	[self.sourceView.layer addAnimation:frameAnimation forKey:kPullFrameAnimationKey];

	// (8) Animate fade view over source view controller
	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.fromValue = @(self.fadeView.layer.opacity);
	alphaAnimation.toValue = @1.0f;
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	alphaAnimation.duration = kCancelAnimationDuration;
	[self.fadeView.layer addAnimation:alphaAnimation forKey:kPullOpacityAnimationKey];
}

#pragma mark - Core Animation Delegate Methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	// (12) Complete transition when animations done
	MZAnimationCompletionBlock completionBlock = [anim valueForKey:kPullAnimationCompletionBlockKey];
	if (completionBlock) {
		completionBlock();
	}
}

@end
