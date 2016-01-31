//
//  MZGradientCollectionViewLayout.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZGradientCollectionViewLayout.h"
#import "MZCollectionViewLayoutAttributes.h"

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

@property (nonatomic, strong) NSMutableArray<MZCollectionViewLayoutAttributes *> *attributes;
@property (nonatomic, weak, readonly) MZCollectionViewLayoutAttributes* currentMostCenteredCellAttributes;

@end

@implementation MZGradientCollectionViewLayout

#pragma mark - Class Methods

+ (Class)layoutAttributesClass {
	return [MZCollectionViewLayoutAttributes class];
}

#pragma mark - Initialization

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

	self.attributes = [[NSMutableArray alloc] init];
}

#pragma mark - Custom Setters

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets {
	_sectionInsets = sectionInsets;

	[self invalidateLayout];
}

- (void)setItemsSpacing:(CGFloat)itemsSpacing {
	_itemsSpacing = itemsSpacing;

	[self invalidateLayout];
}

#pragma mark - Calculated Properties and Computations

- (UIEdgeInsets)computeSectionInsets {
	// (1) Calculate top and bottom insets
	CGFloat topInset = self.collectionView.bounds.size.height * kRatioTopInset;
	CGFloat bottomInset = self.collectionView.bounds.size.height * kRatioBottomInset;

	// (2) Calculate horizontal insets
	// Can not call self.itemSize, because this one uses self.sectionInsets to make its own calculation
	CGFloat itemSizeWidth = 0.0f;
	itemSizeWidth += self.collectionView.bounds.size.width / kNumberVisibleItems;
	itemSizeWidth -= self.itemsSpacing * (kNumberVisibleItems - 1) / kNumberVisibleItems;
	itemSizeWidth -= (kLeftInset + kRightInset) / kNumberVisibleItems;

	CGFloat horizontalInset = (self.collectionView.bounds.size.width - itemSizeWidth) / 2.0f;

	return UIEdgeInsetsMake(topInset, horizontalInset, bottomInset, horizontalInset);
}

- (CGSize)computeItemSize {
	CGFloat itemSizeWidth = 0.0f;
	CGFloat itemSizeHeight = 0.0f;

	// (1.1) Width: divided by number of cells
	itemSizeWidth += self.collectionView.bounds.size.width / kNumberVisibleItems;

	// (1.2) Width: substract inter spacing
	itemSizeWidth -= self.itemsSpacing * (kNumberVisibleItems - 1) / kNumberVisibleItems;

	// (1.3) Width: substract edge insets
	itemSizeWidth -= (kLeftInset + kRightInset) / kNumberVisibleItems;

	// (2) Height: substract edge insets
	itemSizeHeight = self.collectionView.bounds.size.height - self.sectionInsets.top - self.sectionInsets.bottom;

	return CGSizeMake(itemSizeWidth, itemSizeHeight);
}

- (CGSize)computeScrollableCellSize {
	CGFloat itemSizeWidth = self.itemSize.width + self.itemsSpacing;
	CGFloat itemSizeHeight = self.itemSize.height;

	return CGSizeMake(itemSizeWidth, itemSizeHeight);
}

- (CGFloat)centerXForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat x = 0.0f;

	// (1) Section left inset
	x += self.sectionInsets.left * (indexPath.section + 1);

	// (2) Section items and their interitem spacing width
	x += self.itemSize.width * (indexPath.item + 1) - (self.itemSize.width / 2.0f);
	x += self.itemsSpacing * indexPath.item;

	// (3) Section right inset
	x += self.sectionInsets.right * indexPath.section;

	return x;
}

- (CGFloat)centerYForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.itemSize.height / 2.0f + self.sectionInsets.top;
}

- (UICollectionViewLayoutAttributes *)currentMostCenteredCellAttributes {
	CGFloat center = self.collectionView.contentOffset.x + self.collectionView.center.x;
	MZCollectionViewLayoutAttributes *mostCenteredCellAttributes = self.attributes.firstObject;

	for (NSInteger i = 1; i < self.attributes.count; i++) {
		MZCollectionViewLayoutAttributes *attribute = self.attributes[i];

		CGFloat attributeBaseDistanceToCenter = fabs(mostCenteredCellAttributes.frame.origin.x
																								 + (mostCenteredCellAttributes.frame.size.width / 2.0f) - center);
		CGFloat attributeComparedDistanceToCenter = fabs(attribute.frame.origin.x
																										 + (attribute.frame.size.width / 2.0f) - center);

		if (attributeComparedDistanceToCenter < attributeBaseDistanceToCenter) {
			mostCenteredCellAttributes = attribute;
		}
	}
	return mostCenteredCellAttributes;
}

#pragma mark - Overridden Collection Layout Methods

- (void)prepareLayout {
	[super prepareLayout];

	// (1) Initialize computed values
	self.sectionInsets = [self computeSectionInsets];
	self.scrollableItemSize = [self computeScrollableCellSize];
	self.itemSize = [self computeItemSize];

	// (2) Compute content size
	CGFloat width, height = 0.0f;

	// (2.1) Width: left inset
	width += self.sectionInsets.left;

	// (2.2) Width: items and their interitem spacing width
	width += self.itemSize.width * [self.collectionView numberOfItemsInSection:0];
	width += self.itemsSpacing * ([self.collectionView numberOfItemsInSection:0] - 1);

	// (2.3) Width: section right inset
	width += self.sectionInsets.right;

	// (2.4) Height
	height = self.collectionView.frame.size.height;

	self.contentSize = CGSizeMake(width, height);

	// (3) Create Attributes
	[self.attributes removeAllObjects];

	for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

		// TODO: User layoutAttributesClass instead, to ensure sublasses will be able to do so as well
		MZCollectionViewLayoutAttributes *attribute = (MZCollectionViewLayoutAttributes *)[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

		CGFloat x = [self centerXForItemAtIndexPath:indexPath];
		CGFloat y = [self centerYForItemAtIndexPath:indexPath];
		attribute.center = CGPointMake(x, y);
		attribute.size = self.itemSize;

		[self.attributes addObject:attribute];
	}
}

