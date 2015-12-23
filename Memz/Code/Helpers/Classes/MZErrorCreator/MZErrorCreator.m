//
//  MZErrorCreator.m
//  Memz
//
//  Created by Bastien Falcou on 12/22/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZErrorCreator.h"

static NSString * const MZErrorDomain = @"Falcou.com.memz.error";

@implementation MZErrorCreator

+ (NSError *)errorWithType:(MZErrorType)type {
	NSDictionary *userInfo = [MZErrorCreator userInfoForErrorType:type];
	NSError *error = [NSError errorWithDomain:MZErrorDomain code:type userInfo:userInfo];
	return userInfo ? error : nil;
}

+ (NSDictionary*)userInfoForErrorType:(MZErrorType)type {
	switch (type) {
		case MZErrorTypeUnknown:
			return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Unknown Error", nil),
							 NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"An unknown error has occured", nil),
							 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try again.", nil)};
		case MZErrorTypeAPIParseResponse:
			return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Failed To Parse API Response", nil),
							 NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"App failed to parse bing translation XML response", nil),
							 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"", nil)};
	}
}

@end
