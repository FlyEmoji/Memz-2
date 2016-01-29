//
//  MZGradientCollectionViewLayout.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZGradientCollectionViewLayout.h"

const NSUInteger kNumberVisibleItems = 1;

const CGFloat kLeftInset = 50.0f;
const CGFloat kRightInset = 50.0f;

const CGFloat kRatioTopInset = 0.1f;
const CGFloat kRatioBottomInset = 0.1f;

const CGFloat kDefaultItemsSpacing = 32.0f;
const CGFloat kCurrentCellMaximumTransformValue = 20.0f;

@interface MZGradientCollectionViewLayout ()

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize scrollableItemSize;

@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@property (nonatomic, assign) CGFloat itemsSpacing;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributes;

@end

@implementation MZGradientCollectionViewLayout

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.contentSize = CGSizeZero;
	self.itemSize = CGSizeZero;
	self.scrollableItemSize = CGSizeZero;

	self.sectionInsets = UIEdgeInsetsZero;
	self.itemsSpacing = kDefaultItemsSpacing;
}

#pragma mark - Custom Getters / Setters

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets {
	_sectionInsets = sectionInsets;

	[self invalidateLayout];
}

- (void)setItemsSpacing:(CGFloat)itemsSpacing {
	_itemsSpacing = itemsSpacing;

	[self invalidateLayout];
}

@end