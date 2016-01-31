//
//  MZLanguageCollectionViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguageCollectionViewCell.h"
#import "MZCollectionViewLayoutAttributes.h"

NSString * const kAnimationKey = @"MZLanguageCollectionViewCellAnimationKey";

@implementation MZLanguageCollectionViewCell

#pragma mark - Animation

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	MZCollectionViewLayoutAttributes *attributes = [layoutAttributes safeCastToClass:[MZCollectionViewLayoutAttributes class]];
	[[self layer] addAnimation:attributes.animation forKey:kAnimationKey];
}

@end
