//
//  NSDate+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 1/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MemzAdditions)			// TODO: Write documentation and examples

- (NSString *)relativeOrAbsoluteDateString;  // Yesterday, 2 days ago, last week .. humanReadableDateString
- (NSString *)humanReadableDateString;  // MMM d, y, h:mm a
- (NSString *)weekDay;  // uppercased first letter of the day
- (NSString *)month;  // MMM
- (NSInteger)day;  // d
- (NSString *)time;	 // h:mm a
- (NSInteger)hour;  // h
- (NSInteger)minute;  // mm

- (NSDate *)beginningDayDate;
- (NSDate *)endDayDate;

- (NSDate *)dayForDaysInThePast:(NSUInteger)daysInPast;
- (NSDate *)dayBefore;
- (NSDate *)dayForDaysInTheFuture:(NSInteger)daysAfter;
- (NSDate *)dayAfter;
- (NSDate *)hoursBefore:(NSInteger)hoursBefore;

- (NSInteger)numberDaysDifferenceWithDate:(NSDate *)date;

- (BOOL)isBeforeDate:(NSDate *)date;
- (BOOL)isBeforeNow;
- (BOOL)isSameDay:(NSDate *)date;

- (BOOL)isYesterday;
- (BOOL)isToday;
- (BOOL)isLaterToday;
- (BOOL)isTomorrow;
- (BOOL)isTomorrowOrLater;

@end
