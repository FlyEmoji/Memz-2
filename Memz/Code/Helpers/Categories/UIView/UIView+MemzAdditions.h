//
//  UIView+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MemzAdditions)

// Corner Radius

- (void)applyCornerRadius:(CGFloat)cornerRadius;
- (void)makeCircular;

// Glow

- (void)glowOnce;  // Fade up, then down.

- (void)startGlowing;
- (void)startGlowingWithColor:(UIColor *)color intensity:(CGFloat)intensity;
- (void)stopGlowing;

@end
