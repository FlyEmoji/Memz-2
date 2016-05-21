//
//  MZQuizManagerTest.m
//  Memz
//
//  Created by Bastien Falcou on 5/21/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZQuizManager.h"
#import "MZApplicationSessionManager.h"
#import "MZPushNotificationManager.h"

@interface MZApplicationSessionManager (PrivateTests)

@property (nonatomic, strong, readwrite) NSDate *lastClosedDate;

@end

@interface MZQuizManager (PrivateTests)

- (NSArray<NSDate *> *)quizTriggerDates;

@end

@interface MZQuizManagerTest: XCTestCase

@end

@implementation MZQuizManagerTest

#pragma mark - Quiz Trigger Dates

- (void)testQuizTriggerDatesRegularNumberResult {
	[MZQuizManager sharedManager].quizPerDay = round(kDayMaximumQuizNumber / 2);

	XCTAssertEqual([MZQuizManager sharedManager].quizTriggerDates.count, round(kDayMaximumQuizNumber / 2));
}

- (void)testQuizTriggerDatesExceedNumberResult {
	[MZQuizManager sharedManager].quizPerDay = kDayMaximumQuizNumber + 5;

	XCTAssertEqual([MZQuizManager sharedManager].quizTriggerDates.count, kDayMaximumQuizNumber);
}

- (void)testQuizTriggerDatesFirst {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].startHour = 10;

	NSDate *firstDate = [MZQuizManager sharedManager].quizTriggerDates.firstObject;
	NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:firstDate];

	XCTAssertEqual(components.hour, 10);
}

- (void)testQuizTriggerDatesLast {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].endHour = 17;

	NSDate *lastDate = [MZQuizManager sharedManager].quizTriggerDates.lastObject;
	NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:lastDate];

	XCTAssertEqual(components.hour, 17);
}

- (void)testQuizTriggerDatesMiddle {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].startHour = 10;
	[MZQuizManager sharedManager].endHour = 14;
	[MZQuizManager sharedManager].quizPerDay = 3;

	NSDate *middleDate = [MZQuizManager sharedManager].quizTriggerDates[1];
	NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:middleDate];

	XCTAssertEqual(components.hour, 12);
}

- (void)testQuizTriggerDatesOneOnly {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].startHour = 10;
	[MZQuizManager sharedManager].endHour = 14;
	[MZQuizManager sharedManager].quizPerDay = 1;

	NSDate *onlyDate = [MZQuizManager sharedManager].quizTriggerDates.firstObject;
	NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:onlyDate];

	XCTAssertEqual(components.hour, 12);
}

#pragma mark - Dates Missed Quizzes

- (void)testDatesMissedQuizzesWholeDays {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].quizPerDay = 2;

	// Last app session closed exactly two days ago
	NSDateComponents *closedDateComponents = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
	closedDateComponents.day = -2;
	NSDate *closedDate = [calendar dateByAddingComponents:closedDateComponents toDate:[NSDate date] options:0];

	[MZApplicationSessionManager sharedManager].lastClosedDate = closedDate;

	XCTAssertEqual([MZQuizManager sharedManager].datesMissedQuizzes.count, 4);
}

- (void)testDatesMissedQuizzesToday {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitHour fromDate:[NSDate date]];

	[MZQuizManager sharedManager].startHour = 0;
	[MZQuizManager sharedManager].endHour = currentDateComponents.hour;
	[MZQuizManager sharedManager].quizPerDay = kDayMaximumQuizNumber;

	// Last app session closed today at midnight
	NSDateComponents *closedDateComponents = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:[NSDate date]];
	closedDateComponents.hour = 0;
	closedDateComponents.minute = 0;
	NSDate *closedDate = [calendar dateByAddingComponents:closedDateComponents toDate:[NSDate date] options:0];

	[MZApplicationSessionManager sharedManager].lastClosedDate = closedDate;

	XCTAssertEqual([MZQuizManager sharedManager].datesMissedQuizzes.count, kDayMaximumQuizNumber);
}

- (void)testDatesMissedQuizzesHour {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	[MZQuizManager sharedManager].startHour = 10;
	[MZQuizManager sharedManager].endHour = 20;
	[MZQuizManager sharedManager].quizPerDay = 1;

	// Last app session closed a few days ago, day doesn't import much here as long as it is not same as current day
	NSDateComponents *closedDateComponents = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
	closedDateComponents.day = -5;
	NSDate *closedDate = [calendar dateByAddingComponents:closedDateComponents toDate:[NSDate date] options:0];

	[MZApplicationSessionManager sharedManager].lastClosedDate = closedDate;

	NSDate *firstDate = [MZQuizManager sharedManager].datesMissedQuizzes.firstObject;
	NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:firstDate];

	XCTAssertEqual(components.hour, 15);
}

- (void)testDatesMissedQuizzesFutureLastAppSessionDate {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

	// Invalid last app session in the future
	NSDateComponents *closedDateComponents = [calendar components:(NSCalendarUnitDay) fromDate:[NSDate date]];
	closedDateComponents.day = 5;
	NSDate *closedDate = [calendar dateByAddingComponents:closedDateComponents toDate:[NSDate date] options:0];

	[MZApplicationSessionManager sharedManager].lastClosedDate = closedDate;

	XCTAssertEqual([MZQuizManager sharedManager].datesMissedQuizzes.count, 0);
}

#pragma mark - Schedule Quiz Notifications

- (void)testCancelQuizNotifications {
	NSInteger beforeLocalNotificationsCount = [UIApplication sharedApplication].scheduledLocalNotifications.count;

	[MZQuizManager sharedManager].quizPerDay = kDayMaximumQuizNumber;
	[[MZQuizManager sharedManager] scheduleQuizNotifications];

	[[MZQuizManager sharedManager] cancelQuizNotifications];

	XCTAssertEqual([UIApplication sharedApplication].scheduledLocalNotifications.count, beforeLocalNotificationsCount);
}

- (void)testScheduleQuizNotificationsIsActive {
	NSInteger beforeLocalNotificationsCount = [UIApplication sharedApplication].scheduledLocalNotifications.count;

	[MZQuizManager sharedManager].active = YES;
	[MZQuizManager sharedManager].quizPerDay = kDayMaximumQuizNumber;

	[[MZQuizManager sharedManager] scheduleQuizNotifications];

	dispatch_async(dispatch_get_main_queue(), ^(void){
		XCTAssertEqual([UIApplication sharedApplication].scheduledLocalNotifications.count,
									 beforeLocalNotificationsCount + kDayMaximumQuizNumber);
	});
}

- (void)testScheduleQuizNotificationsIsInactive {
	NSInteger beforeLocalNotificationsCount = [UIApplication sharedApplication].scheduledLocalNotifications.count;

	[MZQuizManager sharedManager].active = NO;
	[MZQuizManager sharedManager].quizPerDay = kDayMaximumQuizNumber;

	[[MZQuizManager sharedManager] scheduleQuizNotifications];

	dispatch_async(dispatch_get_main_queue(), ^(void){
		XCTAssertEqual([UIApplication sharedApplication].scheduledLocalNotifications.count, beforeLocalNotificationsCount);
	});
}

@end