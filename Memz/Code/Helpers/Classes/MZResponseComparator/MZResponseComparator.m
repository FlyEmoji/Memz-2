//
//  MZResponseComparator.m
//  Memz
//
//  Created by Bastien Falcou on 1/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZResponseComparator.h"
#import "NSString+MemzAdditions.h"
#import "MZWord.h"

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
	NSMutableSet<MZWord *> *mutableSet = [NSMutableSet setWithCapacity:self.response.word.translation.count];

	for (NSString *proposedTranslation in translations) {
		CGFloat __block closestPercentageSimilarity = 0.0f;
		MZWord __block *closestActualTranslation;

		for (MZWord *actualTranslation in self.response.word.translation.allObjects) {
			CGFloat percentageSimilarity = [proposedTranslation compareWithString:actualTranslation.word matchGain:0 missingCost:1];

			if (percentageSimilarity >= closestPercentageSimilarity && ![mutableSet containsObject:actualTranslation]) {
				closestPercentageSimilarity = percentageSimilarity;
				closestActualTranslation = actualTranslation;
			}
		}

		if (closestActualTranslation) {
			[mutableSet addObject:closestActualTranslation];
		}

		if ([self.delegate respondsToSelector:@selector(responseComparator:didCheckTranslation:correctWithWord:)]) {
			[self.delegate responseComparator:self didCheckTranslation:proposedTranslation correctWithWord:closestActualTranslation];
		}
	}

	return MZResponseResultRight;		// TODO: Send Right One
}

@end