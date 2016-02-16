//
//  UIColor+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 2/13/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MemzAdditions)

+ (UIColor *)averageColorBetweenColor:(UIColor *)startColor andColor:(UIColor *)endColor;

- (UIColor *)makeBrighterWithCount:(NSUInteger)count;
- (UIColor *)makeDarkerWithCount:(NSUInteger)count;

@end
