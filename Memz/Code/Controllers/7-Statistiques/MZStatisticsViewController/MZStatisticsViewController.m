//
//  MZStatisticsViewController.m
//  Memz
//
//  Created by Bastien Falcou on 2/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZStatisticsViewController.h"
#import "MZStatisticsExtendedNavigationBarView.h"

@interface MZStatisticsViewController () <MZStatisticsExtendedNavigationBarViewDelegate>

@property (nonatomic, strong) IBOutlet MZStatisticsExtendedNavigationBarView *extendedNavigationBarView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation MZStatisticsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupNavigationBarUI];
	self.extendedNavigationBarView.delegate = self;
}

#pragma mark - Navigation Bar & Extension UI Setup

- (void)setupNavigationBarUI {
	// (1) The navigation bar's shadowImage is set to a transparent image. In conjunction with providing
	// a custom background image, this removes the grey hairline at the bottom of the navigation bar.
  // The MZStatisticsExtendedNavigationBarView will draw its own hairline.
	self.navigationController.navigationBar.shadowImage = [UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationBarTransparentPixel];

	// (2) MZAssetIdentifierNavigationBarPixel is a solid white 1x1 image.
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationBarPixel]
																								forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Statistics Extende dNavigation Bar View delegate methods

- (void)statisticsExtendedNavigationBarView:(MZStatisticsExtendedNavigationBarView *)view
						 didSelectStatisticsGranularity:(MZStatisticsGranularity)granularity {
	switch (granularity) {
		case MZStatisticsGranularityDay:
			// TODO
			break;
		case MZStatisticsGranularityWeek:
			// TODO
			break;
		case MZStatisticsGranularityMonth:
			// TODO
			break;
		case MZStatisticsGranularityYear:
			// TODO
			break;
	}
}

@end
