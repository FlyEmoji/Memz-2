//
//  NSDate+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 1/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MemzAdditions)			// TODO: Write documentation and examples

- (NSString *)humanReadableDateString;
- (NSString *)time;
- (NSInteger)hour;
- (NSInteger)minute;

- (NSDate *)beginningDayDate;
- (NSDate *)endDayDate;

- (NSDate *)dayForDaysInThePast:(NSUInteger)daysInPast;
- (NSDate *)dayBefore;
- (NSDate *)dayForDaysInTheFuture:(NSInteger)daysAfter;
- (NSDate *)dayAfter;
- (NSDate *)hoursBefore:(NSInteger)hoursBefore;

- (BOOL)isLaterToday;
- (BOOL)isSameDay:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isTomorrowOrLater;
- (BOOL)isBeforeDate:(NSDate *)date;
- (BOOL)isBeforeNow;

@end
