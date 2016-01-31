//
//  MZLanguagesPickerCollectionController.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerCollectionController.h"
#import "MZGradientCollectionViewLayout.h"
#import "MZLanguageCollectionViewCell.h"

#define COMPLETION_IF_NEEDED() \
if (completionHandler) { \
completionHandler(); \
} \

const NSTimeInterval kAppearanceCellsDuration = 0.4;
const NSTimeInterval kDelayAppearanceCells = 0.2;

NSString * const kLanguageCollectionViewCellIdentifier = @"MZLanguageCollectionViewCellIdentifier";

@interface MZLanguagesPickerCollectionController () <UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSString *> *mutableCollectionViewData;
@property (nonatomic, strong) MZGradientCollectionViewLayout *collectionViewLayout;

@property (nonatomic, weak, readonly) NSArray<NSIndexPath *> *indexPathsToInsert;
@property (nonatomic, weak, readonly) NSArray<NSIndexPath *> *indexPathsToRemove;

@end

@implementation MZLanguagesPickerCollectionController

#pragma mark - Public Methods

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
	if (self = [self init]) {
		_collectionView = collectionView;
		_collectionView.dataSource = self;
		_collectionView.delegate = self;

		self.collectionViewLayout = [[MZGradientCollectionViewLayout alloc] init];
		self.collectionViewLayout.appearanceAnimationDuration = kAppearanceCellsDuration;
		self.collectionViewLayout.relativeDelayCellAnimations = kDelayAppearanceCells;
		_collectionView.collectionViewLayout = self.collectionViewLayout;
	}
	return self;
}

+ (instancetype)languageCollectionControllerWithCollectionView:(UICollectionView *)collectionView {
	return [[MZLanguagesPickerCollectionController alloc] initWithCollectionView:collectionView];
}

- (void)reloadData {
	[self reloadDataAnimated:NO completionHandler:nil];
}

- (void)reloadDataAnimated:(BOOL)animated completionHandler:(void (^)(void))completionHandler {
	if (self.isAnimating) {
		COMPLETION_IF_NEEDED();
		return;
	}

	if (!animated) {
		// (2) Update private mutable collection view data with all public collection view data objects
		self.mutableCollectionViewData = self.collectionViewData.mutableCopy;
		[self.collectionView reloadData];

		// (3) Invalidate layout on main queue to ensure the collection view has finished to load and render cells
		// This will initialize the layout right after reload data
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[self.collectionView.collectionViewLayout invalidateLayout];
			COMPLETION_IF_NEEDED();
		});
		return;
	}

	// (2) Take advantage of custom collection layout appearance animation (called upon insertion) to animate reload data
	[self dropAllCellsAnimated:NO completionHandler:^{
		NSTimeInterval savedDelayAnimations = self.collectionViewLayout.relativeDelayCellAnimations;
		self.collectionViewLayout.relativeDelayCellAnimations = kDelayAppearanceCells;

		[self.collectionView performBatchUpdates:^{
			_isAnimating = YES;
			self.mutableCollectionViewData = self.collectionViewData.mutableCopy;
			[self.collectionView insertItemsAtIndexPaths:self.indexPathsToInsert];
		} completion:^(BOOL finished) {
			self.collectionViewLayout.relativeDelayCellAnimations = savedDelayAnimations;
			_isAnimating = !finished;
			COMPLETION_IF_NEEDED();
		}];
	}];
}

- (void)dropAllCellsAnimated:(BOOL)animated completionHandler:(void (^)(void))completionHandler {
	if (self.isAnimating || self.collectionViewData.count == 0) {
		COMPLETION_IF_NEEDED()
		return;
	}

	[self.mutableCollectionViewData removeAllObjects];

	if (!animated) {
		[self.collectionView reloadData];
		dispatch_async(dispatch_get_main_queue(), ^(void){
			COMPLETION_IF_NEEDED();
		});
		return;
	}

	NSTimeInterval savedDelayAnimations = self.collectionViewLayout.relativeDelayCellAnimations;
	self.collectionViewLayout.relativeDelayCellAnimations = kDelayAppearanceCells;

	[self.collectionView performBatchUpdates:^{
		_isAnimating = YES;
		[self.collectionView deleteItemsAtIndexPaths:self.indexPathsToRemove];
	} completion:^(BOOL finished) {
		self.collectionViewLayout.relativeDelayCellAnimations = savedDelayAnimations;
		self.collectionViewData = @[];
		_isAnimating = !finished;
		COMPLETION_IF_NEEDED();
	}];
}

#pragma mark - Calculated Properties

- (NSArray<NSIndexPath *> *)indexPathsToInsert {
	NSMutableArray<NSIndexPath *> *indexPathsToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = [self.collectionView numberOfItemsInSection:0]; i < self.mutableCollectionViewData.count; i++) {
		[indexPathsToInsert addObject:[NSIndexPath indexPathForItem:i inSection:0]];
	}
	return indexPathsToInsert;
}

- (NSArray<NSIndexPath *> *)indexPathsToRemove {
	NSMutableArray<NSIndexPath *> *indexPathsToRemove = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
		[indexPathsToRemove addObject:[NSIndexPath indexPathForItem:i inSection:0]];
	}
	return indexPathsToRemove;
}

#pragma mark - Custom Getters / Setters

- (void)setCollectionViewData:(NSArray<NSString *> *)collectionViewData {
	if (self.isAnimating) {
		return;
	}
	_collectionViewData = collectionViewData;
	self.mutableCollectionViewData = [[NSMutableArray alloc] initWithCapacity:self.collectionViewData.count];
}

#pragma mark - Collection View DataSource & Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.mutableCollectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MZLanguageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLanguageCollectionViewCellIdentifier
																																								 forIndexPath:indexPath];
	cell.backgroundColor = [UIColor redColor];
	return cell;
}

@end
