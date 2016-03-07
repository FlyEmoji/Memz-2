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
#import "MZWord.h"

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
		// (1) Create and populate article from response
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

		[articles addObject:article];

		// (2) Skip the step that populates suggested words if none sent
		NSArray<NSDictionary *> *responseSuggestedWords = [articleDictionary[@"words"] safeCastToClass:[NSArray class]];
		if (!responseSuggestedWords) {
			continue;
		}

		NSString *APICodeFromLanguage = [MZRemoteServerCoordinator APILanguageCodeForLanguage:[MZLanguageManager sharedManager].fromLanguage];
		NSString *APICodeToLanguage = [MZRemoteServerCoordinator APILanguageCodeForLanguage:[MZLanguageManager sharedManager].toLanguage];

		// (3) Loop through all suggested words, only add the ones fitting our language preferences if exists
		for (NSDictionary *wordDictionary in responseSuggestedWords) {
			NSString *fromLanguageWord = wordDictionary[APICodeFromLanguage];
			NSString *toLanguageWord = wordDictionary[APICodeToLanguage];

			if (!fromLanguageWord || !toLanguageWord) {
				continue;
			}

			MZWord *suggestedWord = [MZWord addWord:fromLanguageWord
																 fromLanguage:[MZLanguageManager sharedManager].fromLanguage
																 translations:@[toLanguageWord]
																	 toLanguage:[MZLanguageManager sharedManager].toLanguage];

			[article addSuggestedWordsObject:suggestedWord];
		}
	}

	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
		if (completionHandler) {
			completionHandler(articles, nil);
		}
	}];
}

#pragma mark - Language Parser

+ (NSString *)APILanguageCodeForLanguage:(MZLanguage)language {
	switch (language) {
		case MZLanguageEnglish:
			return @"en";
		case MZLanguageFrench:
			return @"fr";
		case MZLanguageSpanish:
			return @"es";
		case MZLanguageItalian:
			return @"it";
		case MZLanguagePortuguese:
			return @"pr";
	}
}

@end
