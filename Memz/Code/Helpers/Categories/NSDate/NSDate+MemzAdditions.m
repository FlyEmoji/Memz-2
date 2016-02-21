//
//  NSDate+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 1/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "NSDate+MemzAdditions.h"

@implementation NSDate (MemzAdditions)

#pragma mark - String Formatting

- (NSString *)humanReadableDateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	return [dateFormatter stringFromDate:self];
}

- (NSString *)time {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setDateFormat:@"hh:mma"];
	return [formatter stringFromDate:self];
}

- (NSInteger)hour {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
	return [components hour];
}

- (NSInteger)minute {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
	return [components minute];
}

#pragma mark - Operations Within Current Day

- (NSDate *)beginningDayDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self];
	components.hour = 0;
	components.minute = 0;
	return [calendar dateFromComponents:components];
}

- (NSDate *)endDayDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
	components.day = 1;
	return [calendar dateByAddingComponents:components toDate:[self beginningDayDate] options:0];
}

#pragma mark - Operations Different Days

- (NSDate *)dayForDaysInThePast:(NSUInteger)daysInPast {
	NSDate *dateBeforeDays = [self dateByAddingTimeInterval:-60 * 60 * 24 * daysInPast];
	return dateBeforeDays;
}

- (NSDate *)dayBefore {
	return [self dayForDaysInThePast:1];
}

- (NSDate *)dayForDaysInTheFuture:(NSInteger)daysAfter {
	NSDate *dateAfterDays = [self dateByAddingTimeInterval:60 * 60 * 24 * daysAfter];
	return dateAfterDays;
}

- (NSDate *)dayAfter {
	return [self dayForDaysInTheFuture:1];
}

- (NSDate *)hoursBefore:(NSInteger)hoursBefore {
	NSDate *dateBeforeDays = [self dateByAddingTimeInterval:-60 * 60 * hoursBefore];
	return dateBeforeDays;
}

- (BOOL)isLaterToday {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *selectedDateComponents = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self];
	NSDateComponents *currentDateComponents = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:[NSDate date]];

	return [self isToday] && (selectedDateComponents.hour < currentDateComponents.hour
															 || (selectedDateComponents.hour == currentDateComponents.hour
																	 && selectedDateComponents.minute < currentDateComponents.minute));
}

- (BOOL)isSameDay:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components1 = [calendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
	NSDateComponents *components2 = [calendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:self];

	return (([components1 year] == [components2 year]) &&
					([components1 month] == [components2 month]) &&
					([components1 day] == [components2 day]));
}

- (BOOL)isToday {
	return [self isSameDay:[NSDate date]];
}

- (BOOL)isTomorrow {
	NSDate *tomorrow = [NSDate dateWithTimeInterval:(24 * 60 * 60) sinceDate:[NSDate date]];
	NSUInteger tomorrowDayOfYear = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:tomorrow];
	NSUInteger dateDayOfYear = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
	return tomorrowDayOfYear == dateDayOfYear;
}

- (BOOL)isTomorrowOrLater {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *selectedDateComponents = [calendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitEra) fromDate:self];
	NSDateComponents *currentDateComponents = [calendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitEra) fromDate:[NSDate date]];

	return (selectedDateComponents.day > currentDateComponents.day
					|| selectedDateComponents.month > currentDateComponents.month
					|| selectedDateComponents.year > currentDateComponents.year);
}

- (BOOL)isBeforeDate:(NSDate *)date {
	if ([self isToday]) {
		return NO;
	}

	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];

	NSDateComponents *currentDateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];

	return (currentDateComponents.day >= components.day
					&& currentDateComponents.month >= components.month
					&& currentDateComponents.year >= components.year);
}

- (BOOL)isBeforeNow {
	return [self isBeforeDate:[NSDate date]];
}

@end
