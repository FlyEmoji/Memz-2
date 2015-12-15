//
//  NSObject+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ MZDownloadImageCompletionBlock)(UIImage *image, NSError * error);

@interface NSObject (MemzAdditions)

// Safe cast objects
- (id)safeCastToClass:(__unsafe_unretained Class)classType;

// Download images
@property (nonatomic, assign, readonly) BOOL isDownloading;

- (void)downloadImageAtURL:(NSURL *)url completionBlock:(MZDownloadImageCompletionBlock)completionBlock;
- (void)downloadImageAtURL:(NSURL *)url tag:(NSInteger)tag completionBlock:(MZDownloadImageCompletionBlock)completionBlock;

- (void)cancelDownload;
- (void)cancelDownloadForTag:(NSInteger)tag;

@end
