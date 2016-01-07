//
//  UIImageView+MemzDownloadImage.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "NSObject+MemzAdditions.h"

@interface UIImageView (MemzDownloadImage)

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url
							completed:(MZDownloadImageCompletionBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
			 imagePlaceholder:(UIImage *)placeholder
							completed:(MZDownloadImageCompletionBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
			 imagePlaceholder:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
			 imagePlaceholder:(UIImage *)placeholder
	showActivityIndicator:(BOOL)showActivityIndicator;

- (void)setImageWithURL:(NSURL *)url
			 imagePlaceholder:(UIImage *)placeholder
	showActivityIndicator:(BOOL)showActivityIndicator
							completed:(MZDownloadImageCompletionBlock)completedBlock;

@end
