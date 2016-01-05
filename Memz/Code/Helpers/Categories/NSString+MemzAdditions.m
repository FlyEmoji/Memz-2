//
//  NSString+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/21/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "NSString+MemzAdditions.h"

@implementation NSString (MemzAdditions)

#pragma mark - Class Methods

+ (NSString *)urlEncodedStringFromString:(NSString *)original {
	NSMutableString *escaped = [NSMutableString stringWithString:[original stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

	[escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];

	return escaped;
}

+ (NSString *)stringForDuration:(NSTimeInterval)duration {
	int totalSeconds = duration;

	int seconds = totalSeconds % 60;
	int minutes = (totalSeconds / 60) % 60;

	return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

#pragma mark - Similarity Between Strings
/* 
 * Based on mathematical Levenshtein Distance.
 * See: https://github.com/thetron/StringScore
 */

- (CGFloat)percentageSimilarity:(NSString *)otherString {
	return [self percentageSimilarity:otherString fuzziness:@1.0f];
}

- (CGFloat)percentageSimilarity:(NSString *)otherString fuzziness:(NSNumber *)fuzziness {
	return [self percentageSimilarity:otherString fuzziness:fuzziness options:NSStringScoreOptionNone];
}

- (CGFloat)percentageSimilarity:(NSString *)anotherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options {
	NSMutableCharacterSet *workingInvalidCharacterSet = [NSMutableCharacterSet lowercaseLetterCharacterSet];
	[workingInvalidCharacterSet formUnionWithCharacterSet:[NSCharacterSet uppercaseLetterCharacterSet]];
	[workingInvalidCharacterSet addCharactersInString:@" "];

	NSCharacterSet *invalidCharacterSet = [workingInvalidCharacterSet invertedSet];

	NSString *string = [[[self decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];
	NSString *otherString = [[[anotherString decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];

	if ([string isEqualToString:otherString]) {
		return 1.0f;
	}

	if ([otherString length] == 0) {
		return 0.0f;
	}

	CGFloat totalCharacterScore = 0.0f;
	CGFloat otherStringScore;
	CGFloat fuzzies = 1.0f;
	CGFloat finalScore;

	NSUInteger otherStringLength = [otherString length];
	NSUInteger stringLength = [string length];
	BOOL startOfStringBonus = NO;

	for	(NSUInteger index = 0; index < otherStringLength; index++) {
		CGFloat characterScore = 0.1;
		NSInteger indexInString = NSNotFound;
		NSString *chr;
		NSRange rangeChrLowercase;
		NSRange rangeChrUppercase;

		chr = [otherString substringWithRange:NSMakeRange(index, 1)];

		rangeChrLowercase = [string rangeOfString:[chr lowercaseString]];
		rangeChrUppercase = [string rangeOfString:[chr uppercaseString]];

		if (rangeChrLowercase.location == NSNotFound && rangeChrUppercase.location == NSNotFound) {
			if (fuzziness) {
				fuzzies += 1 - [fuzziness floatValue];
			} else {
				return 0;
			}

		} else if (rangeChrLowercase.location != NSNotFound && rangeChrUppercase.location != NSNotFound) {
			indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
		} else if(rangeChrLowercase.location != NSNotFound || rangeChrUppercase.location != NSNotFound) {
			indexInString = rangeChrLowercase.location != NSNotFound ? rangeChrLowercase.location : rangeChrUppercase.location;
		} else {
			indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
		}

		if (indexInString != NSNotFound && [[string substringWithRange:NSMakeRange(indexInString, 1)] isEqualToString:chr]) {
			characterScore += 0.1f;
		}

		// Consecutive letter & start-of-string bonus
		if (indexInString == 0) {
			// Increase the score when matching first character of the remainder of the string
			characterScore += 0.6f;
			if (index == 0){
				// If match is the first character of the string
				// & the first character of abbreviation, add a
				// start-of-string match bonus.
				startOfStringBonus = YES;
			}
		} else if(indexInString != NSNotFound) {
			// Acronym Bonus
			// Weighing Logic: Typing the first character of an acronym is as if you
			// preceded it with two perfect character matches.
			if( [[string substringWithRange:NSMakeRange(indexInString - 1, 1)] isEqualToString:@" "] ){
				characterScore += 0.8f;
			}
		}

		// Left trim the already matched part of the string
		// (forces sequential matching).
		if (indexInString != NSNotFound) {
			string = [string substringFromIndex:indexInString + 1];
		}

		totalCharacterScore += characterScore;
	}

	if (NSStringScoreOptionFavorSmallerWords == (options & NSStringScoreOptionFavorSmallerWords)) {
		// Weigh smaller words higher
		return totalCharacterScore / stringLength;
	}

	otherStringScore = totalCharacterScore / otherStringLength;

	if (NSStringScoreOptionReducedLongStringPenalty == (options & NSStringScoreOptionReducedLongStringPenalty)) {
		// Reduce the penalty for longer words
		CGFloat percentageOfMatchedString = otherStringLength / stringLength;
		CGFloat wordScore = otherStringScore * percentageOfMatchedString;
		finalScore = (wordScore + otherStringScore) / 2.0f;
	} else {
		finalScore = ((otherStringScore * ((CGFloat)(otherStringLength) / (CGFloat)(stringLength))) + otherStringScore) / 2.0f;
	}

	finalScore = finalScore / fuzzies;

	if (startOfStringBonus && finalScore + 0.15f < 1) {
		finalScore += 0.15f;
	}

	return finalScore;
}

@end
