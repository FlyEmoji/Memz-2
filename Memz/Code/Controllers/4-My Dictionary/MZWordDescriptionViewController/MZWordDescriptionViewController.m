//
//  MZWordDescriptionViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordDescriptionViewController.h"
#import "MZWordDescriptionHeaderView.h"
#import "MZWordDescriptionTableViewCell.h"
#import "UIImage+MemzAdditions.h"

NSString * const kWordDescriptionTableViewCellIdentifier = @"MZWordDescriptionTableViewCellIdentifier";

const CGFloat kWordDescriptionTableViewEstimatedRowHeight = 100.0f;

@interface MZWordDescriptionViewController () <UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<MZWord *> *tableViewData;

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
	self.tableView.estimatedRowHeight = kWordDescriptionTableViewEstimatedRowHeight;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.tableFooterView = [[UIView alloc] init];

	[self setupTableViewHeader];

	self.tableViewData = self.word.translation.allObjects;
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

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZWordDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWordDescriptionTableViewCellIdentifier
																																			forIndexPath:indexPath];
	cell.wordLabel.text = self.tableViewData[indexPath.row].word;
	cell.flagImageView.image = [UIImage flagImageForLanguage:self.tableViewData[indexPath.row].language.integerValue];
	return cell;
}

#pragma mark - Test Methods

- (IBAction)testReturnButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
