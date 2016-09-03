//
//  NSArray+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 5/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "NSArray+MemzAdditions.h"

@implementation NSArray (MemzAdditions)

- (NSArray<NSString *> *)allLowercaseStrings {
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];

	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[NSString class]]) {
			[mutableArray addObject:[obj lowercaseString]];
		}
	}];

	return mutableArray;
}

+ (NSArray<NSString *> *)removeDuplicatesCaseInsensitiveWithArray:(NSArray<NSString *> *)array {
	NSSet *uniquitySet = [NSSet setWithArray:[array allLowercaseStrings]];
	return uniquitySet.allObjects;
}

@end
