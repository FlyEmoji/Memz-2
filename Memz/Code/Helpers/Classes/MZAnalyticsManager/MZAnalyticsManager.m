//
//  MZAnalyticsManager.m
//  Memz
//
//  Created by Bastien Falcou on 5/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Analytics/SEGAnalytics.h>
#import "MZAnalyticsManager.h"
#import "NSString+MemzAdditions.h"

static NSString * const MZTrackScreenUserEntranceIdentifier = @"User Entrance Screen";
static NSString * const MZTrackScreenWordAdditionIdentifier = @"Word Addition Screen";
static NSString * const MZTrackScreenSettingsIdentifier = @"Settings Screen";
static NSString * const MZTrackScreenStatisticsIdentifier = @"Statistics Screen";
static NSString * const MZTrackScreenQuizIdentifier = @"Quiz Screen";

static NSString * const MZTrackEventWordAdditionIdentifier = @"Word Addition";

static NSString * const MZTrackPhoneIdentifier = @"Type Phone";
static NSString * const MZTrackWordIdentifier = @"Word Added";
static NSString * const MZTrackKnownLanguageIdentifier = @"Known Language";
static NSString * const MZTrackNewLanguageIdentifier = @"New Language";
static NSString * const MZTrackNumberTranslationsIdentifier = @"Number Translations";

@implementation MZAnalyticsManager

+ (MZAnalyticsManager *)sharedManager {
	static MZAnalyticsManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

#pragma mark - Setups

- (void)setupAnalytics {
	SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];
	configuration.trackApplicationLifecycleEvents = YES;
	configuration.recordScreenViews = YES;
	[SEGAnalytics setupWithConfiguration:configuration];

	[[SEGAnalytics sharedAnalytics] identify:[[UIDevice currentDevice] identifierForVendor].UUIDString
																		traits:@{MZTrackPhoneIdentifier: [[UIDevice currentDevice] identifierForVendor].UUIDString}];
}

#pragma mark - Track Screen

- (void)trackScreen:(MZAnalyticsScreen)screen {
	NSString *trackIdentifier;

	switch (screen) {
		case MZAnalyticsScreenUserEntrance:
			trackIdentifier = MZTrackScreenUserEntranceIdentifier;
			break;
		case MZAnalyticsScreenWordAddition:
			trackIdentifier = MZTrackScreenWordAdditionIdentifier;
			break;
		case MZAnalyticsScreenSettings:
			trackIdentifier = MZTrackScreenSettingsIdentifier;
			break;
		case MZAnalyticsScreenStatistics:
			trackIdentifier = MZTrackScreenStatisticsIdentifier;
			break;
		case MZAnalyticsScreenQuiz:
			trackIdentifier = MZTrackScreenQuizIdentifier;
			break;
	}
	[[SEGAnalytics sharedAnalytics] screen:trackIdentifier];
}

#pragma mark - Track Events

- (void)trackWordAddition:(NSString *)word
						 translations:(NSArray<NSString *> *)translations
						knownLanguage:(MZLanguage)knownLanguage
							newLanguage:(MZLanguage)newLanguage {
	[[SEGAnalytics sharedAnalytics] track:MZTrackEventWordAdditionIdentifier
														 properties:@{MZTrackWordIdentifier: word,
																					MZTrackNumberTranslationsIdentifier: [NSString stringWithFormat:@"%lu", (unsigned long)translations.count],
																					MZTrackKnownLanguageIdentifier: [NSString languageNameForLanguage:knownLanguage],
																					MZTrackNewLanguageIdentifier: [NSString languageNameForLanguage:newLanguage]}];
}

@end
