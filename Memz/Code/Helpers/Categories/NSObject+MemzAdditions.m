//
//  NSObject+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "NSObject+MemzAdditions.h"

@implementation NSObject (MemzAdditions)

- (id)safeCastToClass:(__unsafe_unretained Class)classType {
	if ([self isKindOfClass:classType]) {
		return self;
	} else {
		return nil;
	}
}

@end
