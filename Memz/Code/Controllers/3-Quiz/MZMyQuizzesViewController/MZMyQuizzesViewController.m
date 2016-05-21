//
//  MZMyQuizzesViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyQuizzesViewController.h"
#import "MZAnsweredQuizTableViewCell.h"
#import "MZPendingQuizTableViewCell.h"
#import "MZSettingsViewController.h"
#import "MZQuizInfoView.h"
#import "MZEmptyStateView.h"
#import "MZQuizViewController.h"
#import "NSManagedObject+MemzCoreData.h"
#import "UIViewController+MemzAdditions.h"
#import "MZDataManager.h"
#import "MZQuiz.h"

typedef NS_ENUM(NSInteger, MZScrollDirection) {
	MZScrollDirectionNone = 0,
	MZScrollDirectionDown,
	MZScrollDirectionUp
};

const NSTimeInterval kQuizEmptyStateFadeAnimationDuration = 0.2;

const CGFloat kTopShrinkableViewMinimumHeight = 0.0f;
const CGFloat kTopShrinkableViewMaximumHeight = 67.0f;

const CGFloat kQuizzesTableViewEstimatedRowHeight = 100.0f;

NSString * const kLanguagePickerViewControllerSegue = @"MZLanguagePickerViewControllerSegue";
NSString * const kAnsweredQuizTableViewCellIdentifier = @"MZAnsweredQuizTableViewCellIdentifier";
NSString * const kPendingQuizTableViewCellIdentifier = @"MZPendingQuizTableViewCellIdentifier";

@interface MZMyQuizzesViewController () <UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
MZQuizInfoViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet MZQuizInfoView *topShrinkableView;
@property (nonatomic, weak) IBOutlet MZEmptyStateView *emptyStateView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topShrinkableViewHeightConstraint;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation MZMyQuizzesViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupTableViewData];

	self.tableView.estimatedRowHeight = kQuizzesTableViewEstimatedRowHeight;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	self.tableView.contentInset = UIEdgeInsetsMake(kTopShrinkableViewMaximumHeight, 0.0f, 0.0f, 0.0f);
	self.tableView.contentOffset = CGPointMake(0.0f, -self.topShrinkableViewHeightConstraint.constant);
	self.tableView.tableFooterView = [[UIView alloc] init];

	self.topShrinkableView.delegate = self;

	[[NSNotificationCenter defaultCenter] addObserverForName:MZSettingsDidChangeLanguageNotification
																										object:nil
																										 queue:[NSOperationQueue mainQueue]
																								usingBlock:
	 ^(NSNotification * _Nonnull note) {
		 [self setupTableViewData];
		 [self.tableView reloadData];
		 [self updateEmptyState];
	 }];
}