- (CGSize)collectionViewContentSize {
	return self.contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSMutableArray<MZCollectionViewLayoutAttributes *> *attributes = [[NSMutableArray alloc] init];

	for (MZCollectionViewLayoutAttributes *attribute in self.attributes) {
		if (CGRectIntersectsRect(attribute.frame, rect)) {
			[attributes addObject:(MZCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:attribute.indexPath]];
		}
	}
	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	MZCollectionViewLayoutAttributes *attributes = [self attributesAtIndexPath:indexPath];

	CGFloat indexTransform = [self indexIncreaseSizeForCellAtIndexPath:attributes.indexPath];
	CGFloat width = self.itemSize.width + kCurrentCellMaximumTransformValue * indexTransform;
	CGFloat height = self.itemSize.height + kCurrentCellMaximumTransformValue * indexTransform;
	attributes.size = CGSizeMake(width, height);

	return attributes;
}

#pragma mark - Overridden Appearance Animation

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
	MZCollectionViewLayoutAttributes *attributes = (MZCollectionViewLayoutAttributes *)[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

	CABasicAnimation *cellAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	cellAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(attributes.center.x, attributes.center.y
	    - (attributes.frame.origin.y + attributes.frame.size.height))];
	cellAnimation.toValue = [NSValue valueWithCGPoint:attributes.center];
	cellAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	cellAnimation.duration = 1.0f;
	attributes.animation = cellAnimation;

	return attributes;
}

#pragma mark - Overridden Pagination Handling

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
	CGFloat currentOffset = self.collectionView.contentOffset.x;
	CGFloat targetOffset = proposedContentOffset.x;
	CGFloat newTargetOffset = 0.0f;
  CGFloat page = 0.0f;

	if (targetOffset == currentOffset) {
		// (1) User releases finger with no scroll velocity (finger not moving).
		// Special behavior based on most centered cell position. Depending on the result of its center.x compared to
		// the center.x of the collection view itself, will decide if need to swipe to the right or to the left.
		CGFloat center = self.collectionView.contentOffset.x + self.collectionView.center.x;

		// (1.1) Research most centered cell attributes
		UICollectionViewLayoutAttributes *mostCenteredCellAttributes = self.currentMostCenteredCellAttributes;

		// (1.2) Calculate destination page according to most centered cell attributes position
		CGFloat mostCenteredCellCenter = mostCenteredCellAttributes.frame.origin.x + mostCenteredCellAttributes.frame.size.width / 2.0f;
		BOOL isDirectionRight = mostCenteredCellCenter < center;
		page = isDirectionRight ? floorf(currentOffset / self.scrollableItemSize.width) : ceilf(currentOffset / self.scrollableItemSize.width);
	} else if (targetOffset > currentOffset) {
		// (2) User releases finger with scroll velocity not null (finger moving).
		// Here calculte destination page that will be on the right.
		page = ceilf(currentOffset / self.scrollableItemSize.width);
	} else {
		// (3) Scroll velocity not null, here going left.
		page = floorf(currentOffset / self.scrollableItemSize.width);
	}

	newTargetOffset = page * self.scrollableItemSize.width;

	if (newTargetOffset < -self.scrollableItemSize.width * 2.0f) {
		newTargetOffset = -self.scrollableItemSize.width * 2.0f;
	} else if (newTargetOffset > self.collectionView.contentSize.width + self.scrollableItemSize.width * 2.0f) {
		newTargetOffset = self.collectionView.contentSize.width + self.scrollableItemSize.width * 2.0f;
	}

	return CGPointMake(newTargetOffset, 0.0f);
}

#pragma mark - Helper

- (CGFloat)indexIncreaseSizeForCellAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	if (!cell) {
		return 0.0f;
	}

	CGRect cellAbsoluteRect = [self.collectionView.superview convertRect:cell.frame fromView:self.collectionView];
	CGFloat distanceFromCenter = fabs(self.collectionView.center.x - (cellAbsoluteRect.origin.x + cellAbsoluteRect.size.width / 2.0f));

	CGFloat maximumDistanceFromBorder = self.collectionView.frame.size.width / 2.0f;
	CGFloat maximumDistanceFromCenter = self.collectionView.frame.size.width / 2.0f + cell.frame.size.width / 2.0f;

	CGFloat ratio = distanceFromCenter / maximumDistanceFromCenter;
	CGFloat distanceFromBorder = maximumDistanceFromBorder * ratio;

	return 1.0f - distanceFromBorder / maximumDistanceFromBorder;
}

- (MZCollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath {
	for (MZCollectionViewLayoutAttributes *attribute in self.attributes) {
		if ([attribute.indexPath isEqual:indexPath]) {
			return attribute;
		}
	}
	return nil;
}

#pragma mark - Invalidate Layout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}

@end