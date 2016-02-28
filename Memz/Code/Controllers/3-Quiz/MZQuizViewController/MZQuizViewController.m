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

#define UNVALID_INDEX -1

const NSTimeInterval kSubmitButtonAnimationDuration = 0.3;
const NSTimeInterval kCountDownDuration = 90.0;

NSString * const kTranslationResponseTableViewCellIdentifier = @"MZTranslationResponseTableViewCellIdentifier";
NSString * const kQuizViewControllerIdentifer = @"MZQuizViewControllerIdentifier";

NSString * const kCellStatusKey = @"MZCellStatusKey";
NSString * const kUserTranslationKey = @"MZUserTranslationKey";
NSString * const kCorrectionKey = @"MZCorrectionKey";
NSString * const kIsRightKey = @"MZIsRightKey";

@interface MZQuizViewController () <UITableViewDataSource,
UITableViewDelegate,
MZTranslationResponseTableViewCellDelegate,
MZResponseComparatorDelegate,
MZCountDownDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet MZWordDescriptionHeaderView *tableViewHeader;

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *tableViewEnteredData;
@property (nonatomic, weak, readonly) NSArray<NSString *> *userTranslations;

@property (nonatomic, assign, getter=isTranslating) BOOL translating;
@property (nonatomic, strong) MZCountDown *countDown;

@end

@implementation MZQuizViewController

#pragma mark - Class Quiz Methods

