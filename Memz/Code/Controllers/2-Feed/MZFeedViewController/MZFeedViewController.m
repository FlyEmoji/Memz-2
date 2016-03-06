//
//  MZFeedViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZFeedViewController.h"
#import "MZFeedTableViewCell.h"
#import "MZRemoteServerCoordinator.h"

NSString * const kFeedTableViewCellIdentifier = @"MZFeedTableViewCellIdentifier";
NSString * const kPresentArticleViewControllerSegue = @"MZPresentArticleViewControllerSegue";

NSString * const kCellTitleKey = @"kCellTitleKey";
NSString * const kCellSubTitleKey = @"kCellSubTitleKey";
NSString * const kCellPictureURLKey = @"kCellPictureURLKey";

@interface MZFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewData;

@end

@implementation MZFeedViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableViewData];

	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupTableViewData {
	// TODO: Display loader

	[MZRemoteServerCoordinator fetchFeedWithCompletionHandler:^(NSArray<MZArticle *> *articles, NSError *error) {
		// TODO: Hide loader
		if (error) {
			// TODO: Display error
			return;
		}

		NSMutableArray *feedContent = [[NSMutableArray alloc] initWithCapacity:articles.count];

		for (MZArticle *article in articles) {
			[feedContent addObject:@{kCellTitleKey: article.title,
															 kCellSubTitleKey: article.subTitle,
															 kCellPictureURLKey: article.imageUrl}];
		}

		self.tableViewData = feedContent;
		[self.tableView reloadData];
	}];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self performSegueWithIdentifier:kPresentArticleViewControllerSegue sender:nil];
}

@end
