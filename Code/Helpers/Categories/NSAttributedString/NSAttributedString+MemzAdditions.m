//
//  NSAttributedString+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "NSAttributedString+MemzAdditions.h"

@implementation NSAttributedString (MemzAdditions)

+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font {
	return [self attributedStringWithString:text font:font color:nil];
}

+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font
																		 color:(UIColor *)color {
	return [self attributedStringWithString:text font:font color:color kernValue:0.0f];
}

+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font
																		 color:(UIColor *)color
																 kernValue:(CGFloat)kernValue {
	if (text == nil) {
		return nil;
	}

	NSMutableDictionary *mutableAttributes = [[NSMutableDictionary alloc] init];

	if (font) {
		mutableAttributes[NSFontAttributeName] = font;
	}
	if (color) {
		mutableAttributes[NSForegroundColorAttributeName] = color;
	}
	if (kernValue > 0.0f) {
		mutableAttributes[NSKernAttributeName] = @(kernValue);
	}

	return [[NSMutableAttributedString alloc] initWithString:text attributes:mutableAttributes];
}

@end
