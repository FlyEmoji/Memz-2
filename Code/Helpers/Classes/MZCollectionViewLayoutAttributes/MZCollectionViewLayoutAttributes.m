//
//  MZCollectionViewLayoutAttributes.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZCollectionViewLayoutAttributes.h"

@implementation MZCollectionViewLayoutAttributes

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone {
	MZCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
	attributes.animation = self.animation;
	return attributes;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
	BOOL isEqual = [super isEqual:object];

	if (isEqual && object == self) {
		return YES;
	}

	if (isEqual && (!object || ![[object class] isEqual:[self class]])) {
		return NO;
	}

	if (isEqual && [[object safeCastToClass:[self class]] animation] != self.animation) {
		return NO;
	}

	return isEqual;
}

@end
