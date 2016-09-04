//
//  UIView+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIView+MemzAdditions.h"

static char * GLOWVIEW_KEY = "GLOWVIEW";

const NSTimeInterval kDelayStopGlowOnce = 2.0;
const CGFloat kGlowDefaultIntensity = 0.6f;

const CGFloat kCircularRadius = 0.5f;

@interface UIView (MemzAdditionsAttributes)

@property (nonatomic, weak, readonly) UIView *glowView;
@property (nonatomic, assign, readonly) BOOL isLightening;

@end

@implementation UIView (MemzAdditions)

#pragma mark - Corner Radius

- (void)applyCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = (CGFloat)fmin(self.frame.size.width, self.frame.size.height) * cornerRadius;
	self.layer.masksToBounds = YES;
}

- (void)makeCircular {
	[self applyCornerRadius:kCircularRadius];
}

#pragma mark - Shadows

- (void)applyShadows {
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
	self.layer.shadowRadius = 3.0f;
	self.layer.shadowOpacity = 1.0f;
}

#pragma mark - Glow

- (UIView *)glowView {
	return objc_getAssociatedObject(self, GLOWVIEW_KEY);
}

- (void)setGlowView:(UIView *)glowView {
	objc_setAssociatedObject(self, GLOWVIEW_KEY, glowView, OBJC_ASSOCIATION_RETAIN);
}

- (void)startGlowingWithColor:(UIColor *)color intensity:(CGFloat)intensity {
	[self startGlowingWithColor:color fromIntensity:0.1f toIntensity:intensity repeat:YES];
}

- (void)startGlowingWithColor:(UIColor*)color fromIntensity:(CGFloat)fromIntensity toIntensity:(CGFloat)toIntensity repeat:(BOOL)repeat {
	// (1) Exit if already glowing
	if (self.glowView) {
		return;
	}

	// (2) Glow image is taken from the current view's appearance. Will not update if original view changes.
	UIImage *image;

	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];

	UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
	[color setFill];
	[path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1.0f];

	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	// (3) Make glowing view itself, and position it at same point.
	UIView* glowView = [[UIImageView alloc] initWithImage:image];
	glowView.center = self.center;
	[self.superview insertSubview:glowView aboveSubview:self];

	// (4) Show white shadow created by Core Animation from image only, not the image itself.
	glowView.alpha = 0.0f;
	glowView.layer.shadowColor = color.CGColor;
	glowView.layer.shadowOffset = CGSizeZero;
	glowView.layer.shadowRadius = 10.0f;
	glowView.layer.shadowOpacity = 1.0f;

	// (5) Create animation that slowly fades the glow view in and out forever.
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = @(fromIntensity);
	animation.toValue = @(toIntensity);
	animation.repeatCount = repeat ? HUGE_VAL : 0;
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

	[glowView.layer addAnimation:animation forKey:@"pulse"];

	// (6) Keep a reference to this around so it can be removed later
	self.glowView = glowView;
}

- (void)glowOnce {
	[self startGlowing];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kDelayStopGlowOnce * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[self stopGlowing];
	});
}

- (void)startGlowing {
	[self startGlowingWithColor:[UIColor whiteColor] intensity:kGlowDefaultIntensity];
}

- (void)stopGlowing {
	[self.glowView removeFromSuperview];
	self.glowView = nil;
}

@end
