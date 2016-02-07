//
//  MZGraphicView.m
//  Memz
//
//  Created by Bastien Falcou on 2/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZGraphicView.h"

#define DEFAULT_GRADIENT_START_COLOR [UIColor graphGradientDefaultStartColor]
#define DEFAULT_GRADIENT_END_COLOR [UIColor graphGradientDefaultEndColor]

const CGFloat kHorizontalInsets = 20.0f;
const CGFloat kTopInset = 60.0f;
const CGFloat kBottomInset = 50.0f;

const CGFloat kFirstLastPointsAdditionalInset = 2.0f;

@interface MZGraphicView ()

@end

@implementation MZGraphicView

#pragma mark - Initialization

- (instancetype)init {
	if (self = [super init]) {
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
	self.gradientStartColor = DEFAULT_GRADIENT_START_COLOR;
	self.gradientEndColor = DEFAULT_GRADIENT_END_COLOR;

	self.values = @[@0, @8, @3, @6, @2, @7, @3];		// TODO: Delete after tests
}

#pragma mark - Global Overridden Methods

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	// (1) Add rounded corners
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
																						 byRoundingCorners:UIRectCornerAllCorners
																									 cornerRadii:CGSizeMake(8.0f, 8.0f)];
	[path addClip];

	// (2) Draw background gradient
	[self drawGradient];

	// (3) Calculate graphic line
	[self drawLine];
}

#pragma mark - Gradient Background

- (void)drawGradient {
	CGContextRef currentContext = UIGraphicsGetCurrentContext();

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
	CFArrayAppendValue(colorArray, self.gradientStartColor.CGColor);
	CFArrayAppendValue(colorArray, self.gradientEndColor.CGColor);

	CGFloat colorLocations[2] = {0.0f, 1.0f};

	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, colorLocations);

	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointMake(0.0f, self.bounds.size.height);
	CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
}

#pragma mark - Points 

- (CGFloat)xPointForColumn:(NSInteger)column {
	CGFloat spacer = (self.bounds.size.width - kHorizontalInsets * 2 - kFirstLastPointsAdditionalInset * 2) / (self.values.count - 1);
	return column * spacer + kHorizontalInsets + kFirstLastPointsAdditionalInset;
}

- (CGFloat)yPointForColumn:(NSInteger)column {
	CGFloat topBorder = kTopInset;
	CGFloat bottomBorder = kBottomInset;
	CGFloat graphHeight = self.frame.size.height - topBorder - bottomBorder;
	CGFloat maximumValue = [[self.values valueForKeyPath:@"@max.self"] floatValue];

	CGFloat yPoint = self.values[column].floatValue / maximumValue * graphHeight;
	return graphHeight + topBorder - yPoint;
}

#pragma mark - Line

- (void)drawLine {
	if (self.values.count == 0) {
		return;
	}

	[[UIColor whiteColor] setFill];
	[[UIColor whiteColor] setStroke];

	UIBezierPath *graphPath = [[UIBezierPath alloc] init];
	[graphPath moveToPoint:CGPointMake([self xPointForColumn:0], [self yPointForColumn:0])];

	for (NSUInteger i = 1; i < self.values.count; i++) {
		CGPoint nextPoint = CGPointMake([self xPointForColumn:i], [self yPointForColumn:i]);
		[graphPath addLineToPoint:nextPoint];
	}
}

@end
