//
//  UIImageView+MemzDownloadImage.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "UIImageView+MemzDownloadImage.h"

const NSUInteger kActivityViewTag = 12415;
const NSTimeInterval kAnimationDuration = 0.5;
const BOOL kShowActivityIndicatorDefault = YES;

@implementation UIImageView (MemzDownloadImage)

- (void)setImageWithURL:(NSURL *)url {
	[self setImageWithURL:url completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(MZDownloadImageCompletionBlock)completedBlock {
	[self setImageWithURL:url imagePlaceholder:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
					 imagePlaceholder:(UIImage *)placeholder {
	[self setImageWithURL:url imagePlaceholder:placeholder completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
					 imagePlaceholder:(UIImage *)placeholder
									completed:(MZDownloadImageCompletionBlock)completedBlock {
	[self setImageWithURL:url
					 imagePlaceholder:placeholder
			showActivityIndicator:kShowActivityIndicatorDefault
									completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
					 imagePlaceholder:(UIImage *)placeholder
			showActivityIndicator:(BOOL)showActivityIndicator {
	[self setImageWithURL:url
					 imagePlaceholder:placeholder
			showActivityIndicator:showActivityIndicator
									completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
					 imagePlaceholder:(UIImage *)placeholder
			showActivityIndicator:(BOOL)showActivityIndicator
									completed:(MZDownloadImageCompletionBlock)completedBlock {
	[self cancelDownload];

	NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
	UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
	if(cachedImage != nil) {
		self.image = cachedImage;
		if (completedBlock) {
			completedBlock(self.image, nil);
		}
	} else {
		self.image = placeholder;

		// TODO: Show activity indicator if needed

		[self downloadImageAtURL:url completionBlock:^(UIImage *image, NSError *error) {
			if (error == nil) {
				[UIView transitionWithView:self
													duration:kAnimationDuration
													 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
														 self.image = image;
													 } completion:nil];
			}

			// TODO: Hide activity indicator if needed

			if(completedBlock != nil) {
				completedBlock(image, error);
			}
		}];
	}
}

@end
