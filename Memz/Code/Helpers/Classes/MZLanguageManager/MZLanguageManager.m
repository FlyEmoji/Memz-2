//
//  MZLanguageManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZLanguageManager.h"

NSString * const kFromLanguageKey = @"FromLanguageKey";
NSString * const kToLanguageKey = @"ToLanguageKey";

@implementation MZLanguageManager

+ (MZLanguageManager *)sharedManager {
	static MZLanguageManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

#pragma mark - Custom Getters and Setters & Persistance

- (void)setFromLanguage:(MZLanguage)fromLanguage {
	[[NSUserDefaults standardUserDefaults] setObject:@(fromLanguage) forKey:kFromLanguageKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToLanguage:(MZLanguage)toLanguage {
	[[NSUserDefaults standardUserDefaults] setObject:@(toLanguage) forKey:kToLanguageKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (MZLanguage)fromLanguage {
	// Initialize From Language if never initialized yet
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kFromLanguageKey] == nil) {
		self.fromLanguage = MZLanguageFrench;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kFromLanguageKey] integerValue];
}

- (MZLanguage)toLanguage {
	// Initialize To Language if never initialized yet
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kToLanguageKey] == nil) {
		self.toLanguage = MZLanguageEnglish;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kToLanguageKey] integerValue];
}

@end
