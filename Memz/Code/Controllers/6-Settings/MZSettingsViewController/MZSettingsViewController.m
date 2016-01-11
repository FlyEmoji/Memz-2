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

const CGFloat settingsTableViewHeaderHeight = 200.0f;

@interface MZSettingsViewController () <UITableViewDataSource,
UITableViewDelegate>

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


	// (3) Setup Table View Data
}

#pragma mark - Table View DataSource & Delegate Methods

@end
