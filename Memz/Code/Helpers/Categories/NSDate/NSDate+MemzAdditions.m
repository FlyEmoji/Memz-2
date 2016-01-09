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
	//[dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
	return [dateFormatter stringFromDate:self];
}

@end
