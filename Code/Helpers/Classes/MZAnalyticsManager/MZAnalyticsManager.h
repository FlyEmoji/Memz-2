//
//  MZAnalyticsManager.h
//  Memz
//
//  Created by Bastien Falcou on 5/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBingTranslatorCoordinator.h"

typedef NS_ENUM(NSInteger, MZAnalyticsScreen) {
	MZAnalyticsScreenUserEntrance,
	MZAnalyticsScreenWordAddition,
	MZAnalyticsScreenSettings,
	MZAnalyticsScreenStatistics,
	MZAnalyticsScreenQuiz,
	MZAnalyticsScreenArticle
};

@interface MZAnalyticsManager : NSObject

+ (MZAnalyticsManager *)sharedManager;

- (void)setupAnalytics;  // to call in app delegate, configures key and preferences

- (void)trackScreen:(MZAnalyticsScreen)screen;

- (void)trackWordAddition:(NSString *)word
						 translations:(NSArray<NSString *> *)translations
						knownLanguage:(MZLanguage)knownLanguage
							newLanguage:(MZLanguage)newLanguage;

- (void)trackNewQuizUserInitiated:(BOOL)isInitiatedByUser;

- (void)trackArticleWordSuggestionAddition:(BOOL)didAddAll;

@end
