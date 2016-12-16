//
//  UIColor+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 2/13/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MemzAdditions)

+ (UIColor *)combineColor:(UIColor *)startColor withColor:(UIColor *)endColor percentage:(CGFloat)percentage;

- (UIColor *)combineWith:(UIColor *)color percentage:(CGFloat)percentage;
- (UIColor *)makeBrighterWithPercentage:(CGFloat)percentage;
- (UIColor *)makeDarkerWithPercentage:(CGFloat)percentage;

@end
