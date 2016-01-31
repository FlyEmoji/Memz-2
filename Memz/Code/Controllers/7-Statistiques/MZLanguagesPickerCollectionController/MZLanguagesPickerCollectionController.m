//
//  MZLanguagesPickerCollectionController.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerCollectionController.h"
#import "MZLanguageCollectionViewCell.h"

#define COMPLETION_IF_NEEDED() \
if (completionHandler) { \
completionHandler(); \
} \

const NSTimeInterval kDelayAppearanceCells = 0.25;

NSString * const kLanguageCollectionViewCellIdentifier = @"MZLanguageCollectionViewCellIdentifier";

@interface MZLanguagesPickerCollectionController () <UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSString *> *mutableCollectionViewData;
@property (nonatomic, weak, readonly) NSArray<NSIndexPath *> *allIndexPaths;

@end

@implementation MZLanguagesPickerCollectionController

#pragma mark - Public Methods

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
	if (self = [self init]) {
		_collectionView = collectionView;
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
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
		// (1) Update private mutable collection view data with all public collection view data objects
		self.mutableCollectionViewData = self.collectionViewData.mutableCopy;
		[self.collectionView reloadData];

		// (2) Invalidate layout on main queue to ensure the collection view has finished to load and render cells
		// This will initialize the layout right after reload data
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[self.collectionView.collectionViewLayout invalidateLayout];
			COMPLETION_IF_NEEDED();
		});
		return;
	}

	// (1) If animating, will take advantage of collection view custom layout animations on insert/remove adding cell by cell
	[self removeAllCellsAnimated:NO completionHandler:^{
		[self.collectionView performBatchUpdates:^{
			_isAnimating = YES;

			for (NSUInteger i = 0; i < self.collectionViewData.count; i++) {
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * kDelayAppearanceCells * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					[self.mutableCollectionViewData addObject:self.collectionViewData[i]];
					[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
				});
			}
		} completion:^(BOOL finished) {
			if ([self.mutableCollectionViewData isEqualToArray:self.collectionViewData] && finished) {
				_isAnimating = !finished;
				COMPLETION_IF_NEEDED();
			}
		}];
	}];
}

- (void)removeAllCellsAnimated:(BOOL)animated completionHandler:(void (^)(void))completionHandler {
	if (self.isAnimating || self.collectionViewData.count == 0) {
		COMPLETION_IF_NEEDED()
		return;
	}

	if (!animated) {
		[self.mutableCollectionViewData removeAllObjects];
		[self.collectionView reloadData];
		dispatch_async(dispatch_get_main_queue(), ^(void){
			COMPLETION_IF_NEEDED();
		});
		return;
	}

	for (NSUInteger i = 0; i < self.collectionViewData.count; i++) {
		[self.collectionView performBatchUpdates:^{
			_isAnimating = YES;

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * kDelayAppearanceCells * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self.mutableCollectionViewData removeObject:self.collectionViewData[i]];
				[self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
			});
		} completion:^(BOOL finished) {
			if ([self.mutableCollectionViewData isEqualToArray:self.collectionViewData] && finished) {
				_isAnimating = !finished;
				COMPLETION_IF_NEEDED();
			}
		}];
	}
}

#pragma mark - Helpers

- (NSArray<NSIndexPath *> *)allIndexPaths {
	NSMutableArray<NSIndexPath *> *allIndexPaths = [[NSMutableArray alloc] initWithCapacity:[self.collectionView numberOfItemsInSection:0]];
	for (NSUInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
		[allIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
	}
	return allIndexPaths;
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
