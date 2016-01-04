//
//  MZResponse.m
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import "MZResponse.h"
#import "MZWord.h"
#import "NSString+MemzAdditions.h"

@implementation MZResponse
@synthesize delegate = _delegate;

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations {
	NSMutableSet<MZWord *> *mutableSet = [NSMutableSet setWithCapacity:self.word.translation.count];

	for (NSString *proposedTranslation in translations) {
		CGFloat __block closestPercentageSimilarity = 0.0f;
		MZWord __block *closestActualTranslation;

		for (MZWord *actualTranslation in self.word.translation.allObjects) {
			CGFloat percentageSimilarity = [proposedTranslation compareWithString:actualTranslation.word matchGain:0 missingCost:1];

			if (percentageSimilarity >= closestPercentageSimilarity && ![mutableSet containsObject:actualTranslation]) {
				closestPercentageSimilarity = percentageSimilarity;
				closestActualTranslation = actualTranslation;
			}
		}

		if (closestActualTranslation) {
			[mutableSet addObject:closestActualTranslation];
		}

		if ([self.delegate respondsToSelector:@selector(responseResult:didCheckTranslation:correctWithWord:)]) {
			[self.delegate responseResult:self didCheckTranslation:proposedTranslation correctWithWord:closestActualTranslation];
		}
	}

	return MZResponseResultRight;		// TODO: To Implement
}

@end
