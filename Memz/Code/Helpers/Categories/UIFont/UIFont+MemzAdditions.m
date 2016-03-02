//
//  UIFont+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 3/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UIFont+MemzAdditions.h"

@implementation UIFont (MemzAdditions)

+ (UIFont *)maisonBoldWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-Bold" size:size];
}

+ (UIFont *)maisonBoldItalicWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-BoldItalic" size:size];
}

+ (UIFont *)maisonBookWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-Book" size:size];
}

+ (UIFont *)maisonBookItalicWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-BookItalic" size:size];
}

+ (UIFont *)maisonDemiWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-Demi" size:size];
}

+ (UIFont *)maisonDemiItalicWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-DemiItalic" size:size];
}

+ (UIFont *)maisonLightWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-Light" size:size];
}

+ (UIFont *)maisonLightItalicWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-LightItalic" size:size];
}

+ (UIFont *)maisonMediumWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-Medium" size:size];
}

+ (UIFont *)maisonMediumItalicWithSize:(CGFloat)size {
	return [UIFont fontWithName:@"MaisonNeue-MediumItalic" size:size];
}

@end
