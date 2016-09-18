//
//  NSDate+MemzAdditionsTest.m
//  Memz
//
//  Created by Bastien Falcou on 9/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSDate+MemzAdditions.h"

@interface NSDateMemzAdditionsTest : XCTestCase

@property (nonatomic, strong) NSDate *globalTestsDate;

@end

@implementation NSDateMemzAdditionsTest

- (void)setUp {
	[super setUp];
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.year = 2010;
	dateComponents.month = 5;
	dateComponents.day = 12;
	dateComponents.hour = 6;
	dateComponents.minute = 25;
	dateComponents.weekday = 1;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	self.globalTestsDate = [calendar dateFromComponents:dateComponents];
}

#pragma mark - Granular Accessors

- (void)testMonth {
	XCTAssertTrue([[self.globalTestsDate month].uppercaseString isEqualToString:@"MAY"]);
}

- (void)testDay {
	XCTAssertEqual([self.globalTestsDate day], 12);
}

- (void)testHour {
	XCTAssertEqual([self.globalTestsDate hour], 6);
}

- (void)testMinute {
	XCTAssertEqual([self.globalTestsDate minute], 25);
}

- (void)testTime {
	XCTAssertTrue([[self.globalTestsDate time].uppercaseString isEqualToString:@"6:25AM"]);
}

- (void)testWeekday {
	XCTAssertTrue([[self.globalTestsDate weekDay].uppercaseString isEqualToString:@"W"]);
}

#pragma mark - Day for days in the past 

- (void)testDayForDaysInThePastRightYesterday {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayForDaysInThePast:1];
	NSDate *yesterdayDateVerification = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];

	XCTAssertTrue([yesterdayDate isSameDay:yesterdayDateVerification]);
}

- (void)testDayForDaysInThePastRightFarther {
	NSDate *todayDate = [NSDate date];
	NSDate *beofreDate = [todayDate dayForDaysInThePast:10];
	NSDate *beforeDateVerification = [todayDate dateByAddingTimeInterval:-10.0 * 24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([beofreDate isSameDay:beforeDateVerification]);
}

- (void)testDayForDaysInThePastRightFuture {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dayForDaysInThePast:-1];
	NSDate *tomorrowDateVerification = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([tomorrowDate isSameDay:tomorrowDateVerification]);
}

#pragma mark - Day Before

- (void)testDayBeforeRight {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayBefore];
	NSDate *yesterdayDateVerification = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([yesterdayDate isSameDay:yesterdayDateVerification]);
}

- (void)testDayBeforeRightAdditional {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayBefore];
	NSDate *yesterdayDateVerification = [todayDate dayForDaysInThePast:1];
	
	XCTAssertTrue([yesterdayDate isSameDay:yesterdayDateVerification]);
}

- (void)testDayBeforeWrong {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayBefore];
	
	XCTAssertTrue(![todayDate isSameDay:yesterdayDate]);
}

#pragma mark - Day For Days in the Future

- (void)testDayForDaysInTheFutureRightTomorrow {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dayForDaysInTheFuture:1];
	NSDate *tomorrowDateVerification = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([tomorrowDate isSameDay:tomorrowDateVerification]);
}

- (void)testDayForDaysInThePastRightLater {
	NSDate *todayDate = [NSDate date];
	NSDate *laterDate = [todayDate dayForDaysInTheFuture:10];
	NSDate *laterDateVerification = [todayDate dateByAddingTimeInterval:10.0 * 24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([laterDate isSameDay:laterDateVerification]);
}

- (void)testDayForDaysInThePastRightPast {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayForDaysInTheFuture:-1];
	NSDate *yesterdayDateVerification = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([yesterdayDate isSameDay:yesterdayDateVerification]);
}

#pragma mark - Day After

- (void)testDayAfterRight {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dayAfter];
	NSDate *tomorrowDateVerification = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([tomorrowDate isSameDay:tomorrowDateVerification]);
}

- (void)testDayAfterRightAdditional {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dayAfter];
	NSDate *tomorrowDateVerification = [todayDate dayForDaysInTheFuture:1];
	
	XCTAssertTrue([tomorrowDate isSameDay:tomorrowDateVerification]);
}

- (void)testDayAfterWrong {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dayAfter];
	
	XCTAssertTrue(![todayDate isSameDay:yesterdayDate]);
}

#pragma mark - Is Before Date

- (void)testIsBeforeDateRight {
	NSDate *todayDate = [NSDate date];
	NSDate *beforeDate = [todayDate dateByAddingTimeInterval:-1.0];
	
	XCTAssertTrue([beforeDate isBeforeDate:todayDate]);
}

- (void)testIsBeforeDateWrongEqual {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isBeforeDate:todayDate]);
}

- (void)testIsBeforeDateWrongFuture {
	NSDate *todayDate = [NSDate date];
	NSDate *afterDate = [todayDate dateByAddingTimeInterval:1.0];
	
	XCTAssertTrue(![afterDate isBeforeDate:todayDate]);
}

#pragma mark - Is Before Now

- (void)testIsBeforeNowRight {
	NSDate *todayDate = [NSDate date];
	NSDate *beforeDate = [todayDate dateByAddingTimeInterval:-1.0];
	
	XCTAssertTrue([beforeDate isBeforeNow]);
}

- (void)testIsBeforeNowWrongEqual {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isBeforeNow]);
}

- (void)testIsBeforeNowWrongFuture {
	NSDate *todayDate = [NSDate date];
	NSDate *afterDate = [todayDate dateByAddingTimeInterval:1.0];
	
	XCTAssertTrue(![afterDate isBeforeNow]);
}

#pragma mark - Hours Before

