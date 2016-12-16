//
//  UIColor+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 2/13/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UIColor+MemzAdditions.h"

@implementation UIColor (MemzAdditions)

#pragma mark - Private Helpers

// See combining colors tutorial for more details on lerping techniques:
// https://www.weheartswift.com/combining-colors/?utm_campaign=This%2BWeek%2Bin%2BSwift&utm_medium=email&utm_source=This_Week_in_Swift_110
+ (CGFloat)lerpFrom:(CGFloat)a to:(CGFloat)b alpha:(CGFloat)alpha {
	return (1 - alpha) * a + alpha * b;
}

- (CGFloat)redComponentValue {
	CGFloat red;
	
	if ([self getRed:&red green:nil blue:nil alpha:nil]) {
		return red;
	}
	return 0.0f;
}

- (CGFloat)greenComponentValue {
	CGFloat green;
	
	if ([self getRed:nil green:&green blue:nil alpha:nil]) {
		return green;
	}
	return 0.0f;
}

- (CGFloat)blueComponentValue {
	CGFloat blue;
	
	if ([self getRed:nil green:nil blue:&blue alpha:nil]) {
		return blue;
	}
	return 0.0f;
}

#pragma mark - Public Helpers

+ (UIColor *)combineColor:(UIColor *)startColor withColor:(UIColor *)endColor percentage:(CGFloat)percentage {
	CGFloat fromRedComponent = [startColor redComponentValue];
	CGFloat fromGreenComponent = [startColor greenComponentValue];
	CGFloat fromBlueComponent = [startColor blueComponentValue];
	
	CGFloat toRedComponent = [endColor redComponentValue];
	CGFloat toGreenComponent = [endColor greenComponentValue];
	CGFloat toBlueComponent = [endColor blueComponentValue];
	
	CGFloat finalRedComponentValue = [UIColor lerpFrom:fromRedComponent to:toRedComponent alpha:percentage];
	CGFloat finalGreenComponentValue = [UIColor lerpFrom:fromGreenComponent to:toGreenComponent alpha:percentage];
	CGFloat finalBlueComponentValue = [UIColor lerpFrom:fromBlueComponent to:toBlueComponent alpha:percentage];
	
	return [UIColor colorWithRed:finalRedComponentValue
												 green:finalGreenComponentValue
													blue:finalBlueComponentValue
												 alpha:1.0f];
}

- (UIColor *)combineWith:(UIColor *)color percentage:(CGFloat)percentage {
	return [UIColor combineColor:self withColor:color percentage:percentage];
}

- (UIColor *)makeBrighterWithPercentage:(CGFloat)percentage {
	return [UIColor combineColor:self withColor:[UIColor whiteColor] percentage:percentage];
}

- (UIColor *)makeDarkerWithPercentage:(CGFloat)percentage {
	return [UIColor combineColor:self withColor:[UIColor blackColor] percentage:percentage];
}

@end
