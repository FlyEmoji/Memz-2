//
//  MZNSRULToNSDataValueTransformer.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNSRULToNSDataValueTransformer.h"

@implementation MZNSRULToNSDataValueTransformer

+ (Class)transformedValueClass {
	return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	NSURL *urlValue = [value safeCastToClass:[NSURL class]];
	if (!urlValue) {
		return nil;
	}

	return [urlValue.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)reverseTransformedValue:(id)value {
	NSData *data = [value safeCastToClass:[NSData class]];
	NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	return [[NSURL alloc] initWithString:urlString];
}

@end
