//
//  UIColor+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 2/13/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UIColor+MemzAdditions.h"

@implementation UIColor (MemzAdditions)

+ (UIColor *)averageColorBetweenColor:(UIColor *)startColor andColor:(UIColor *)endColor {
	CGFloat r1, r2, g1, g2, b1, b2, a1, a2;

	if ([startColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1]
			&& [endColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2]) {
		return [UIColor colorWithRed:(r1 + r2) / 2.0f
													 green:(g1 + g2) / 2.0f
														blue:(b1 + b2) / 2.0f
													 alpha:(a1 + a2) / 2.0f];
	}
	return nil;
}

- (UIColor *)makeBrighterWithCount:(NSUInteger)count {
	UIColor *color = self;
	for (NSUInteger i = count; i > 0; i--) {
		color = [[self class] averageColorBetweenColor:color andColor:[UIColor whiteColor]];
	}
	return color;
}

- (UIColor *)makeDarkerWithCount:(NSUInteger)count {
	UIColor *color = self;
	for (NSUInteger i = count; i > 0; i--) {
		color = [[self class] averageColorBetweenColor:color andColor:[UIColor blackColor]];
	}
	return color;
}

@end
