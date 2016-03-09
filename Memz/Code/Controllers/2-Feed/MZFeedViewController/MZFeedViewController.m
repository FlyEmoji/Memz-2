//
//  MZFeedViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZFeedViewController.h"
#import "MZArticleViewController.h"
#import "MZFeedTableViewCell.h"
#import "MZRemoteServerCoordinator.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZNavigationController.h"

NSString * const kFeedTableViewCellIdentifier = @"MZFeedTableViewCellIdentifier";
NSString * const kPresentArticleViewControllerSegue = @"MZPresentArticleViewControllerSegue";

@interface MZFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<MZArticle *> *tableViewData;

@property (nonatomic, strong) MZArticle *selectedArticle;

@end

@implementation MZFeedViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableViewData];

	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kPresentArticleViewControllerSegue]) {
		MZNavigationController *navigationController = [segue.destinationViewController safeCastToClass:[MZNavigationController class]];
		MZArticleViewController *articleController = [navigationController.viewControllers.firstObject safeCastToClass:[MZArticleViewController class]];
		articleController.article = self.selectedArticle;
	}
}

- (void)setupTableViewData {
	// TODO: Display loader

	[MZRemoteServerCoordinator fetchFeedWithCompletionHandler:^(NSArray<MZArticle *> *articles, NSError *error) {
		// TODO: Hide loader
		if (error) {
			// TODO: Display error
			return;
		}

		self.tableViewData = articles;
		[self.tableView reloadData];
	}];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedTableViewCellIdentifier
																															forIndexPath:indexPath];

	cell.cellTitle = self.tableViewData[indexPath.row].title;
	cell.cellSubTitle = self.tableViewData[indexPath.row].subTitle;
	cell.backgroundImageURL = self.tableViewData[indexPath.row].imageUrl;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedArticle = self.tableViewData[indexPath.row];
	[self performSegueWithIdentifier:kPresentArticleViewControllerSegue sender:nil];
}

@end
