//
//  MZLanguagesPickerViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguagesPickerViewController.h"
#import "MZLanguagesPickerCollectionController.h"
#import "MZStatisticsViewController.h"

NSString * const kStatisticsViewControllerSegue = @"MZStatisticsViewControllerSegue";

@interface MZLanguagesPickerViewController () <MZLanguagesPickerCollectionControllerDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MZLanguagesPickerCollectionController *collectionController;

@property (nonatomic, assign) MZLanguage selectedLanguage;

@end

@implementation MZLanguagesPickerViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	self.collectionController = [[MZLanguagesPickerCollectionController alloc] initWithCollectionView:self.collectionView];
	self.collectionController.collectionViewData = [MZLanguageManager sharedManager].allLanguages;
	self.collectionController.delegate = self;
	[self.collectionController reloadDataAnimated:YES completionHandler:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kStatisticsViewControllerSegue]) {
		MZStatisticsViewController *viewController = [segue.destinationViewController safeCastToClass:[MZStatisticsViewController class]];
		viewController.language = self.selectedLanguage;
	}
}

#pragma mark - Picker Collection Controller Delegate Methods

- (void)languagesPickerCollectionController:(MZLanguagesPickerCollectionController *)collectionController
													didSelectLanguage:(MZLanguage)language {
	self.selectedLanguage = language;
	[self performSegueWithIdentifier:kStatisticsViewControllerSegue sender:self];
}

#pragma mark - Actions

- (IBAction)backBarButtonItemTapped:(UIBarButtonItem *)barButtonItem {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
