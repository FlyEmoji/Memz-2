//
//  MZQuizViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizViewController.h"
#import "MZTranslationResponseTableViewCell.h"
#import "UIImage+MemzAdditions.h"
#import "MZWord.h"

const CGFloat kTranslationResponseTableViewCellHeight = 80.0f;

NSString * const kTranslationResponseTableViewCellIdentifier = @"MZTranslationResponseTableViewCellIdentifier";

@interface MZQuizViewController () <UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (copy, nonatomic) NSMutableArray<NSString *> *tableViewEnteredData;

@end

@implementation MZQuizViewController

#pragma mark - Class Quiz Methods

+ (void)askQuiz:(MZQuizz *)quizz fromViewController:(UIViewController *)fromViewController completionBlock:(void (^)(void))completionBlock {
	__block MZQuizCompletionBlock didGiveTranslationResponseBlock;
	void (^ completeResponse)(MZResponse *) = ^(MZResponse *response) {
		MZQuizViewController *viewController = [[MZQuizViewController alloc] initWithResponse:response];
		[fromViewController.navigationController pushViewController:viewController animated:YES];

		viewController.didGiveTranslationResponse = didGiveTranslationResponseBlock;
	};

	__block NSUInteger currentResponseIndex = 0;
	didGiveTranslationResponseBlock = ^{
		if (currentResponseIndex < quizz.responses.count) {
			quizz.isAnswered = @YES;
			completionBlock();
			return;
		}

		MZResponse *response = quizz.responses.allObjects[currentResponseIndex];
		completeResponse(response);

		currentResponseIndex++;
	};

	didGiveTranslationResponseBlock();
}

#pragma mark - Public Methods

- (instancetype)initWithResponse:(MZResponse *)response {
	if (self = [super init]) {
		_response = response;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableViewEnteredData = [[NSMutableArray alloc] initWithCapacity:self.response.word.translation.count];
	for (NSUInteger i = 0; i < self.response.word.translation.count; i++) {
		[self.tableViewEnteredData addObject:@""];
	}

	[self.tableView reloadData];
	self.tableView.tableFooterView = [[UIView alloc] init];
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
	cell.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"QuizResponseTextFieldPlaceholder", nil), indexPath.row];
	return cell;
}

@end
