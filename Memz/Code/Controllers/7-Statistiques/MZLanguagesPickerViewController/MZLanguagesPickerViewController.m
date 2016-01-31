//
//  MZLanguagesPickerViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerViewController.h"
#import "MZLanguageCollectionViewCell.h"

NSString * const kLanguageCollectionViewCellIdentifier = @"MZLanguageCollectionViewCellIdentifier";

@interface MZLanguagesPickerViewController () <UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *collectionViewData;

@end

@implementation MZLanguagesPickerViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSArray<NSString *> *languages = @[@"France", @"US", @"UK", @"Other"];
	self.collectionViewData = [[NSMutableArray alloc] initWithCapacity:languages.count];

	for (NSUInteger i = 0; i < languages.count; i++) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self.collectionViewData addObject:languages[i]];
			[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
		});
	}
}

#pragma mark - Collection View DataSource & Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MZLanguageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLanguageCollectionViewCellIdentifier
																																								 forIndexPath:indexPath];
	cell.backgroundColor = [UIColor redColor];
	return cell;
}

@end
