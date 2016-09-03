//
//  UIPageControl+MemzCompatibility.m
//  Memz
//
//  Created by Bastien Falcou on 5/9/16.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

#import "UIPageControl+MemzCompatibility.h"

const CGFloat kCompatibilityPageControlDotsOriginalSpace = 6.0f;

@implementation UIPageControl (EthanolCompatibility)

- (void)setDotsSpace:(CGFloat)dotsSpace {
}

- (CGFloat)dotsSpace {
  return kCompatibilityPageControlDotsOriginalSpace;
}

- (void)setLeftDotImageActive:(UIImage *)leftDotImageActive {
}

- (UIImage *)leftDotImageActive {
  return nil;
}

- (void)setMiddleDotImageActive:(UIImage *)middleDotImageActive {
}

- (UIImage *)middleDotImageActive {
  return nil;
}

- (void)setRightDotImageActive:(UIImage *)rightDotImageActive {
}

- (UIImage *)rightDotImageActive {
  return nil;
}

- (void)setLeftDotImageInactive:(UIImage *)leftDotImageInactive {
}

- (UIImage *)leftDotImageInactive {
  return nil;
}

- (void)setMiddleDotImageInactive:(UIImage *)middleDotImageInactive {
}

- (UIImage *)middleDotImageInactive {
  return nil;
}

- (void)setRightDotImageInactive:(UIImage *)rightDotImageInactive {
}

- (UIImage *)rightDotImageInactive {
  return nil;
}

@end