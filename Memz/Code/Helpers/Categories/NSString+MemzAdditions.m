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

#pragma mark - Instance Methods

- (CGFloat)compareWithString:(NSString *)string matchGain:(NSInteger)gain missingCost:(NSInteger)cost {
	CGFloat averageSmallestDistance = 0.0;
	CGFloat smallestDistance;

	NSString *mStringA = [self stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	NSString *mStringB = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

	NSArray *arrayA = [mStringA componentsSeparatedByString: @" "];
	NSArray *arrayB = [mStringB componentsSeparatedByString: @" "];

	for (NSString *tokenA in arrayA) {
		smallestDistance = 99999999.0f;

		for (NSString *tokenB in arrayB) {
			smallestDistance = MIN((CGFloat)[tokenA compareWithWord:tokenB matchGain:gain missingCost:cost], smallestDistance);
		}

		averageSmallestDistance += smallestDistance;
	}
	return averageSmallestDistance / (CGFloat) [arrayA count];
}


- (NSInteger)compareWithWord:(NSString *)stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost {
	NSString * stringA = [NSString stringWithString: self];
	stringA = [[stringA stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	stringB = [[stringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];

	NSInteger k, i, j, change, *d, distance;

	NSUInteger n = [stringA length];
	NSUInteger m = [stringB length];

	if (n++ != 0 && m++ != 0) {
		d = malloc(sizeof(NSInteger) * m * n);

		for (k = 0; k < n; k++) {
			d[k] = k;
		}

		for (k = 0; k < m; k++) {
			d[k * n] = k;
		}

		for (i = 1; i < n; i++) {
			for (j = 1; j < m; j++) {
				if ([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
					change = -gain;
				} else {
					change = cost;
				}

				d[j * n + i] = MIN(d [(j - 1) * n + i] + 1, MIN(d[j * n + i - 1] +  1, d[(j - 1) * n + i -1] + change));
			}
		}

		distance = d[n * m - 1];
		free(d);
		return distance;
	}
	return 0;
}

@end
