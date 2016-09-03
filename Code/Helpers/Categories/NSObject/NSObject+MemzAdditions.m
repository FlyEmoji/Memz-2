//
//  NSObject+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <objc/runtime.h>
#import <SDWebImage/SDWebImageManager.h>
#import "NSObject+MemzAdditions.h"

static char WebImageOperationsKey;

NSInteger MZDefaultTag = 0;

@implementation NSObject (MemzAdditions)

#pragma mark - Safe Cast Objects

- (id)safeCastToClass:(__unsafe_unretained Class)classType {
	if ([self isKindOfClass:classType]) {
		return self;
	} else {
		return nil;
	}
}

#pragma mark - Download Images

- (BOOL)isDownloading {
	NSDictionary * operations = objc_getAssociatedObject(self, &WebImageOperationsKey);
	return [operations count] > 0;
}

- (void)cancelDownload {
	[self cancelDownloadForTag:MZDefaultTag];
}

- (void)cancelDownloadForTag:(NSInteger)tag {
	NSMutableDictionary * operations = objc_getAssociatedObject(self, &WebImageOperationsKey);
	if(operations[@(tag)] != nil) {
		[operations[@(tag)] cancel];
		[operations removeObjectForKey:@(tag)];
	}
}

- (void)downloadImageAtURL:(NSURL *)url completionBlock:(MZDownloadImageCompletionBlock)completionBlock {
	[self downloadImageAtURL:url tag:MZDefaultTag completionBlock:completionBlock];
}

- (void)downloadImageAtURL:(NSURL *)url tag:(NSInteger)tag completionBlock:(MZDownloadImageCompletionBlock)completionBlock {
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
	NSMutableDictionary *operations = objc_getAssociatedObject(self, &WebImageOperationsKey);

	if (operations[@(tag)] != nil) {
		[self cancelDownloadForTag:tag];
	} else {
		operations = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, &WebImageOperationsKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	__block BOOL couldntDownload = NO;
	id<SDWebImageOperation> operation = [manager downloadImageWithURL:url
																														options:0
																													 progress:nil
																													completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
																														if(finished && error == nil) {
																															completionBlock(image, nil);
																														} else {
																															completionBlock(nil, error);
																														}

																														couldntDownload = YES;
																														[operations removeObjectForKey:@(tag)];
																													}];

	// If the manager didn't directly return an error
	if(!couldntDownload) {
		operations[@(tag)] = operation;
	}
}

@end
