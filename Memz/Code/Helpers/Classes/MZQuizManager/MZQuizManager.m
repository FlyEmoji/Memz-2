//
//  MZQuizManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizManager.h"

@implementation MZQuizManager

+ (MZQuizManager *)sharedManager {
	static MZQuizManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

#pragma mark - Public Methods

- (void)startManager {
	_isActive = YES;
}

- (void)stopManager {
	_isActive = NO;
}

- (MZQuizz *)generateQuiz {
	return nil;
}

#pragma mark - Private Methods

- (void)scheduleQuizNotifications {
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	[dateComps setDay:item.day];
	[dateComps setMonth:item.month];
	[dateComps setYear:item.year];
	[dateComps setHour:item.hour];
	[dateComps setMinute:item.minute];
	NSDate *itemDate = [calendar dateFromComponents:dateComps];
}

@end