+ (void)askQuiz:(MZQuiz *)quiz fromViewController:(UIViewController *)fromViewController completionBlock:(void (^)(void))completionBlock {
	__block MZQuizCompletionBlock didGiveTranslationResponseBlock;

	MZQuizViewController * (^ completeResponse)(MZResponse *, BOOL, UIViewController *) = ^(MZResponse *response, BOOL present, UIViewController *currentViewController) {
		MZQuizViewController *quizViewController = [[UIStoryboard storyboardWithName:MZQuizStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kQuizViewControllerIdentifer];
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
			quiz.date = [NSDate date];
			[fromViewController.navigationController dismissViewControllerAnimated:YES completion:^{
				if (completionBlock) {
					completionBlock();
				}
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

- (NSArray<NSString *> *)userTranslations {
	NSMutableArray<NSString *> *mutatingUserTranslations = [[NSMutableArray alloc] initWithCapacity:self.tableViewEnteredData.count];

	for (NSMutableDictionary *dictionary in self.tableViewEnteredData) {
		NSString *translation = [dictionary[kUserTranslationKey] safeCastToClass:[NSString class]];
		if (translation) {
			[mutatingUserTranslations addObject:translation];
		}
	}
	return mutatingUserTranslations;
}

#pragma mark - Setups

- (void)setupResponse {
	NSMutableDictionary * (^ buildTranslation)(MZTranslationResponseTableViewCellType, NSString *, NSString *, BOOL) =
	^(MZTranslationResponseTableViewCellType status, NSString *userTranslation, NSString *correction, BOOL isRight) {
		return [@{kCellStatusKey: @(status),
							kUserTranslationKey: userTranslation,
							kCorrectionKey: correction,
							kIsRightKey: @(isRight)} mutableCopy];
	};

	self.translating = YES;

	self.tableViewEnteredData = [[NSMutableArray alloc] initWithCapacity:self.response.word.translation.count];
	for (NSUInteger i = 0; i < self.response.word.translation.count; i++) {
		[self.tableViewEnteredData addObject:buildTranslation(MZTranslationResponseTableViewCellTypeUnaswered, @"", @"", NO)];
	}

	self.tableViewHeader.word = self.response.word;
	self.tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, self.tableView.frame.size.height / 4.0f);

	[self.tableView reloadData];
	self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewEnteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZTranslationResponseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTranslationResponseTableViewCellIdentifier
																																						 forIndexPath:indexPath];

	cell.flagImageView.image = [UIImage flagImageForLanguage:[MZLanguageManager sharedManager].toLanguage];
	cell.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"QuizResponseTextFieldPlaceholder", nil), indexPath.row + 1];
	cell.textField.returnKeyType = indexPath.row == self.tableViewEnteredData.count - 1 ? UIReturnKeyDone : UIReturnKeyNext;
	cell.delegate = self;

	MZTranslationResponseTableViewCellType status = [self.tableViewEnteredData[indexPath.row][kCellStatusKey] integerValue];
	NSString *userTranslation = self.tableViewEnteredData[indexPath.row][kUserTranslationKey];
	NSString *correction = self.tableViewEnteredData[indexPath.row][kCorrectionKey];
	BOOL isRight = [self.tableViewEnteredData[indexPath.row][kIsRightKey] boolValue];

	[cell setStatus:status userTranslation:userTranslation correction:correction isRight:isRight];

	return cell;
}

#pragma mark - Translation Response Table View Cell Delegate Methods

- (void)translationResponseTableViewCellTextFieldDidChange:(MZTranslationResponseTableViewCell *)cell {
	NSUInteger index = [self.tableView indexPathForCell:cell].row;
	self.tableViewEnteredData[index][kUserTranslationKey] = cell.textField.text;
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
	self.tableViewHeader.countDownRemainingTime = remainingTime;
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

	// TODO: Need to test if there are duplicated translations

	self.translating = NO;

	if (self.countDown.isRunning) {
		[self.countDown invalidate];
		self.countDown = nil;
		self.tableViewHeader.countDownRemainingTime = 0.0;
	}

	UIColor *submitButtonColor = [self submitButtonColorForResult:[self.response checkTranslations:self.userTranslations delegate:self]];
	[UIView animateWithDuration:kSubmitButtonAnimationDuration
									 animations:^{
										 self.submitButton.backgroundColor = submitButtonColor;
										 [self.submitButton setTitle:NSLocalizedString(@"CommonNext", nil) forState:UIControlStateNormal];
									 }];
}

#pragma mark - Check Translation Delegate Methods

- (void)responseComparator:(MZResponseComparator *)response
			 didCheckTranslation:(NSString *)translation
					 correctWithWord:(MZWord *)correction
			isTranslationCorrect:(BOOL)isCorrect {
	NSUInteger cellIndex = [self indexPathForNotCorrectedUserTranslation:translation];

	// (1) Update Managed Object
	self.response.result = @(isCorrect);

	if (isCorrect && self.response.word.learningIndex.integerValue < MZWordIndexLearned) {
		self.response.word.learningIndex = @(self.response.word.learningIndex.integerValue + 1);
	} else if (!isCorrect && self.response.word.learningIndex.integerValue > 0) {
		self.response.word.learningIndex = @(self.response.word.learningIndex.integerValue - 1);
	}

	// (2) Update persisted Table View data for reusability, update corresponding Cell
	self.tableViewEnteredData[cellIndex][kCellStatusKey] = @(MZTranslationResponseTableViewCellTypeAnswered);
	self.tableViewEnteredData[cellIndex][kCorrectionKey] = correction.word ?: @"";
	self.tableViewEnteredData[cellIndex][kIsRightKey] = @(isCorrect);

	MZTranslationResponseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];

	[cell setStatus:[self.tableViewEnteredData[cellIndex][kCellStatusKey] integerValue]
	userTranslation:[self.tableViewEnteredData[cellIndex][kUserTranslationKey] safeCastToClass:[NSString class]]
			 correction:[self.tableViewEnteredData[cellIndex][kCorrectionKey] safeCastToClass:[NSString class]]
					isRight:[self.tableViewEnteredData[cellIndex][kIsRightKey] boolValue]];
}

#pragma mark - Helpers

- (NSInteger)indexPathForNotCorrectedUserTranslation:(NSString *)string {
	// Only return index path for words that have not been corrected yet: their correction value must be an empty string
	for (NSMutableDictionary *dictionary in self.tableViewEnteredData) {
		if ([[dictionary[kUserTranslationKey] safeCastToClass:[NSString class]] isEqualToString:string]
				&& [[dictionary[kCorrectionKey] safeCastToClass:[NSString class]] isEqualToString:@""]) {
			return [self.tableViewEnteredData indexOfObject:dictionary];
		}
	}
	return UNVALID_INDEX;
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
