//
//  MZFeedViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZFeedViewController.h"
#import "MZFeedTableViewCell.h"

NSString * const kFeedTableViewCellIdentifier = @"MZFeedTableViewCellIdentifier";

NSString * const kCellTitleKey = @"kCellTitleKey";
NSString * const kCellSubTitleKey = @"kCellSubTitleKey";
NSString * const kCellPictureURLKey = @"kCellPictureURLKey";

const CGFloat kFeedTableViewCellFixedHeight = 200.0f;

@interface MZFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewData;

@end

@implementation MZFeedViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableViewData];
	[self.tableView reloadData];

	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupTableViewData {
	self.tableViewData = @[@{kCellTitleKey: @"Learn how to talk about cooking!",
													 kCellSubTitleKey: @"Add everything or part of our cooking vocabular selection of words, and become the expert in the kitchen ;)",
													 kCellPictureURLKey: [NSURL URLWithString:@"http://blog.chegg.com/wp-content/uploads/2013/02/cooking-college.jpg"]},
												 @{kCellTitleKey: @"#$@&%*!",
													 kCellSubTitleKey: @"Learn the best of the worst swear words in English",
													 kCellPictureURLKey: [NSURL URLWithString:@"http://images.medicaldaily.com/sites/medicaldaily.com/files/styles/full_breakpoints_theme_medicaldaily_desktop_1x/public/2015/04/29/science-swearing.jpg"]}];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kFeedTableViewCellFixedHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedTableViewCellIdentifier
																													forIndexPath:indexPath];
	MZFeedTableViewCell *feedCell = [cell safeCastToClass:[MZFeedTableViewCell class]];

	feedCell.cellTitle = self.tableViewData[indexPath.row][kCellTitleKey];
	feedCell.cellSubTitle = self.tableViewData[indexPath.row][kCellSubTitleKey];
	feedCell.backgroundImageURL = self.tableViewData[indexPath.row][kCellPictureURLKey];
	feedCell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

@end
