//
//  UIImage+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MemzAdditions)

// Flag
+ (UIImage *)flagImageForLanguage:(MZLanguage)language;

// Blur
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

// Snapshot
+ (UIImage *)snapshotFromView:(UIView *)view;
+ (UIImage *)snapshotFromView:(UIView *)view blurRadius:(CGFloat)radius iterations:(NSUInteger)iterations;

+ (UIImage *)snapshotFromView:(UIView *)view specificArea:(CGRect)area;
+ (UIImage *)snapshotFromView:(UIView *)view specificArea:(CGRect)area blurRadius:(CGFloat)radius iterations:(NSUInteger)iterations;

+ (UIImage *)snapshotFromScreen;
+ (UIImage *)snapshotFromScreenWithblurRadius:(CGFloat)radius iterations:(NSUInteger)iterations;

// Resize
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
																	bounds:(CGSize)bounds
										interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
								transform:(CGAffineTransform)transform
					 drawTransposed:(BOOL)transpose
		 interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
