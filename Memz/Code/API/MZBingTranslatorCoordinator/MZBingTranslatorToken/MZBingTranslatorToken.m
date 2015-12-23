//
//  MZBingTranslatorToken.m
//  Memz
//
//  Created by Bastien Falcou on 12/22/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZBingTranslatorToken.h"

@implementation MZBingTranslatorToken

- (id)initWithToken:(NSString *)token expiry:(NSDate *)expiry {
	if (self = [super init]) {
		_token = token;
		_expiry = expiry;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"token: %@ and expiry: %@", self.token, self.expiry];
}

- (BOOL)isValid {
	if (!self.token || !self.expiry) {
		return NO;
	}
	return [self.expiry timeIntervalSinceNow] > 0;
}

@end
