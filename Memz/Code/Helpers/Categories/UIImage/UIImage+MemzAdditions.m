//
//  UIImage+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "UIImage+MemzAdditions.h"

@implementation UIImage (MemzAdditions)

#pragma mark - Flag Helpers

+ (UIImage *)flagImageForLanguage:(MZLanguage)language {
	switch (language) {
		case MZLanguageEnglish:
			return [UIImage imageWithAssetIdentifier:MZAssetIdentifierFlagUnitedKingdom];
		case MZLanguageFrench:
			return [UIImage imageWithAssetIdentifier:MZAssetIdentifierFlagFrance];
		case MZLanguageSpanish:
			return [UIImage imageWithAssetIdentifier:MZAssetIdentifierFlagSpain];
		case MZLanguageItalian:
			return [UIImage imageWithAssetIdentifier:MZAssetIdentifierFlagItalie];
		case MZLanguagePortuguese:
			return [UIImage imageWithAssetIdentifier:MZAssetIdentifierFlagPortugal];
	}
}

#pragma mark - Blur Helpers

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor {
	// Image must be nonzero size
	if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;

	// Boxsize must be an odd integer
	uint32_t boxSize = (uint32_t)(radius * self.scale);
	if (boxSize % 2 == 0) boxSize ++;

	// Create image buffers
	CGImageRef imageRef = self.CGImage;
	vImage_Buffer buffer1, buffer2;
	buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
	buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
	buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
	size_t bytes = buffer1.rowBytes * buffer1.height;
	buffer1.data = malloc(bytes);
	buffer2.data = malloc(bytes);

	// Create temp buffer
	void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
																															 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));

	// Copy image data
	CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
	memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
	CFRelease(dataSource);

	for (NSUInteger i = 0; i < iterations; i++) {
		// Perform blur
		vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

		// Swap buffers
		void *temp = buffer1.data;
		buffer1.data = buffer2.data;
		buffer2.data = temp;
	}

	// Free buffers
	free(buffer2.data);
	free(tempBuffer);

	// Create image context from buffer
	CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
																					 8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
																					 CGImageGetBitmapInfo(imageRef));

	// Apply tint
	if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
		CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
		CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
		CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
	}

	// Create image from context
	imageRef = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	CGContextRelease(ctx);
	free(buffer1.data);
	return image;
}

#pragma mark - Snaphsot Helpers

+ (UIImage *)snapshotFromView:(UIView *)view {
	UIGraphicsBeginImageContext(view.bounds.size);

	[view.layer renderInContext:UIGraphicsGetCurrentContext()];

	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return viewImage;
}

+ (UIImage *)snapshotFromView:(UIView *)view blurRadius:(CGFloat)radius iterations:(NSUInteger)iterations {
	return [[UIImage snapshotFromView:view] blurredImageWithRadius:radius iterations:iterations tintColor:nil];
}

+ (UIImage *)snapshotFromView:(UIView *)view specificArea:(CGRect)area {
	UIGraphicsBeginImageContextWithOptions(area.size, YES, [UIScreen mainScreen].scale);

	[view drawViewHierarchyInRect:CGRectMake(-area.origin.x, -area.origin.y, view.bounds.size.width, view.bounds.size.height)
						 afterScreenUpdates:YES];

	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

+ (UIImage *)snapshotFromView:(UIView *)view specificArea:(CGRect)area blurRadius:(CGFloat)radius iterations:(NSUInteger)iterations {
	return [[UIImage snapshotFromView:view specificArea:area] blurredImageWithRadius:radius iterations:iterations tintColor:nil];
}

+ (UIImage *)snapshotFromScreen {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	CGRect rect = [keyWindow bounds];

	UIGraphicsBeginImageContext(rect.size);

	CGContextRef context = UIGraphicsGetCurrentContext();
	[keyWindow.layer renderInContext:context];

	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

+ (UIImage *)snapshotFromScreenWithblurRadius:(CGFloat)radius iterations:(NSUInteger)iterations {
	return [[UIImage snapshotFromScreen] blurredImageWithRadius:radius iterations:iterations tintColor:nil];
}

#pragma mark - Resize Helpers

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
	BOOL drawTransposed;

	switch (self.imageOrientation) {
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			drawTransposed = YES;
			break;

		default:
			drawTransposed = NO;
	}

	return [self resizedImage:newSize
									transform:[self transformForOrientation:newSize]
						 drawTransposed:drawTransposed
			 interpolationQuality:quality];
}

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
																	bounds:(CGSize)bounds
										interpolationQuality:(CGInterpolationQuality)quality {
	CGFloat horizontalRatio = bounds.width / self.size.width;
	CGFloat verticalRatio = bounds.height / self.size.height;
	CGFloat ratio;

	switch (contentMode) {
		case UIViewContentModeScaleAspectFill:
			ratio = MAX(horizontalRatio, verticalRatio);
			break;

		case UIViewContentModeScaleAspectFit:
			ratio = MIN(horizontalRatio, verticalRatio);
			break;

		default:
			[NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (unsigned long)contentMode];
	}

	CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);

	return [self resizedImage:newSize interpolationQuality:quality];
}

- (UIImage *)resizedImage:(CGSize)newSize
								transform:(CGAffineTransform)transform
					 drawTransposed:(BOOL)transpose
		 interpolationQuality:(CGInterpolationQuality)quality {
	CGRect newRect = CGRectIntegral(CGRectMake(0.0f, 0.0f, newSize.width, newSize.height));
	CGRect transposedRect = CGRectMake(0.0f, 0.0f, newRect.size.height, newRect.size.width);
	CGImageRef imageRef = self.CGImage;

	// Build a context that's the same dimensions as the new size
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
																							newRect.size.width,
																							newRect.size.height,
																							CGImageGetBitsPerComponent(imageRef),
																							0.0f,
																							CGImageGetColorSpace(imageRef),
																							CGImageGetBitmapInfo(imageRef));

	// Rotate and/or flip the image if required by its orientation
	CGContextConcatCTM(bitmap, transform);

	// Set the quality level to use when rescaling
	CGContextSetInterpolationQuality(bitmap, quality);

	// Draw into the context; this scales the image
	CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);

	// Get the resized image from the context and a UIImage
	CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

	// Clean up
	CGContextRelease(bitmap);
	CGImageRelease(newImageRef);

	return newImage;
}

#pragma mark - Transform Helper

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
	CGAffineTransform transform = CGAffineTransformIdentity;

	switch (self.imageOrientation) {
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;

		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
			transform = CGAffineTransformTranslate(transform, newSize.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;

		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, 0, newSize.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;

		default:
			break;
	}

	switch (self.imageOrientation) {
		case UIImageOrientationUpMirrored:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, newSize.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;

		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, newSize.height, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;

		default:
			break;
	}
	
	return transform;
}

@end
