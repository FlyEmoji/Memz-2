//
//  MZBingTranslationWrapper.m
//  Memz
//
//  Created by Bastien Falcou on 12/21/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZBingTranslationWrapper.h"

@implementation MZBingTranslationWrapper

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)task
							 completionHandler:(MZBingTranslationCompletionHandler)completionHandler {
	if (self = [super init]) {
		_dataTask = task;
		_translationCompletionHandler = completionHandler;
	}
	return self;
}

+ (instancetype)translationWrapperWithDataTask:(NSURLSessionDataTask *)task
														 completionHandler:(MZBingTranslationCompletionHandler)completionHandler {
	return [[MZBingTranslationWrapper alloc] initWithDataTask:task completionHandler:completionHandler];
}

@end
