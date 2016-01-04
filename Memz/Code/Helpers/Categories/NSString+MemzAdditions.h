//
//  NSString+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/21/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSStringScoreOption) {
	NSStringScoreOptionNone = 0,
	NSStringScoreOptionFavorSmallerWords,
	NSStringScoreOptionReducedLongStringPenalty
};

@interface NSString (MemzAdditions)

+ (NSString *)urlEncodedStringFromString:(NSString *)original;
+ (NSString *)stringForDuration:(NSTimeInterval)duration;

- (CGFloat)percentageSimilarity:(NSString *)otherString;
- (CGFloat)percentageSimilarity:(NSString *)otherString fuzziness:(NSNumber *)fuzziness;
- (CGFloat)percentageSimilarity:(NSString *)otherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options;

@end
