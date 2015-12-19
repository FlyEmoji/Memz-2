//
//  MZLanguageManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZLanguageManager.h"

@implementation MZLanguageManager

+ (MZLanguageManager *)sharedManager {
	static MZLanguageManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		_fromLanguage = MZLanguageEnglish;
		_toLanguage = MZLanguageFrench;
	}
	return self;
}

@end
