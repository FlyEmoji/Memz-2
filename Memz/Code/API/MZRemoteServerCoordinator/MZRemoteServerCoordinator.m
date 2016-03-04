//
//  MZRemoteServerCoordinator.m
//  Memz
//
//  Created by Bastien Falcou on 3/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZRemoteServerCoordinator.h"

@implementation MZRemoteServerCoordinator

+ (void)fetchFeedWithCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"feed.json".stringByDeletingPathExtension ofType:@"feed.json".pathExtension];
	NSParameterAssert(filePath != nil);
	NSData *data = [NSData dataWithContentsOfFile:filePath];

	NSError *error;
	NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

	if (completionHandler) {
		completionHandler(dictionary, error);
	}
}

@end
