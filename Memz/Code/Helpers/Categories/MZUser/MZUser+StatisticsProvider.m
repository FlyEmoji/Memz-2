//
//  MZUser+StatisticsProvider.m
//  Memz
//
//  Created by Bastien Falcou on 5/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZUser+StatisticsProvider.h"
#import "NSManagedObject+MemzCoreData.h"
#import "NSDate+MemzAdditions.h"

@implementation MZUser (StatisticsProvider)

#pragma mark - Words

- (NSArray<MZWord *> *)wordsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %ld AND %@ IN users", language, self.objectID];
	return [MZWord allObjectsMatchingPredicate:predicate];
}

- (NSArray<MZWord *> *)wordsTranslationsForLanguage:(MZLanguage)language {
	NSMutableArray<MZWord *> *mutableWordsTranslations = [[NSMutableArray alloc] init];
	for (MZWord *word in [self wordsForLanguage:language]) {
		[mutableWordsTranslations addObjectsFromArray:word.translations.allObjects];
	}
	return mutableWordsTranslations;
}

- (NSArray<MZWord *> *)wordsLearnedForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %ld AND learningIndex >= %ld AND %@ IN users", language, MZWordIndexLearned, self.objectID];
	return [MZWord allObjectsMatchingPredicate:predicate];
}

#pragma mark - Quizzes

- (NSArray<MZQuiz *> *)quizzesForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"newLanguage = %ld AND user = %@", language, self.objectID];
	return [MZQuiz allObjectsMatchingPredicate:predicate];
}

#pragma mark - Response

- (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND quiz.user = %@", language, self.objectID];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

- (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND quiz.answerDate >= %@ AND quiz.answerDate <= %@ AND quiz.user = %@", language, [date beginningDayDate], [date endDayDate], self.objectID];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

- (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND result = true AND quiz.user = %@", language, self.objectID];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

- (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language forDay:(NSDate *)date {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word.language = %ld AND result = true AND quiz.answerDate >= %@ and quiz.answerDate <= %@ AND quiz.user = %@", language, [date beginningDayDate], [date endDayDate], self.objectID];
	return [MZResponse allObjectsMatchingPredicate:predicate];
}

- (CGFloat)percentageTranslationSuccessForLanguage:(MZLanguage)language {
	NSPredicate *successCountPredicate = [NSPredicate predicateWithFormat:@"result = true AND quiz.newLanguage = %ld AND quiz.isAnswered = true AND quiz.user = %@", [MZUser currentUser].newLanguage.integerValue, self.objectID];
	NSPredicate *allObjectsCountPredicate = [NSPredicate predicateWithFormat:@"quiz.newLanguage = %ld AND quiz.isAnswered = true AND quiz.user = %@", [MZUser currentUser].newLanguage.integerValue, self.objectID];

	NSUInteger successCount = [MZResponse countOfObjectsMatchingPredicate:successCountPredicate];
	NSUInteger allObjectsCount = [MZResponse countOfObjectsMatchingPredicate:allObjectsCountPredicate];

	return allObjectsCount > 0 ? successCount * 100.0f / allObjectsCount : 0.0f;
}

@end
