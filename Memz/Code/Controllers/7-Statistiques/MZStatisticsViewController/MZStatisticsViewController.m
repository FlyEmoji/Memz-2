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
#import "MZStatisticsProvider.h"
#import "NSDate+MemzAdditions.h"

typedef NS_ENUM(NSInteger, MZStatisticsGraph) {
	MZStatisticsGraphTotalTranslations,
	MZStatisticsGraphSuccessfulTranslations
};

NSString * const kGraphicTableViewCellIdentifier = @"MZGraphicTableViewCellIdentifier";

@interface MZStatisticsViewController () <MZStatisticsExtendedNavigationBarViewDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) IBOutlet MZStatisticsExtendedNavigationBarView *extendedNavigationBarView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *tableViewData;
@property (nonatomic, assign) MZStatisticsGranularity currentGranularity;

@end

@implementation MZStatisticsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupNavigationBarUI];
	self.extendedNavigationBarView.delegate = self;

	self.tableViewData = @[@(MZStatisticsGraphTotalTranslations), @(MZStatisticsGraphSuccessfulTranslations)];
	self.tableView.tableFooterView = [[UIView alloc] init];
	[self.tableView reloadData];
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
	[cell.graphicView transitionToValues:[self gatherStatisticsForGraph:self.tableViewData[indexPath.row].integerValue
																													granularity:self.currentGranularity]
													 withMetrics:[self metricsForGranularity:self.currentGranularity]
															animated:NO];
	return cell;
}

#pragma mark - Statistics Extended Navigation Bar View delegate methods

- (void)statisticsExtendedNavigationBarView:(MZStatisticsExtendedNavigationBarView *)view
						 didSelectStatisticsGranularity:(MZStatisticsGranularity)granularity {
	self.currentGranularity = granularity;
	[self.tableView reloadData];
}

#pragma mark - Exploitable Statistic Data

- (NSArray<NSNumber *> *)gatherStatisticsForGraph:(MZStatisticsGraph)graph
																			granularity:(MZStatisticsGranularity)granularity {
	return [self aggregateStatisticDataForGranularity:granularity];	 // TODO: Will probably remove this method
}

- (NSArray<NSString *> *)metricsForGranularity:(MZStatisticsGranularity)granularity {
	switch (granularity) {
		case MZStatisticsGranularityDay:
			return @[@"12AM", @"12PM", @"12AM"];
		case MZStatisticsGranularityWeek:
			return @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
		case MZStatisticsGranularityMonth:
			return @[];
		case MZStatisticsGranularityYear:
			return @[];
	}
}

#pragma mark - Statistic Data Aggregation

- (NSArray<NSNumber *> *)aggregateStatisticDataForGranularity:(MZStatisticsGranularity)granularity {
	NSMutableArray *mutableStatisticData = [[NSMutableArray alloc] init];

	for (NSUInteger days = 0; days < 7; days++) {
		[mutableStatisticData addObject:[MZStatisticsProvider translationsForLanguage:self.language
																																					 forDay:[[NSDate date] dayForDaysInThePast:days]]];
	}

	return mutableStatisticData;
}

@end
