//
//  NSDate+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 1/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "NSDate+MemzAdditions.h"

@implementation NSDate (MemzAdditions)

- (NSString *)humanReadableDateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	return [dateFormatter stringFromDate:self];
}

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

@end
