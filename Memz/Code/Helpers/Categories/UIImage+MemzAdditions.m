//
//  UIImage+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "UIImage+MemzAdditions.h"

@implementation UIImage (MemzAdditions)

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
