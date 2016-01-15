//
//  MZQuizManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizManager.h"
#import "MZPushNotificationManager.h"

const NSUInteger kDayMinimumQuizNumber = 1;
const NSUInteger kDayMaximumQuizNumber = 5;

const NSUInteger kDefaultQuizPerDay = 3;

const BOOL kDefaultIsReversed = NO;

NSString * const kSettingsIsReversedKey = @"SettingsIsReversedKey";

@interface MZQuizManager ()

@property (nonatomic, weak, readonly) NSArray<NSDate *> *quizTrigerDates;

@property (nonatomic, assign, readonly) NSUInteger startTimeHour;
@property (nonatomic, assign, readonly) NSUInteger stopTimeHour;

@end

@implementation MZQuizManager

+ (MZQuizManager *)sharedManager {
	static MZQuizManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		_quizPerDay = kDefaultQuizPerDay;
	}
	return self;
}

#pragma mark - Public Methods

- (void)startManager {
	_isActive = YES;

	[self scheduleQuizNotifications];
}

- (void)stopManager {
	_isActive = NO;

	[[MZPushNotificationManager sharedManager] cancelLocalNotifications:MZLocalPushNotificationTypeQuizz];
}

- (void)setQuizPerDay:(NSUInteger)quizPerDay {
	if (quizPerDay < kDayMinimumQuizNumber) {
		_quizPerDay = kDayMinimumQuizNumber;
	} else if (quizPerDay > kDayMaximumQuizNumber) {
		_quizPerDay = kDayMaximumQuizNumber;
	} else {
		_quizPerDay = quizPerDay;
	}
}

#pragma mark - Private Methods

- (void)scheduleQuizNotifications {
	[[MZPushNotificationManager sharedManager] cancelLocalNotifications:MZLocalPushNotificationTypeQuizz];

	[self.quizTrigerDates enumerateObjectsUsingBlock:^(NSDate *trigerDate, NSUInteger idx, BOOL *stop) {
		[[MZPushNotificationManager sharedManager] scheduleLocalNotifications:MZLocalPushNotificationTypeQuizz forDate:trigerDate repeat:YES];
	}];
}

#pragma mark - Calculated Properties

- (NSArray<NSDate *> *)quizTrigerDates {
	NSMutableArray<NSDate *> *mutableQuizTrigerDates = [NSMutableArray arrayWithCapacity:self.quizPerDay];
	NSTimeInterval quizTimeInterval = (self.stopTimeHour - self.startTimeHour) * 60.0 * 60.0 / (self.quizPerDay - 1);
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	NSDate *baseDate = [NSDate date];
	NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay)
																								 fromDate:baseDate];
	dateComponents.hour = self.startTimeHour;
	dateComponents.minute = 0;
	baseDate = [calendar dateFromComponents:dateComponents];

	for (NSUInteger quizIndex = 0; quizIndex < self.quizPerDay; quizIndex++) {
		NSTimeInterval additionSeconds = self.quizPerDay > 1 ? quizIndex * quizTimeInterval :
				(self.stopTimeHour - self.startTimeHour) * 60.0 * 60.0 / 2.0;

		NSDateComponents *additionalDayComponents = [[NSDateComponents alloc] init];
		additionalDayComponents.second = additionSeconds;

		NSDate *date = [calendar dateByAddingComponents:additionalDayComponents toDate:baseDate options:0];
		[mutableQuizTrigerDates addObject:date];
	}

	return mutableQuizTrigerDates;
}

- (NSUInteger)startTimeHour {
	return [MZPushNotificationManager sharedManager].startHour;
}

- (NSUInteger)stopTimeHour {
	return [MZPushNotificationManager sharedManager].endHour;
}

#pragma mark - Settings Persistance

- (BOOL)isReversed {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsReversedKey] == nil) {
		self.reversed = kDefaultIsReversed;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsReversedKey] integerValue];
}

- (void)setReversed:(BOOL)reversed {
	[[NSUserDefaults standardUserDefaults] setObject:@(reversed) forKey:kSettingsIsReversedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
