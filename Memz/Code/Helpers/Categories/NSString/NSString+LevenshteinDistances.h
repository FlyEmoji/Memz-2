//
//  NSString+LevenshteinDistances.h
//  Memz
//
//  Created by Bastien Falcou on 1/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSStringScoreOption) {
	NSStringScoreOptionNone = 0,
	NSStringScoreOptionFavorSmallerWords,
	NSStringScoreOptionReducedLongStringPenalty
};

/*
 * Based on mathematical Levenshtein Distance.
 * See: https://github.com/thetron/StringScore
 */

@interface NSString (LevenshteinDistances)

- (CGFloat)percentageSimilarity:(NSString *)otherString;
- (CGFloat)percentageSimilarity:(NSString *)otherString fuzziness:(NSNumber *)fuzziness;
- (CGFloat)percentageSimilarity:(NSString *)otherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options;

@end
