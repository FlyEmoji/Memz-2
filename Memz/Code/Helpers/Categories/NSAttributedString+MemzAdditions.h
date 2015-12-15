//
//  NSAttributedString+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (MemzAdditions)

+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font;
+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font
																		 color:(UIColor *)color;
+ (instancetype)attributedStringWithString:(NSString *)text
																			font:(UIFont *)font
																		 color:(UIColor *)color
																 kernValue:(CGFloat)kernValue;


@end
