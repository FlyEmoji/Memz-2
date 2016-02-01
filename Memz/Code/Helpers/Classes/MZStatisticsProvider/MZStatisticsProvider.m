//
//  MZStatisticsProvider.m
//  Memz
//
//  Created by Bastien Falcou on 2/2/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZStatisticsProvider.h"
#import "NSManagedObject+MemzCoreData.h"
#import "NSDate+MemzAdditions.h"

@implementation MZStatisticsProvider

#pragma mark - Words

+ (NSArray<MZWord *> *)wordsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %@", language];
	return [MZWord allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZWord *> *)wordsTranslationsForLanguage:(MZLanguage)language {
	NSMutableArray<MZWord *> *mutableWordsTranslations = [[NSMutableArray alloc] init];
	for (MZWord *word in [MZStatisticsProvider wordsForLanguage:language]) {
		[mutableWordsTranslations addObjectsFromArray:word.translation.allObjects];
	}
	return mutableWordsTranslations;
}

#pragma mark - Quizzes

+ (NSArray<MZQuiz *> *)quizzesForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toLanguage = %@", language];
	return [MZQuiz allObjectsMatchingPredicate:predicate];
}

#pragma mark - Response

+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %@", language];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %@ and date >= %@ and date <= %@",
														language, [date beginningDayDate], [date endDayDate]];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %@ and result = 1", language];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %@ and result = 1 and date >= %@ and date <= %@",
														language, [date beginningDayDate], [date endDayDate]];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

@end