- (void)testHoursBeforeRight {
	NSDate *todayDate = [NSDate date];
	NSDate *beforeDate = [todayDate hoursBefore:8.0];
	NSDate *beforeDateVerification = [todayDate dateByAddingTimeInterval:-8.0 * 60.0 * 60.0];
	
	XCTAssertTrue([beforeDate isEqualToDate:beforeDateVerification]);
}

- (void)testHoursBeforeWrong {
	NSDate *todayDate = [NSDate date];
	NSDate *beforeDate = [todayDate hoursBefore:7.0];
	NSDate *beforeDateVerification = [todayDate dateByAddingTimeInterval:-8.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![beforeDate isEqualToDate:beforeDateVerification]);
}

#pragma mark - Is Same Day

- (void)testIsSameDayRightNow {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue([todayDate isSameDay:todayDate]);
}

- (void)testIsSameDayRightTonight {
	NSDate *todayDate = [NSDate date];
	NSDate *endDayDate = [todayDate endDayDate];
	
	XCTAssertTrue([todayDate isSameDay:endDayDate]);
}

- (void)testIsSameDayRightMorning {
	NSDate *todayDate = [NSDate date];
	NSDate *beginningDayDate = [todayDate beginningDayDate];
	
	XCTAssertTrue([todayDate isSameDay:beginningDayDate]);
}

- (void)testIsSameDayWrongTomorrow {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];

	XCTAssertTrue(![todayDate isSameDay: tomorrowDate]);
}

- (void)testIsSameDayWrongYesterday {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![todayDate isSameDay: yesterdayDate]);
}

#pragma mark - Is Yesterday

- (void)testIsYesterdayRight {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([yesterdayDate isYesterday]);
}

- (void)testIsYesterdayWrongBefore {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-2.0 * 24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![yesterdayDate isYesterday]);
}

- (void)testIsYesterdayWrongSameDate {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isYesterday]);
}

#pragma mark - Is Today

- (void)testIsTodayRight {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue([todayDate isToday]);
}

- (void)testIsTodayBeginningDayDate {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue([[todayDate beginningDayDate] isToday]);
}

- (void)testIsTodayEndDayDate {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue([[todayDate endDayDate] isToday]);
}

- (void)testIsTodayWrongPast {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![yesterdayDate isToday]);
}

- (void)testIsTodayWrongFuture {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![tomorrowDate isToday]);
}

#pragma mark - Day Is Later Today

- (void)testIsLaterTodayRight {
	NSDate *todayDate = [NSDate date];
	NSDate *laterDate = [todayDate dateByAddingTimeInterval:1.0];
	
	XCTAssertTrue([laterDate isLaterToday]);
}

- (void)testIsLaterTodayWrongPast {
	NSDate *todayDate = [NSDate date];
	NSDate *earlierDate = [todayDate dateByAddingTimeInterval:-1.0];
	
	XCTAssertTrue(![earlierDate isLaterToday]);
}

- (void)testIsLaterTodayWrongEqual {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isLaterToday]);
}

- (void)testIsLaterTodayWrongTomorrow {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![tomorrowDate isLaterToday]);
}

#pragma mark - Is Tomorrow

- (void)testIsTomorrowRight {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([tomorrowDate isTomorrow]);
}

- (void)testIsTomorrowWrongTooFar {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:2.0 * 24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![tomorrowDate isTomorrow]);
}

- (void)testIsTomorrowWrongBefore {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![yesterdayDate isTomorrow]);
}

- (void)testIsTomorrowWrongSameDate {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isTomorrow]);
}

#pragma mark - Is Tomorrow or Later

- (void)testIsTomorrowOrLaterRightTomorrow {
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([tomorrowDate isTomorrowOrLater]);
}

- (void)testIsTomorrowOrLaterRightLater {
	NSDate *todayDate = [NSDate date];
	NSDate *laterDate = [todayDate dateByAddingTimeInterval:2.0 * 24.0 * 60.0 * 60.0];
	
	XCTAssertTrue([laterDate isTomorrowOrLater]);
}

- (void)testIsTomorrowOrLaterWrongBefore {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	
	XCTAssertTrue(![yesterdayDate isTomorrowOrLater]);
}

- (void)testIsTomorrowOrLaterWrongSameDate {
	NSDate *todayDate = [NSDate date];
	
	XCTAssertTrue(![todayDate isTomorrowOrLater]);
}

#pragma mark - Days Difference

- (void)testNumberDaysDifferencesWithDateZero {
	NSDate *todayDate = [NSDate date];
	NSInteger numberDaysDifference = [todayDate numberDaysDifferenceWithDate:todayDate];
	
	XCTAssertTrue(numberDaysDifference == 0);
}

- (void)testNumberDaysDifferencesWithDateOne {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-24.0 * 60.0 * 60.0];
	NSInteger numberDaysDifference = [todayDate numberDaysDifferenceWithDate:yesterdayDate];
	
	XCTAssertTrue(numberDaysDifference == -1);
}

- (void)testNumberDaysDifferencesWithDateTen {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:-10.0 * 24.0 * 60.0 * 60.0];
	NSInteger numberDaysDifference = [todayDate numberDaysDifferenceWithDate:yesterdayDate];
	
	XCTAssertTrue(numberDaysDifference == -10);
}

- (void)testNumberDaysDifferencesWithDateFuture {
	NSDate *todayDate = [NSDate date];
	NSDate *yesterdayDate = [todayDate dateByAddingTimeInterval:10.0 * 24.0 * 60.0 * 60.0];
	NSInteger numberDaysDifference = [todayDate numberDaysDifferenceWithDate:yesterdayDate];
	
	XCTAssertTrue(numberDaysDifference == 10);
}

@end