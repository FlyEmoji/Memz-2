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
#import "MZWordDescriptionViewController.h"
#import "MZTransitioningDefaultBehavior.h"
#import "MZNavigationController.h"
#import "MZWord+CoreDataProperties.h"
#import "MZLanguageManager.h"
#import "MZDataManager.h"

NSString * const kMyDictionaryTableViewCellIdentifier = @"MZMyDictionaryTableViewCellIdentifier";
NSString * const MZWordDescriptionViewControllerSegue = @"MZWordDescriptionViewControllerSegue";

const CGFloat kMyDictionaryTableViewEstimatedRowHeight = 100.0f;

@interface MZMyDictionaryViewController () <UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MZWord *selectedWord;

@end

@implementation MZMyDictionaryViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableViewData];

	self.tableView.estimatedRowHeight = kMyDictionaryTableViewEstimatedRowHeight;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:MZWordDescriptionViewControllerSegue]) {
		MZWordDescriptionViewController *viewController = segue.destinationViewController;
		viewController.word = self.selectedWord;
		viewController.modalPresentationStyle = UIModalPresentationCustom;
		viewController.transitioningDelegate = self.transitioningBehavior;
		viewController.transitionDelegate = self.transitioningBehavior;
	}
}

- (void)setupTableViewData {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[MZWord entityName]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language == %d", [MZLanguageManager sharedManager].fromLanguage];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"learningIndex" ascending:NO];
	request.predicate = predicate;
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

#pragma mark - Table View Data Source & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZMyDictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyDictionaryTableViewCellIdentifier
																																			forIndexPath:indexPath];
	MZWord *word = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZWord class]];
	cell.wordLabel.text = word.word;
	[cell setupTranslations:[word.translation allObjects]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedWord = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZWord class]];
	[self performSegueWithIdentifier:MZWordDescriptionViewControllerSegue sender:self];
}

#pragma mark - Fetched Result Controller Delegate Methods

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
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeDelete: {
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		case NSFetchedResultsChangeUpdate: {
			MZMyDictionaryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			MZWord *word = [anObject safeCastToClass:[MZWord class]];
			cell.wordLabel.text = word.word;
			[cell setupTranslations:[word.translation allObjects]];
			break;
		}
		case NSFetchedResultsChangeMove: {
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

@end
