//
//  MZAnimatedArrow.m
//  Memz
//
//  Created by Bastien Falcou on 5/23/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZAnimatedArrow.h"

#define kDefaultColor [UIColor blackColor]

NSString * const kContinuousSlideAnimationIdentifier = @"MZContinuousSlideAnimationIdentifier";

const CGFloat kDefaultLineWidth = 2.5f;
const CGFloat kNumberTimesOffset = 2.0f;

@interface MZAnimatedArrow ()

@property (nonatomic, assign) MZAnimatedArrowDirection animationDirection;

@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic, weak, readonly) NSString *animationKey;

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
	self.lineWidth = kDefaultLineWidth;
	self.arrowColor = kDefaultColor;
	self.animationDirection = MZAnimatedArrowDirectionUp;
}

#pragma mark - Custom Getter

- (NSString *)animationKey {
	return [NSString stringWithFormat:@"%@%@", kContinuousSlideAnimationIdentifier, self];
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;

	self.layer.backgroundColor = [[UIColor clearColor] CGColor];
	UIImage *lineImage = [self generateLineImageWithColor:self.arrowColor direction:self.animationDirection];

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
	self.maskLayer.contentsGravity = kCAGravityResizeAspectFill;
	self.maskLayer.frame = CGRectMake(0.0f,
																		-kNumberTimesOffset * rect.size.height,
																		rect.size.width,
																		rect.size.height / kNumberTimesOffset);

	self.lineLayer.mask = self.maskLayer;
	[self.layer addSublayer:self.lineLayer];
}

#pragma mark - Generic Animation

- (void)animateWithDirection:(MZAnimatedArrowDirection)direction
					 animationDuration:(NSTimeInterval)animationDuration
								 repeatCount:(NSInteger)repeatCount
								animationKey:(NSString *)animationKey {
	UIColor *lineColor = self.arrowColor;
	UIImage *lineImage = [self generateLineImageWithColor:lineColor direction:direction];
	self.lineLayer.contents = (id)[lineImage CGImage];
	self.animationDirection = direction;

	CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
	maskAnimation.toValue = @(self.bounds.size.height * kNumberTimesOffset);
	maskAnimation.duration = animationDuration;
	maskAnimation.repeatCount = repeatCount;
	maskAnimation.fillMode = kCAFillModeForwards;
	maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

	[self.maskLayer addAnimation:maskAnimation forKey:animationKey];
}

#pragma mark - Continuous Animation

- (void)animateContinuouslyWithDirection:(MZAnimatedArrowDirection)direction
											 animationDuration:(NSTimeInterval)animationDuration {
	[self animateWithDirection:direction
					 animationDuration:animationDuration
								 repeatCount:HUGE_VALF
								animationKey:self.animationKey];
}

- (void)stopAnimation {
	[self.layer removeAnimationForKey:self.animationKey];
}

#pragma mark - Line

- (UIImage *)generateLineImageWithColor:(UIColor *)color direction:(MZAnimatedArrowDirection)direction {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);

	[[color colorWithAlphaComponent:0.8f] setStroke];

	UIBezierPath *path = [UIBezierPath bezierPath];
	path.lineWidth = self.lineWidth;

	if (direction == MZAnimatedArrowDirectionUp) {
		[path moveToPoint:CGPointMake(0.0f, self.bounds.size.height)];
		[path addLineToPoint:CGPointMake(self.bounds.size.width / 2.0f, 0.0f)];
		[path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
	} else {
		[path moveToPoint:CGPointMake(0.0f, 0.0f)];
		[path addLineToPoint:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height)];
		[path addLineToPoint:CGPointMake(self.bounds.size.width, 0.0f)];
	}

	[path stroke];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
