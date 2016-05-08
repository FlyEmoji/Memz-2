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
	// The following CoreData computations can be time consuming and freeze the UI: we execute them in background
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

		// (1) Use of a background context to perform those actions and ensure safe CoreData multithreading
		NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		backgroundContext.parentContext = [MZDataManager sharedDataManager].managedObjectContext;

		// TODO: Need to sync the articles
		[MZArticle deleteAllObjectsInContext:backgroundContext];
		NSMutableArray<MZArticle *> *articles = [[NSMutableArray alloc] initWithCapacity:array.count];

		for (NSDictionary *articleDictionary in array) {
			// (2) Create and populate article from response
			MZArticle *article = [MZArticle newInstanceInContext:backgroundContext];

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

			// (3) Skip the step that populates suggested words if none sent
			NSArray<NSDictionary *> *responseSuggestedWords = [articleDictionary[@"words"] safeCastToClass:[NSArray class]];
			if (!responseSuggestedWords) {
				continue;
			}

			NSString *APICodeFromLanguage = [MZRemoteServerCoordinator APILanguageCodeForLanguage:[MZUser currentUser].fromLanguage.integerValue];
			NSString *APICodeToLanguage = [MZRemoteServerCoordinator APILanguageCodeForLanguage:[MZUser currentUser].toLanguage.integerValue];

			// (4) Loop through all suggested words, only add the ones fitting our language preferences if exists
			for (NSDictionary *wordDictionary in responseSuggestedWords) {
				NSString *fromLanguageWord = wordDictionary[APICodeFromLanguage];
				NSString *toLanguageWord = wordDictionary[APICodeToLanguage];

				if (!fromLanguageWord || !toLanguageWord) {
					continue;
				}

				MZWord *suggestedWord = [MZWord addWord:fromLanguageWord
																	 fromLanguage:[MZUser currentUser].fromLanguage.integerValue
																	 translations:@[toLanguageWord]
																		 toLanguage:[MZUser currentUser].toLanguage.integerValue
																				forUser:nil
																			inContext:backgroundContext];

				[article addSuggestedWordsObject:suggestedWord];
			}
		}

		// (5) Save changes in background (handled by manager)
		[[MZDataManager sharedDataManager] saveChangesInBackground:backgroundContext completionHandler:^(NSError *error) {
			if (completionHandler) {
				completionHandler([MZArticle allObjects], error);
			}
		}];
	});
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
