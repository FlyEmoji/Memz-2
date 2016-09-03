//
//  MZNSUUIDToNSDataValueTransformer.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNSUUIDToNSDataValueTransformer.h"

@implementation MZNSUUIDToNSDataValueTransformer

+ (Class)transformedValueClass {
	return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	NSUUID *uuidValue = [value safeCastToClass:[NSUUID class]];
	if (!uuidValue) {
		return nil;
	}

	uuid_t uuid;
	[uuidValue getUUIDBytes:uuid];

	return [NSData dataWithBytes:uuid length:16];
}

- (id)reverseTransformedValue:(id)value {
	NSData *data = [value safeCastToClass:[NSData class]];

	return [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
}

@end
