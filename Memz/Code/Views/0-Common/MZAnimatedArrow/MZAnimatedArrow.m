//
//  MZAnimatedArrow.m
//  Memz
//
//  Created by Bastien Falcou on 5/23/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZAnimatedArrow.h"

#define kDefaultColor [UIColor blackColor]

NSString * const kArrowAnimationIdentifier = @"MZArrowAnimationIdentifier";
NSString * const kContinuousSlideAnimationIdentifier = @"continuousSlideAnimationIdentifier";

const CGFloat kLineWidth = 4.0f;
const CGFloat kMaskHeightOffsetPercentage = 1.5f;

@interface MZAnimatedArrow ()

@property (nonatomic, strong) UIView *rotatableView;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, assign) CGFloat currentRotationAngle;

@end

@implementation MZAnimatedArrow

- (instancetype)init {
	if (self = [super init] ) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.arrowColor = kDefaultColor;
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	[self.rotatableView removeFromSuperview];
	self.rotatableView = [[UIView alloc] initWithFrame:rect];
	self.rotatableView.backgroundColor = [UIColor clearColor];
	self.rotatableView.userInteractionEnabled = NO;
	[self addSubview:self.rotatableView];

	self.layer.backgroundColor = [[UIColor clearColor] CGColor];
	UIImage *lineImage = [self generateLineImageWithColor:self.arrowColor];

	self.lineLayer = [CALayer layer];
	self.lineLayer.contents = (id)[lineImage CGImage];
	self.lineLayer.frame = CGRectMake(0.0f, 0.0f, lineImage.size.width, lineImage.size.height);

	self.maskLayer = [CALayer layer];

	// (1) Mask image ends with increasing opacity gradient on both sides. Set the background
	// color of the layer to clear color so the layer can extend the mask image.
	self.maskLayer.backgroundColor = [UIColor clearColor].CGColor;
	self.maskLayer.contents = (id)[[UIImage imageWithAssetIdentifier:MZAssetIdentifierCommonMask] CGImage];

	// (2) Center the mask image on twice the width of the text layer, so it starts to the left
	// of the text layer and moves to its right when we translate it by width.
	self.maskLayer.contentsGravity = kCAGravityCenter;
	self.maskLayer.frame = CGRectMake(0.0f,
																		-lineImage.size.height * kMaskHeightOffsetPercentage,
																		lineImage.size.width,
																		lineImage.size.height * 2.0f);

	self.lineLayer.mask = self.maskLayer;
	[self.rotatableView.layer addSublayer:self.lineLayer];
}

#pragma mark - Generic Animation

- (void)animateWithDirection:(MZAnimatedArrowDirection)direction
					 animationDuration:(NSTimeInterval)animationDuration
								 repeatCount:(NSInteger)repeatCount
								animationKey:(NSString *)animationKey {
	if ((direction == MZAnimatedArrowDirectionDown && self.currentRotationAngle != 180.0f)
			|| (direction == MZAnimatedArrowDirectionUp && self.currentRotationAngle != 0.0f)) {
		self.rotatableView.layer.transform = CATransform3DMakeRotation(180.0f / 180.0f * M_PI, 0.0f, 0.0f, 1.0f);
		self.currentRotationAngle = direction == MZAnimatedArrowDirectionDown ? 180.0f : 0.0f;
	}

	// Swipe Animation
	UIColor *lineColor = self.arrowColor;
	UIImage *lineImage = [self generateLineImageWithColor:lineColor];
	self.lineLayer.contents = (id)[lineImage CGImage];

	CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	maskAnimation.byValue = @(self.bounds.size.height * kMaskHeightOffsetPercentage);

	CAKeyframeAnimation *fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.values = @[@0.0f, @0.0f, @1.0f, @1.0f, @0.0f];
	fadeAnimation.keyTimes = @[@0.0f, @0.3f, @0.6f, @0.8f, @0.95f];

	CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
	groupAnimation.duration = animationDuration;
	groupAnimation.repeatCount = repeatCount;
	groupAnimation.fillMode = kCAFillModeForwards;
	groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	groupAnimation.animations = @[maskAnimation, fadeAnimation];
	[groupAnimation setValue:animationKey forKey:kArrowAnimationIdentifier];

	self.maskLayer.borderColor = [UIColor redColor].CGColor;
	self.maskLayer.borderWidth = 2.0f;

	[self.maskLayer addAnimation:groupAnimation forKey:animationKey];
}

#pragma mark - Continuous Animation

- (void)animateContinuouslyWithDirection:(MZAnimatedArrowDirection)direction
											 animationDuration:(NSTimeInterval)animationDuration {
	[self animateWithDirection:direction
					 animationDuration:animationDuration
								 repeatCount:HUGE_VALF
								animationKey:kContinuousSlideAnimationIdentifier];
}

- (void)stopAnimation {
	[self.layer removeAnimationForKey:kContinuousSlideAnimationIdentifier];
}

#pragma mark - Line

- (UIImage *)generateLineImageWithColor:(UIColor *)color {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);

	[[color colorWithAlphaComponent:0.8f] setStroke];

	UIBezierPath *path = [UIBezierPath bezierPath];
	path.lineWidth = kLineWidth;
	[path moveToPoint:CGPointMake(0.0f, self.bounds.size.height)];
	[path addLineToPoint:CGPointMake(self.bounds.size.width / 2.0f, 0.0f)];
	[path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];

	[path stroke];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
