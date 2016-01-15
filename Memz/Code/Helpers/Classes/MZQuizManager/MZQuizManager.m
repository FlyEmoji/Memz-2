//
//  MZQuizManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizManager.h"
#import "MZPushNotificationManager.h"

const NSUInteger kDefaultQuizPerDay = 3;

const NSUInteger kDefaultStartTimeHour = 8;
const NSUInteger kDefaultEndTimeHour = 20;

const BOOL kDefaultIsActive = YES;
const BOOL kDefaultIsReversed = NO;

NSString * const kSettingsIsActiveKey = @"SettingsIsActiveKey";
NSString * const kSettingsStartHourKey = @"SettingsStartHourKey";
NSString * const kSettingsEndHourHey = @"SettingsEndHourHey";
NSString * const kSettingsIsReversedKey = @"SettingsIsReversedKey";

@interface MZQuizManager ()

@property (nonatomic, weak, readonly) NSArray<NSDate *> *quizTrigerDates;

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

- (void)scheduleQuizNotifications {
	if (!self.isActive) {
		return;
	}

	[[MZPushNotificationManager sharedManager] cancelLocalNotifications:MZLocalPushNotificationTypeQuizz];

	[self.quizTrigerDates enumerateObjectsUsingBlock:^(NSDate *trigerDate, NSUInteger idx, BOOL *stop) {
		[[MZPushNotificationManager sharedManager] scheduleLocalNotifications:MZLocalPushNotificationTypeQuizz forDate:trigerDate repeat:YES];
	}];
}

- (void)cancelQuizNotifications {
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

	[self scheduleQuizNotifications];
}

#pragma mark - Calculated Properties

- (NSArray<NSDate *> *)quizTrigerDates {
	NSMutableArray<NSDate *> *mutableQuizTrigerDates = [NSMutableArray arrayWithCapacity:self.quizPerDay];
	NSTimeInterval quizTimeInterval = (self.endHour - self.startHour) * 60.0 * 60.0 / (self.quizPerDay - 1);
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	NSDate *baseDate = [NSDate date];
	NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay)
																								 fromDate:baseDate];
	dateComponents.hour = self.startHour;
	dateComponents.minute = 0;
	baseDate = [calendar dateFromComponents:dateComponents];

	for (NSUInteger quizIndex = 0; quizIndex < self.quizPerDay; quizIndex++) {
		NSTimeInterval additionSeconds = self.quizPerDay > 1 ? quizIndex * quizTimeInterval :
				(self.endHour - self.startHour) * 60.0 * 60.0 / 2.0;

		NSDateComponents *additionalDayComponents = [[NSDateComponents alloc] init];
		additionalDayComponents.second = additionSeconds;

		NSDate *date = [calendar dateByAddingComponents:additionalDayComponents toDate:baseDate options:0];
		[mutableQuizTrigerDates addObject:date];
	}

	return mutableQuizTrigerDates;
}

#pragma mark - Settings Persistance

- (BOOL)isActive {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsActiveKey] == nil) {
		self.startHour = kDefaultIsActive;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIsActiveKey] integerValue];
}

- (void)setActive:(BOOL)active {
	[[NSUserDefaults standardUserDefaults] setObject:@(active) forKey:kSettingsIsActiveKey];
	[[NSUserDefaults standardUserDefaults] synchronize];

	if (active) {
		[self scheduleQuizNotifications];
	} else {
		[self cancelQuizNotifications];
	}
}

- (NSUInteger)startHour {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsStartHourKey] == nil) {
		self.startHour = kDefaultStartTimeHour;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsStartHourKey] integerValue];
}

- (void)setStartHour:(NSUInteger)startHour {
	[[NSUserDefaults standardUserDefaults] setObject:@(startHour) forKey:kSettingsStartHourKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)endHour {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kSettingsEndHourHey] == nil) {
		self.endHour = kDefaultEndTimeHour;
	}

	return [[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsEndHourHey] integerValue];
}

- (void)setEndHour:(NSUInteger)endHour {
	[[NSUserDefaults standardUserDefaults] setObject:@(MIN(endHour, 24)) forKey:kSettingsEndHourHey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

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
