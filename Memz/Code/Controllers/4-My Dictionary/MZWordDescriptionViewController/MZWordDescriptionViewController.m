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
#import "MZDataManager.h"
#import "UIImage+MemzAdditions.h"

NSString * const kWordDescriptionTableViewCellIdentifier = @"MZWordDescriptionTableViewCellIdentifier";

const CGFloat kWordDescriptionTableViewEstimatedRowHeight = 100.0f;

const NSTimeInterval kEditAnimationDuration = 0.3;

@interface MZWordDescriptionViewController () <UITableViewDataSource,
UITableViewDelegate,
MZWordDescriptionHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<MZWord *> *tableViewData;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation MZWordDescriptionViewController		// TODO: See if NSFetchRequestController applicable

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

	self.tableViewData = self.word.translation.allObjects.mutableCopy;
	[self.tableView reloadData];
}

- (void)setupTableViewHeader {
	MZWordDescriptionHeaderView *tableViewHeader = [self.tableView.tableHeaderView safeCastToClass:[MZWordDescriptionHeaderView class]];
	if (!tableViewHeader) {
		tableViewHeader = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MZWordDescriptionHeaderView class])
																																							 owner:self
																																						 options:nil][0];
		tableViewHeader.delegate = self;
		tableViewHeader.headerType = MZWordDescriptionHeaderTypeEdit;
		self.tableView.tableHeaderView = tableViewHeader;
	}
	tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height / 4.0f);
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.tableViewData.count <= 1) {
		[self removeWordWithCompletionHandler:^{
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	} else {
		[self removeTranslation:self.tableViewData[indexPath.row] completionHandler:nil];
	}
}

#pragma mark - Edition Helpers

- (void)removeTranslation:(MZWord *)translation completionHandler:(void (^ __nullable)(void))completionHandler {
	NSUInteger index = [self.tableViewData indexOfObject:translation];

	[self.tableViewData removeObjectAtIndex:index];
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]
												withRowAnimation:UITableViewRowAnimationRight];

	NSMutableArray *translationStrings = [[NSMutableArray alloc] initWithCapacity:self.tableViewData.count];
	[self.tableViewData enumerateObjectsUsingBlock:^(MZWord *word, NSUInteger idx, BOOL *stop) {
		[translationStrings addObject:word.word];
	}];
	[self.word updateTranslations:translationStrings toLanguage:[MZLanguageManager sharedManager].toLanguage];

	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:completionHandler];
}

- (void)removeWordWithCompletionHandler:(void (^ __nullable)(void))completionHandler {
	[[MZDataManager sharedDataManager].managedObjectContext deleteObject:self.word];
	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:completionHandler];
}

#pragma mark - Table View Header Delegate Methods

- (void)wordDescriptionHeaderViewDidStartEditing:(MZWordDescriptionHeaderView *)headerView {
	[self.tableView setEditing:YES animated:YES];

	[UIView animateWithDuration:kEditAnimationDuration
									 animations:^{
										 self.bottomButton.backgroundColor = [UIColor editWordBackgroundColor];
										 [self.bottomButton setTitle:NSLocalizedString(@"CommonDelete", nil) forState:UIControlStateNormal];
									 }];
}

- (void)wordDescriptionHeaderViewDidStopEditing:(MZWordDescriptionHeaderView *)headerView {
	[self.tableView setEditing:NO animated:YES];

	[UIView animateWithDuration:kEditAnimationDuration
									 animations:^{
										 self.bottomButton.backgroundColor = [UIColor secondaryBackgroundColor];
										 [self.bottomButton setTitle:NSLocalizedString(@"CommonReturn", nil) forState:UIControlStateNormal];
									 }];
}

#pragma mark - Test Methods

- (IBAction)bottomButtonTapped:(id)sender {
	if (self.tableView.isEditing) {
		[self removeWordWithCompletionHandler:^{
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

@end
