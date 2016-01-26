//
//  MZMyQuizzesViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyQuizzesViewController.h"
#import "MZMyQuizzesTableViewCell.h"
#import "MZQuizInfoView.h"
#import "MZQuizViewController.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZDataManager.h"
#import "MZQuiz.h"

typedef NS_ENUM(NSInteger, MZScrollDirection) {
	MZScrollDirectionNone = 0,
	MZScrollDirectionDown,
	MZScrollDirectionUp
};

const CGFloat kTopShrinkableViewMinimumHeight = 40.0f;
const CGFloat kTopShrinkableViewMaximumHeight = 100.0f;

const CGFloat kQuizzesTableViewEstimatedRowHeight = 100.0f;

NSString * const kQuizTableViewCellIdentifier = @"MZMyQuizzesTableViewCellIdentifier";

@interface MZMyQuizzesViewController () <UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
MZQuizInfoViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet MZQuizInfoView *topShrinkableView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topShrinkableViewHeightConstraint;

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
}

- (void)setupTableViewData {
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[MZQuiz entityName]];
	NSSortDescriptor *descriptorIsAnswered = [NSSortDescriptor sortDescriptorWithKey:@"isAnswered" ascending:YES];
	NSSortDescriptor *descriptorDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
	request.sortDescriptors = @[descriptorIsAnswered, descriptorDate];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZMyQuizzesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQuizTableViewCellIdentifier
																																	 forIndexPath:indexPath];
	MZQuiz *quiz = [[self.fetchedResultsController objectAtIndexPath:indexPath] safeCastToClass:[MZQuiz class]];
	cell.quiz = quiz;
	return cell;
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
			MZMyQuizzesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
		// TODO: Second condition doesn't work if contentSize.height < scrollView.frame.size.height
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
	MZQuiz *quiz = [MZQuiz randomQuizFromLanguage:[MZLanguageManager sharedManager].fromLanguage
																		 toLanguage:[MZLanguageManager sharedManager].toLanguage];

	if (!quiz) {
		// TODO: Display message saying no words to translate
		return;
	}

	[MZQuizViewController askQuiz:quiz fromViewController:self completionBlock:^{
		[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:nil];
	}];
}

@end
