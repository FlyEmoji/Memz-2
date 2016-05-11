//
//  UIPageControl+MemzCompatibility.h
//  Memz
//
//  Created by Bastien Falcou on 5/9/16.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Declaration of MZPageControl properties non existing in UIPageControl for compatibility.
 *  Please refer to this class if you need mode details about these properties.
 */

@interface UIPageControl (MemzCompatibility)

@property (nonatomic, assign) CGFloat dotsSpace;
@property (nonatomic, strong) UIImage *leftDotImageInactive;
@property (nonatomic, strong) UIImage *middleDotImageInactive;
@property (nonatomic, strong) UIImage *rightDotImageInactive;
@property (nonatomic, strong) UIImage *leftDotImageActive;
@property (nonatomic, strong) UIImage *middleDotImageActive;
@property (nonatomic, strong) UIImage *rightDotImageActive;

@end
