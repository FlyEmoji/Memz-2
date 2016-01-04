//
//  MZQuizViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizViewController.h"
#import "MZTranslationResponseTableViewCell.h"
#import "MZWordDescriptionHeaderView.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"
#import "MZCountDown.h"
#import "MZWord.h"

const CGFloat kTranslationResponseTableViewCellHeight = 60.0f;
const NSTimeInterval kSubmitButtonAnimationDuration = 0.3;
const NSTimeInterval kCountDownDuration = 90.0;

NSString * const kTranslationResponseTableViewCellIdentifier = @"MZTranslationResponseTableViewCellIdentifier";
NSString * const kQuizViewControllerIdentifer = @"MZQuizViewControllerIdentifier";

@interface MZQuizViewController () <UITableViewDataSource,
UITableViewDelegate,
MZTranslationResponseTableViewCellDelegate,
MZResponseComparatorDelegate,
MZCountDownDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) NSMutableArray<NSString *> *tableViewEnteredData;
@property (strong, nonatomic) MZWordDescriptionHeaderView *tableViewHeaderView;
@property (assign, nonatomic, getter=isTranslating) BOOL translating;
@property (strong, nonatomic) MZCountDown *countDown;

@end

@implementation MZQuizViewController

#pragma mark - Class Quiz Methods

+ (void)askQuiz:(MZQuiz *)quiz fromViewController:(UIViewController *)fromViewController completionBlock:(void (^)(void))completionBlock {
	__block MZQuizCompletionBlock didGiveTranslationResponseBlock;

	MZQuizViewController * (^ completeResponse)(MZResponse *, BOOL, UIViewController *) = ^(MZResponse *response, BOOL present, UIViewController *currentViewController) {
		MZQuizViewController *quizViewController = [[UIStoryboard storyboardWithName:@"Quiz" bundle:nil] instantiateViewControllerWithIdentifier:kQuizViewControllerIdentifer];
		quizViewController.response = response;
		quizViewController.didGiveTranslationResponse = didGiveTranslationResponseBlock;

		if (present) {
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:quizViewController];
			[currentViewController.navigationController presentViewController:navigationController animated:YES completion:nil];
		} else {
			[currentViewController.navigationController pushViewController:quizViewController animated:YES];
		}

		return quizViewController;
	};

	__block NSUInteger currentResponseIndex = 0;
	__block UIViewController *currentViewController = fromViewController;
	didGiveTranslationResponseBlock = ^{
		if (currentResponseIndex >= quiz.responses.count) {
			quiz.isAnswered = @YES;
			[fromViewController.navigationController dismissViewControllerAnimated:YES completion:^{
				completionBlock();
			}];
			return;
		}

		MZResponse *response = quiz.responses.allObjects[currentResponseIndex];
		currentViewController = completeResponse(response, currentResponseIndex == 0, currentViewController);

		currentResponseIndex++;
	};

	didGiveTranslationResponseBlock();
}

#pragma mark - Public Methods

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self setupResponse];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.countDown = [MZCountDown countDownWithDuration:kCountDownDuration delegate:self];
	[self.countDown fire];
}

- (void)setResponse:(MZResponse *)response {
	_response = response;

	[self setupResponse];
}

#pragma mark - Setups

- (void)setupResponse {
	self.translating = YES;

	self.tableViewEnteredData = [[NSMutableArray alloc] initWithCapacity:self.response.word.translation.count];
	for (NSUInteger i = 0; i < self.response.word.translation.count; i++) {
		[self.tableViewEnteredData addObject:@""];
	}

	[self setupTableViewHeader];
	[self.tableView reloadData];
	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupTableViewHeader {
	if (!self.tableView.tableHeaderView) {
		self.tableViewHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MZWordDescriptionHeaderView class])
																														 owner:self
																													 options:nil][0];
		self.tableViewHeaderView.headerType = MZWordDescriptionHeaderTypeReadonly;
		self.tableView.tableHeaderView = self.tableViewHeaderView;
	}
	self.tableViewHeaderView.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height / 4.0f);
	self.tableViewHeaderView.word = self.response.word;
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewEnteredData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTranslationResponseTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZTranslationResponseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTranslationResponseTableViewCellIdentifier
																																						 forIndexPath:indexPath];
	cell.flagImageView.image = [UIImage flagImageForLanguage:[MZLanguageManager sharedManager].toLanguage];
	cell.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"QuizResponseTextFieldPlaceholder", nil), indexPath.row + 1];
	cell.textField.returnKeyType = indexPath.row == self.tableViewEnteredData.count - 1 ? UIReturnKeyDone : UIReturnKeyNext;
	cell.delegate = self;
	return cell;
}

#pragma mark - Translation Response Table View Cell Delegate Methods

- (void)translationResponseTableViewCellTextFieldDidChange:(MZTranslationResponseTableViewCell *)cell {
	NSUInteger index = [self.tableView indexPathForCell:cell].row;
	self.tableViewEnteredData[index] = cell.textField.text;
}

- (void)translationResponseTableViewCellTextFieldDidHitReturnButton:(MZTranslationResponseTableViewCell *)cell {
	NSUInteger index = [self.tableView indexPathForCell:cell].row;
	if (index == self.tableViewEnteredData.count - 1) {
		[self.view endEditing:YES];
	} else {
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index + 1 inSection:0];
		MZTranslationResponseTableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
		[nextCell.textField becomeFirstResponder];

		// TODO: Check if workds if there are invisible cells
	}
}

#pragma mark - Count Down Delegate Methods

- (void)countDownDidChange:(MZCountDown *)countDown remainingTime:(NSTimeInterval)remainingTime totalTime:(NSTimeInterval)totalTime {
	self.tableViewHeaderView.countDownRemainingTime = remainingTime;
}

- (void)countDownDidEnd:(MZCountDown *)countDown {
	[self submitResponseAndDisplayResults];
}

#pragma mark - Helpers

- (UIColor *)submitButtonColorForResult:(MZResponseResult)result {
	switch (result) {
		case MZResponseResultRight:
			return [UIColor quizNextButtonRightColor];
		case MZResponseResultLearningInProgress:
			return [UIColor quizNextButtonLearningInProgressColor];
		case MZResponseResultWrond:
			return [UIColor quizNextButtonWrongColor];
		default:
			return [UIColor quizSubmitButtonColor];
	}
}

- (void)submitResponseAndDisplayResults {
	if (!self.isTranslating) {
		return;
	}

	self.translating = NO;

	if (self.countDown.isRunning) {
		[self.countDown invalidate];
		self.countDown = nil;
		self.tableViewHeaderView.countDownRemainingTime = 0.0;
	}

	// TODO: Update View With Correct Answers
	// TODO: Disable Interaction On Text Fields

	UIColor *submitButtonColor = [self submitButtonColorForResult:[self.response checkTranslations:self.tableViewEnteredData delegate:self]];
	[UIView animateWithDuration:kSubmitButtonAnimationDuration
									 animations:^{
										 self.submitButton.backgroundColor = submitButtonColor;
										 [self.submitButton setTitle:NSLocalizedString(@"CommonNext", nil) forState:UIControlStateNormal];
									 }];
}

#pragma mark - Actions

- (IBAction)didTapSubmitButton:(id)sender {
	if (self.isTranslating) {
		[self submitResponseAndDisplayResults];
	} else if (self.didGiveTranslationResponse) {
		self.didGiveTranslationResponse();
	}
}

@end
