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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %ld", language];
	return [MZWord allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZWord *> *)wordsTranslationsForLanguage:(MZLanguage)language {
	NSMutableArray<MZWord *> *mutableWordsTranslations = [[NSMutableArray alloc] init];
	for (MZWord *word in [MZStatisticsProvider wordsForLanguage:language]) {
		[mutableWordsTranslations addObjectsFromArray:word.translation.allObjects];
	}
	return mutableWordsTranslations;
}

+ (NSArray<MZWord *> *)wordsLearnedForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %ld AND learningIndex >= %ld", language, MZWordIndexLearned];
	return [MZWord allObjectsMatchingPredicate:predicate];
}

#pragma mark - Quizzes

+ (NSArray<MZQuiz *> *)quizzesForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toLanguage = %ld", language];
	return [MZQuiz allObjectsMatchingPredicate:predicate];
}

#pragma mark - Response

+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld", language];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND quiz.answerDate >= %@ and quiz.answerDate <= %@",
														language, [date beginningDayDate], [date endDayDate]];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND result = true", language];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND result = true AND quiz.answerDate >= %@ and quiz.answerDate <= %@",
														language, [date beginningDayDate], [date endDayDate]];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

+ (CGFloat)percentageTranslationSuccessForLanguage:(MZLanguage)language {
	NSPredicate *successCountPredicate = [NSPredicate predicateWithFormat:@"result = true AND quiz.toLanguage = %ld AND quiz.isAnswered = true", [MZLanguageManager sharedManager].toLanguage];
	NSPredicate *allObjectsCountPredicate = [NSPredicate predicateWithFormat:@"quiz.toLanguage = %ld AND quiz.isAnswered = true", [MZLanguageManager sharedManager].toLanguage];

	NSUInteger successCount = [MZResponse countOfObjectsMatchingPredicate:successCountPredicate];
	NSUInteger allObjectsCount = [MZResponse countOfObjectsMatchingPredicate:allObjectsCountPredicate];

	return allObjectsCount > 0 ? successCount * 100.0f / allObjectsCount : 0.0f;
}

@end
