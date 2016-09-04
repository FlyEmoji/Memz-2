//
//  MZDataBackgroundTaskWrapper.m
//  Memz
//
//  Created by Bastien Falcou on 3/7/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZDataBackgroundTaskWrapper.h"

@implementation MZDataBackgroundTaskWrapper

+ (instancetype)dataBackgroundTaskWithContext:(NSManagedObjectContext *)context
															completionBlock:(MZDataTaskCompletionBlock)completionBlock {
	return [[MZDataBackgroundTaskWrapper alloc] initWithContext:context completionBlock:completionBlock];
}

- (instancetype)initWithContext:(NSManagedObjectContext *)context
								completionBlock:(MZDataTaskCompletionBlock)completionBlock {
	if (self = [super init]) {
		_context = context;
		_completionBlock = completionBlock;
	}
	return self;
}

@end
