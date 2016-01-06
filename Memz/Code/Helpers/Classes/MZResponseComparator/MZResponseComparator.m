//
//  MZResponseComparator.m
//  Memz
//
//  Created by Bastien Falcou on 1/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZResponseComparator.h"
#import "NSString+LevenshteinDistances.h"
#import "MZWord.h"

const CGFloat kMinimumPercentageConsiderTrue = 0.9f;
const CGFloat kMinimumPercentageConsiderLearningInProgress = 0.5f;

@implementation MZResponseComparator

- (instancetype)initWithResponse:(MZResponse *)response {
	if (self = [super init]) {
		_response = response;
	}
	return self;
}

+ (instancetype)responseComparatorWithResponse:(MZResponse *)response {
	return [[MZResponseComparator alloc] initWithResponse:response];
}

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations {
	// Build arrays of similarity percentage
	NSMutableArray<NSMutableArray<NSNumber *> *> *arrayPercentages = [NSMutableArray arrayWithCapacity:self.response.word.translation.count];

	NSUInteger i = 0;
	for (MZWord *actualTranslation in self.response.word.translation.allObjects) {
		arrayPercentages[i] = [[NSMutableArray alloc] initWithCapacity:self.response.word.translation.count];

		NSUInteger j = 0;
		for (NSString *proposedTranslation in translations) {
			arrayPercentages[i][j] = @([actualTranslation.word percentageSimilarity:proposedTranslation]);
			j++;
		}
		i++;
	}

	// Interpreat those arrays
	NSMutableSet<NSString *> *mutableSet = [NSMutableSet setWithCapacity:self.response.word.translation.count];

	CGFloat totalSuccessPercentage = 0.0f;
	CGFloat unitySucessPercentage = 1.0f / self.response.word.translation.count;

	for (NSUInteger i = 0; i < arrayPercentages.count; i++) {
		NSString *mostLikelyTranslation;
		CGFloat highestPercentage = 0.0f;

		for (NSUInteger j = 0; j < arrayPercentages[i].count; j++) {
			CGFloat percentage = arrayPercentages[i][j].floatValue;

			if (percentage >= highestPercentage && ![mutableSet containsObject:translations[j]]) {
				highestPercentage = percentage;
				mostLikelyTranslation = translations[j];
			}
		}

		if (mostLikelyTranslation) {
			[mutableSet addObject:mostLikelyTranslation];
		}

		if ([self.delegate respondsToSelector:@selector(responseComparator:didCheckTranslation:correctWithWord:isTranslationCorrect:)]) {
			[self.delegate responseComparator:self
										didCheckTranslation:mostLikelyTranslation
												correctWithWord:self.response.word.translation.allObjects[i]
									 isTranslationCorrect:highestPercentage >= kMinimumPercentageConsiderTrue];
		}

		if (highestPercentage >= kMinimumPercentageConsiderTrue) {
			totalSuccessPercentage += unitySucessPercentage;
		} else if (highestPercentage >= kMinimumPercentageConsiderLearningInProgress) {
			totalSuccessPercentage += unitySucessPercentage / 2.0f;
		}
	}

	return [self responseResultForSimilarityPercentage:totalSuccessPercentage];
}

#pragma mark - Helpers

- (MZResponseResult)responseResultForSimilarityPercentage:(CGFloat)similarityPercentage {
	if (similarityPercentage >= kMinimumPercentageConsiderTrue) {
		return MZResponseResultRight;
	} else if (similarityPercentage >= kMinimumPercentageConsiderLearningInProgress) {
		return MZResponseResultLearningInProgress;
	}
	return MZResponseResultWrond;
}

@end