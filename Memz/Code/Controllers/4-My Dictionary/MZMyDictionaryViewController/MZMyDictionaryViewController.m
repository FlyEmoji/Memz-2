//
//  MZMyDictionaryViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyDictionaryViewController.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZMyDictionaryTableViewCell.h"
#import "MZWord+CoreDataProperties.h"
#import "MZLanguageManager.h"

NSString * const kMyDictionaryTableViewCell = @"MZMyDictionaryTableViewCellIdentifier";

const CGFloat kMyDictionaryTableViewEstimatedRowHeight = 100.0f;

@interface MZMyDictionaryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<MZWord *> *tableViewData;

@end

@implementation MZMyDictionaryViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language == %d", [MZLanguageManager sharedManager].fromLanguage];
	self.tableViewData = [MZWord allObjectsMatchingPredicate:predicate];

	self.tableView.estimatedRowHeight = kMyDictionaryTableViewEstimatedRowHeight;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.tableFooterView = [[UIView alloc] init];

	[self.tableView reloadData];
}

#pragma mark - Table View Data Source & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZMyDictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyDictionaryTableViewCell
																																			forIndexPath:indexPath];
	MZWord *word = self.tableViewData[indexPath.row];
	cell.wordLabel.text = word.word;
	[cell setupTranslations:[word.translation allObjects]];
	return cell;
}

@end
