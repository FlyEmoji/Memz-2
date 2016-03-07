//
//  MZRemoteServerCoordinator.m
//  Memz
//
//  Created by Bastien Falcou on 3/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZRemoteServerCoordinator.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZDataManager.h"

@implementation MZRemoteServerCoordinator

+ (void)fetchFeedWithCompletionHandler:(void (^)(NSArray<MZArticle *> *articles, NSError *))completionHandler {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"feed.json".stringByDeletingPathExtension ofType:@"feed.json".pathExtension];
	NSParameterAssert(filePath != nil);
	NSData *data = [NSData dataWithContentsOfFile:filePath];

	NSError *error;
	NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

	if (error) {
		if (completionHandler) {
			completionHandler(nil, error);
		}
		return;
	}

	[MZArticle deleteAllObjects];
	NSMutableArray<MZArticle *> *articles = [[NSMutableArray alloc] initWithCapacity:array.count];

	for (NSDictionary *articleDictionary in array) {
		MZArticle *article = [MZArticle newInstance];

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-dd-MM";

		article.remoteID = [[NSUUID alloc] initWithUUIDString:articleDictionary[@"id"]];
		article.additionDate = [dateFormatter dateFromString:articleDictionary[@"date"]];
		article.title = articleDictionary[@"title"];
		article.subTitle = articleDictionary[@"subtitle"];
		article.body = articleDictionary[@"body"];
		article.source = articleDictionary[@"source"];
		article.imageUrl = [NSURL URLWithString:articleDictionary[@"image_url"]];

		// TODO: Fetch Words

		[articles addObject:article];
	}

	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
		if (completionHandler) {
			completionHandler(articles, nil);
		}
	}];
}

@end
