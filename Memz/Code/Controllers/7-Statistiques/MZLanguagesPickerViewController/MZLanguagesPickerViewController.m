//
//  MZLanguagesPickerViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerViewController.h"

NSString * const kLanguageCollectionViewCellIdentifier = @"MZLanguageCollectionViewCellIdentifier";

@interface MZLanguagesPickerViewController () <UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *collectionViewData;

@end

@implementation MZLanguagesPickerViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.collectionViewData = @[@"France", @"US", @"UK", @"Other"];
	[self.collectionView reloadData];
}

#pragma mark - Collection View DataSource & Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLanguageCollectionViewCellIdentifier
																																				 forIndexPath:indexPath];
	return cell;
}

@end
