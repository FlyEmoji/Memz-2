//
//  MZLanguagesPickerViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerViewController.h"
#import "MZLanguagesPickerCollectionController.h"

@interface MZLanguagesPickerViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MZLanguagesPickerCollectionController *collectionController;

@end

@implementation MZLanguagesPickerViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.collectionController = [[MZLanguagesPickerCollectionController alloc] initWithCollectionView:self.collectionView];
	self.collectionController.collectionViewData = @[@"French", @"English", @"Spanish", @"Greek"];
	[self.collectionController reloadDataAnimated:YES completionHandler:nil];
}

#pragma mark - Actions

- (IBAction)backBarButtonItemTapped:(UIBarButtonItem *)barButtonItem {
	[self.collectionController dropAllCellsAnimated:YES completionHandler:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
