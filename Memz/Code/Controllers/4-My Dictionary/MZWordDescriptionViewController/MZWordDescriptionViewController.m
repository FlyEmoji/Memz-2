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
#import "MZWordAdditionTableViewHeader.h"
#import "NSManagedObject+MemzCoreData.h"
#import "UIImage+MemzAdditions.h"
#import "UIView+MemzAdditions.h"
#import "MZShareManager.h"
#import "MZDataManager.h"

NSString * const kWordDescriptionTableViewCellIdentifier = @"MZWordDescriptionTableViewCellIdentifier";
NSString * const kWordSuggestionsTableViewHeaderIdentifier = @"MZWordSuggestionsTableViewHeaderIdentifier";

const CGFloat kWordDescriptionTableViewEstimatedRowHeight = 100.0f;
const CGFloat kWordTableViewSectionHeaderHeight = 45.0f;
const CGFloat kBottomButtonDeleteHeight = 60.0f;

const NSTimeInterval kEditAnimationDuration = 0.3;

@interface MZWordDescriptionViewController () <UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
MZWordDescriptionHeaderViewDelegate,
MZTableViewTransitionDelegate>

@property (nonatomic, strong) IBOutlet MZTableView *tableView;
@property (nonatomic, strong) IBOutlet MZWordDescriptionHeaderView *tableViewHeader;

@property (nonatomic, strong) IBOutlet UIButton *bottomButton;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomButtonHeightConstraint;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MZWordDescriptionViewController	

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableView];
	[self setupTableViewData];
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

	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZWordAdditionTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kWordSuggestionsTableViewHeaderIdentifier];

	self.tableViewHeader.headerType = MZWordDescriptionHeaderTypeEdit;
	self.tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height / 4.0f);
	self.tableViewHeader.word = self.word;
}

- (void)setupTableViewData {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[MZWord entityName]];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language == %d AND %@ IN translations AND %@ IN users", [MZUser currentUser].knownLanguage.integerValue, self.word.objectID, [MZUser currentUser].objectID];
	request.predicate = predicate;

	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"word" ascending:NO];
	request.sortDescriptors = @[descriptor];

	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																																			managedObjectContext:[MZDataManager sharedDataManager].managedObjectContext
																																				sectionNameKeyPath:nil
																																								 cacheName:nil];
	self.fetchedResultsController.delegate = self;

	NSError *error = nil;
	[self.fetchedResultsController performFetch:&error];

	if (error) {
		NSLog(@"%@, %@", error, error.localizedDescription);
	}
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return sectionInfo.numberOfObjects;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return kWordTableViewSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	MZWordAdditionTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kWordSuggestionsTableViewHeaderIdentifier];
	headerView.sectionType = MZWordAdditionSectionTypeManual;
	headerView.backgroundColor = [UIColor mainMediumGrayColor];
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZWordDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWordDescriptionTableViewCellIdentifier
																																				 forIndexPath:indexPath];
	MZWord *word = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZWord class]];
	cell.wordLabel.text = word.word;
	cell.flagImageView.image = [UIImage flagImageForLanguage:word.language.integerValue];
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:indexPath.section];
	MZWord *word = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZWord class]];

	if (sectionInfo.numberOfObjects <= 1) {
		[self removeWordWithCompletionHandler:^{
			[self dismissViewControllerWithCompletion:nil];
		}];
	} else {
		[self removeTranslation:word completionHandler:nil];
	}
}

#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
	 didChangeObject:(id)anObject
			 atIndexPath:(NSIndexPath *)indexPath
		 forChangeType:(NSFetchedResultsChangeType)type
			newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert: {
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeDelete: {
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeUpdate: {
			[self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeMove: {
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}


#pragma mark - Edition Helpers

- (void)removeTranslation:(MZWord *)translation completionHandler:(void (^ __nullable)(void))completionHandler {
	[self.word removeTranslationsObject:translation];
	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:completionHandler];
}

- (void)removeWordWithCompletionHandler:(void (^ __nullable)(void))completionHandler {
	[[MZUser currentUser] removeTranslationsObject:self.word];
	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:completionHandler];
}

#pragma mark - Table View Header Delegate Methods

- (void)wordDescriptionHeaderViewDidStartEditing:(MZWordDescriptionHeaderView *)headerView {
	[self.tableView setEditing:YES animated:YES];

	self.tableView.backgroundColor = self.tableView.progressiveBackgroundColor;
	self.tableView.transitionDelegate = nil;

	self.bottomButtonHeightConstraint.constant = kBottomButtonDeleteHeight;
	[UIView animateWithDuration:kEditAnimationDuration
									 animations:^{
										 [self.view layoutIfNeeded];
									 }];
}

- (void)wordDescriptionHeaderViewDidStopEditing:(MZWordDescriptionHeaderView *)headerView {
	[self.tableView setEditing:NO animated:YES];

	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.transitionDelegate = self;

	self.bottomButtonHeightConstraint.constant = 0.0f;
	[UIView animateWithDuration:kEditAnimationDuration
									 animations:^{
										 [self.view layoutIfNeeded];
									 }];
}

#pragma mark - Test Methods

- (IBAction)bottomButtonTapped:(id)sender {
	[self removeWordWithCompletionHandler:^{
		[self dismissViewControllerWithCompletion:nil];
	}];
}

@end
