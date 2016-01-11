//
//  MZSettingsViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsViewController.h"
#import "MZSettingsTableViewHeader.h"
#import "MZSettingsTitleTableViewCell.h"

NSString * const kSettingsTableViewHeaderIdentifier = @"MZSettingsTableViewHeaderIdentifier";
NSString * const kSettingsTitleTableViewCellIdentifier = @"MZSettingsTitleTableViewCellIdentifier";

const CGFloat kSettingsTableViewHeaderHeight = 200.0f;

@interface MZSettingsViewController () <UITableViewDataSource,
UITableViewDelegate,
MZSettingsTableViewHeaderDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *tableViewData;

@end

@implementation MZSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableView];
}

- (void)setupTableView {
	// (1) Register custom Table View Header
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZSettingsTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kSettingsTableViewHeaderIdentifier];

	// (2) Setup Table View Header
	MZSettingsTableViewHeader *tableViewHeader = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MZSettingsTableViewHeader class])
																																						 owner:self
																																					 options:nil][0];
	tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, kSettingsTableViewHeaderHeight);
	tableViewHeader.delegate = self;
	self.tableView.tableHeaderView = tableViewHeader;

	// (3) Setup Table View Data
	// TODO: To implement
}

#pragma mark - Table View DataSource & Delegate Methods

// TODO: To implement

#pragma mark - Table View Header Delegate Methods

- (void)settingsTableViewHeaderDidRequestChangeFromLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	// TODO: To implement
}

- (void)settingsTableViewHeaderDidRequestChangeToLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	// TODO: To implement
}

@end
