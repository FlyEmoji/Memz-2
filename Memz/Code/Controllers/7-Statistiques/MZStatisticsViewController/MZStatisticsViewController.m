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
#import "MZUser+StatisticsProvider.h"
#import "NSDate+MemzAdditions.h"

typedef NS_ENUM(NSInteger, MZStatisticsGraph) {
	MZStatisticsGraphTotalTranslations,
	MZStatisticsGraphSuccessfulTranslations
};

NSString * const kGraphicTableViewCellIdentifier = @"MZGraphicTableViewCellIdentifier";

const NSUInteger kWeekGranularityNumberMeasures = 7;
const NSUInteger kMonthGranularityNumberMeasures = 31;
const NSUInteger kYearGranularityNumberMeasures = 20;

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

	cell.graphicView.title = [self titleForGraph:self.tableViewData[indexPath.row].integerValue];
	cell.graphicView.metricText = NSLocalizedString(@"StatisticsGraphMetric", nil);

	[cell.graphicView transitionToValues:[self aggregateStatisticDataForGranularity:self.currentGranularity
																																				 forGraph:self.tableViewData[indexPath.row].integerValue]
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

#pragma mark - Table View Population

- (NSArray<NSString *> *)metricsForGranularity:(MZStatisticsGranularity)granularity {
	NSMutableArray *mutableMetricsData = [[NSMutableArray alloc] init];

	switch (granularity) {
		case MZStatisticsGranularityWeek:
			for (NSUInteger days = 0; days < 7; days++) {
				[mutableMetricsData addObject:[[[NSDate date] dayForDaysInThePast:days] weekDay]];
			}
			break;
		case MZStatisticsGranularityMonth:
			for (NSUInteger days = 0; days <= 31; days = days + 31 / 5) {
				[mutableMetricsData addObject:[NSString stringWithFormat:@"%ld", (long)[[[NSDate date] dayForDaysInThePast:days] day]]];
			}
			break;
		case MZStatisticsGranularityYear:
			for (NSUInteger days = 0; days <= 365; days = days + 365 / 4) {
				[mutableMetricsData addObject:[[[NSDate date] dayForDaysInThePast:days] month]];
			}
			break;
	}
	return [[mutableMetricsData reverseObjectEnumerator] allObjects];
}

- (NSString *)titleForGraph:(MZStatisticsGraph)graph {
	switch (graph) {
		case MZStatisticsGraphTotalTranslations:
			return NSLocalizedString(@"StatisticsGraphTotalTitle", nil);
		case MZStatisticsGraphSuccessfulTranslations:
			return NSLocalizedString(@"StatisticsGraphSuccessfulTitle", nil);
	}
}

#pragma mark - Statistic Data Aggregation

- (NSUInteger)valueForGraph:(MZStatisticsGraph)graph language:(MZLanguage)language day:(NSDate *)day {
	switch (graph) {
		case MZStatisticsGraphTotalTranslations:
			return [[MZUser currentUser] translationsForLanguage:language forDay:day].count;
		case MZStatisticsGraphSuccessfulTranslations:
			return [[MZUser currentUser] successfulTranslationsForLanguage:language forDay:day].count;
	}
}

- (NSArray<NSNumber *> *)aggregateStatisticDataForGranularity:(MZStatisticsGranularity)granularity
																										 forGraph:(MZStatisticsGraph)graph {
	NSMutableArray *mutableStatisticData = [[NSMutableArray alloc] init];

	switch (granularity) {
		case MZStatisticsGranularityWeek:
			for (NSUInteger days = 0; days < 7; days++) {
				NSUInteger count = [self valueForGraph:graph language:self.language day:[[NSDate date] dayForDaysInThePast:days]];
				[mutableStatisticData addObject:@(count)];
			}
			break;
		case MZStatisticsGranularityMonth:
			for (NSUInteger period = 0; period < kMonthGranularityNumberMeasures; period++) {
				NSUInteger count = 0;
				for (NSUInteger daysInPeriod = period * kMonthGranularityNumberMeasures; daysInPeriod < 31 / kMonthGranularityNumberMeasures; daysInPeriod++) {
					count += [self valueForGraph:graph language:self.language day:[[NSDate date] dayForDaysInThePast:daysInPeriod]];
				}
				[mutableStatisticData addObject:@(count)];
			}
			break;
		case MZStatisticsGranularityYear:
			for (NSUInteger period = 0; period < kYearGranularityNumberMeasures; period++) {
				NSUInteger count = 0;
				for (NSUInteger daysInPeriod = period * kYearGranularityNumberMeasures; daysInPeriod < 365 / kYearGranularityNumberMeasures; daysInPeriod++) {
					count += [self valueForGraph:graph language:self.language day:[[NSDate date] dayForDaysInThePast:daysInPeriod]];
				}
				[mutableStatisticData addObject:@(count)];
			}
			break;
	}
	return [[mutableStatisticData reverseObjectEnumerator] allObjects];
}

@end
