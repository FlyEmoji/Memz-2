//
//  MZWordDescriptionViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordDescriptionViewController.h"
#import "MZWordDescriptionHeaderView.h"

@interface MZWordDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSSet<MZWord *> *tableViewData;

@end

@implementation MZWordDescriptionViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableView];
}

- (void)setWord:(MZWord *)word {
	_word = word;

	[self setupTableView];
}

#pragma mark - Setups

- (void)setupTableView {
	[self setupTableViewHeader];
	self.tableViewData = self.word.translation;
	[self.tableView reloadData];
}

- (void)setupTableViewHeader {
	MZWordDescriptionHeaderView *tableViewHeader = [self.tableView.tableHeaderView safeCastToClass:[MZWordDescriptionHeaderView class]];
	if (!tableViewHeader) {
		tableViewHeader = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MZWordDescriptionHeaderView class])
																																							 owner:self
																																						 options:nil][0];
		tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height / 4.0f);
		self.tableView.tableHeaderView = tableViewHeader;
	}
	tableViewHeader.word = self.word;
}

@end