- (void)setupTableViewData {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[MZQuiz entityName]];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ && newLanguage == %ld && knownLanguage == %ld", [MZUser currentUser].objectID, [MZUser currentUser].newLanguage.integerValue, [MZUser currentUser].knownLanguage.integerValue];
	request.predicate = predicate;

	NSSortDescriptor *descriptorIsAnswered = [NSSortDescriptor sortDescriptorWithKey:@"isAnswered" ascending:YES];
	NSSortDescriptor *descriptorAnswerDate = [NSSortDescriptor sortDescriptorWithKey:@"answerDate" ascending:NO];
	NSSortDescriptor *descriptorCreationDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
	request.sortDescriptors = @[descriptorIsAnswered, descriptorAnswerDate, descriptorCreationDate];

	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																																			managedObjectContext:[MZDataManager sharedDataManager].managedObjectContext
																																				sectionNameKeyPath:nil
																																								 cacheName:nil];
	self.fetchedResultsController.delegate = self;

	NSError *error = nil;
	[self.fetchedResultsController performFetch:&error];
	[self updateEmptyState];

	if (error) {
		NSLog(@"%@, %@", error, error.localizedDescription);
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Helpers

- (void)updateEmptyState {
	BOOL show = [self.tableView numberOfRowsInSection:0] == 0;

	[UIView animateWithDuration:kQuizEmptyStateFadeAnimationDuration animations:^{
		self.emptyStateView.alpha = show ? 1.0f : 0.0f;
		self.tableView.alpha = show ? 0.0f : 1.0f;
	}];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZQuiz *quiz = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZQuiz class]];

	if (quiz.isAnswered.boolValue) {
		MZAnsweredQuizTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnsweredQuizTableViewCellIdentifier
																																				forIndexPath:indexPath];
		cell.quiz = quiz;
		return cell;
	} else {
		MZPendingQuizTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPendingQuizTableViewCellIdentifier
																																			 forIndexPath:indexPath];
		cell.quiz = quiz;
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MZQuiz *quiz = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZQuiz class]];
	if (quiz.isAnswered) {
		// TODO: Show quiz in view mode
	} else {
		[MZQuizViewController askQuiz:quiz fromViewController:self completionBlock:^{
			[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:nil];
		}];
	}
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
			MZAnsweredQuizTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			cell.quiz = [anObject safeCastToClass:[MZQuiz class]];
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
	[self updateEmptyState];
}

#pragma mark - Scroll Management

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	MZScrollDirection scrollDirection = [self scrollDirectionForScrollView:scrollView];
	scrollView.contentInset = UIEdgeInsetsMake(self.topShrinkableViewHeightConstraint.constant,
																						 scrollView.contentInset.left,
																						 scrollView.contentInset.bottom,
																						 scrollView.contentInset.right);

	if (scrollView.contentOffset.y < -scrollView.contentInset.top
			|| scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom)) {
		self.lastContentOffset = scrollView.contentOffset;
		return;
	}

	if (scrollDirection == MZScrollDirectionDown) {
		if (self.topShrinkableViewHeightConstraint.constant < kTopShrinkableViewMaximumHeight) {
			self.topShrinkableViewHeightConstraint.constant += self.lastContentOffset.y - scrollView.contentOffset.y;
		}
	}

	if (scrollDirection == MZScrollDirectionUp) {
		if (self.topShrinkableViewHeightConstraint.constant > kTopShrinkableViewMinimumHeight) {
			self.topShrinkableViewHeightConstraint.constant += self.lastContentOffset.y - scrollView.contentOffset.y;
		}
	}

	if (self.topShrinkableViewHeightConstraint.constant > kTopShrinkableViewMaximumHeight) {
		self.topShrinkableViewHeightConstraint.constant = kTopShrinkableViewMaximumHeight;
	} else if (self.topShrinkableViewHeightConstraint.constant < kTopShrinkableViewMinimumHeight) {
		self.topShrinkableViewHeightConstraint.constant = kTopShrinkableViewMinimumHeight;
	}
	self.lastContentOffset = scrollView.contentOffset;
}

- (MZScrollDirection)scrollDirectionForScrollView:(UIScrollView *)scrollView {
	if (self.lastContentOffset.y > scrollView.contentOffset.y) {
		return MZScrollDirectionDown;
	} else if (self.lastContentOffset.y < scrollView.contentOffset.y) {
		return MZScrollDirectionUp;
	} else {
		return MZScrollDirectionNone;
	}
}

#pragma mark - Quiz Info View Delegate Methods

- (void)quizInfoViewDidRequestNewQuiz:(MZQuizInfoView *)quizInfoView {
	MZQuiz *quiz = [MZQuiz randomQuizForUser:[MZUser currentUser] creationDate:nil];

	if (!quiz) {
		[self presentError:[MZErrorCreator errorWithType:MZErrorTypeNoWordToTranslate]];
		return;
	}

	[MZQuizViewController askQuiz:quiz fromViewController:self completionBlock:^{
		[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:nil];
	}];
}

@end
