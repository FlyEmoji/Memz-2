//
//  MZLoaderView.m
//  Memz
//
//  Created by Bastien Falcou on 4/27/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLoaderView.h"

NSString * const kInfiniteSpinAnimationKey = @"InfiniteAnimationKey";

const NSTimeInterval kInfiniteSpinAnimationDuration = 1.5;

@interface MZLoaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *loaderImageView;

@end

@implementation MZLoaderView

#pragma mark - Public

+ (instancetype)showInView:(UIView *)view {
	CGRect loaderFrame = CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height);
	MZLoaderView *loaderView = [[MZLoaderView alloc] initWithFrame:loaderFrame];

	[view addSubview:loaderView];
	[loaderView animate];

	return loaderView;
}

+ (BOOL)hideFromView:(UIView *)view {
	for (UIView *subview in view.subviews) {
		if ([subview isKindOfClass:[self class]]) {
			[subview removeFromSuperview];
			return YES;
		}
	}
	return NO;
}

+ (BOOL)hideAllLoadersFromView:(UIView *)view {
	BOOL loaderFound = FALSE;

	for (UIView *subview in view.subviews) {
		if ([subview isKindOfClass:[self class]]) {
			[subview removeFromSuperview];
			loaderFound = YES;
		}
		loaderFound = loaderFound || [[self class] hideAllLoadersFromView:subview];
	}
	return loaderFound;
}

- (void)hide {
	[self removeFromSuperview];
}

#pragma mark - Private

- (void)animate {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0f];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.duration = kInfiniteSpinAnimationDuration;
	animation.cumulative = YES;
	animation.repeatCount = INFINITY;
	[self.loaderImageView.layer addAnimation:animation forKey:kInfiniteSpinAnimationKey];
}

@end
