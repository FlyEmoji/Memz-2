//
//  MZStatisticsViewController.m
//  Memz
//
//  Created by Bastien Falcou on 2/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZStatisticsViewController.h"
#import "MZStatisticsExtendedNavigationBarView.h"
#import "MZGraphicTableViewCell.h"

NSString * const kGraphicTableViewCellIdentifier = @"MZGraphicTableViewCellIdentifier";

@interface MZStatisticsViewController () <MZStatisticsExtendedNavigationBarViewDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) IBOutlet MZStatisticsExtendedNavigationBarView *extendedNavigationBarView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *tableViewData;

@end

@implementation MZStatisticsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableViewData = @[@"data1", @"data2", @"data3", @"data4"];
	self.tableView.tableFooterView = [[UIView alloc] init];
	[self.tableView reloadData];

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

#pragma mark - Table View Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZGraphicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGraphicTableViewCellIdentifier
																																 forIndexPath:indexPath];
	cell.graphicView.yOriginType = MZGraphYOriginTypeMinimumValue;
	[cell.graphicView transitionToValues:@[@4, @8, @3, @6, @2, @7, @3] withMetrics:@[@"M", @"T", @"W", @"T", @"F", @"S", @"S"] animated:NO];
	return cell;
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
