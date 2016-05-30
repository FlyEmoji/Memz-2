//
//  MZAnalyticsManager.m
//  Memz
//
//  Created by Bastien Falcou on 5/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Analytics/SEGAnalytics.h>
#import "MZAnalyticsManager.h"

static NSString * const MZTrackScreenUserEntranceIdentifier = @"User Entrance Screen";
static NSString * const MZTrackScreenWordAdditionIdentifier = @"Word Addition Screen";
static NSString * const MZTrackScreenSettingsIdentifier = @"Settings Screen";
static NSString * const MZTrackScreenStatisticsIdentifier = @"Statistics Screen";
static NSString * const MZTrackScreenQuizIdentifier = @"Quiz Screen";

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

@end
