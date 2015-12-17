//
//  MZWordAdditionViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordAdditionViewController.h"
#import "MZWordAdditionTableViewHeader.h"
#import "MZTextFieldTableViewCell.h"

typedef NS_ENUM(NSInteger, MZWordAdditionSectionType) {
	MZWordAdditionSectionTypeWord,
	MZWordAdditionSectionTypeTranslations,
	MZWordAdditionSectionTypeSuggestions
};

typedef NS_ENUM(NSInteger, MZWordAdditionWordRowType) {
	MZWordAdditionWordRowTypeNewWord,
	MZWordAdditionWordRowTypeTranslation
};

NSString * const kWordAdditionTableViewHeaderIdentifier = @"MZWordAdditionTableViewHeaderIdentifier";
NSString * const kTextFieldTableViewCellIdentifier = @"MZTextFieldTableViewCellIdentifier";

NSString * const kSectionTypeKey = @"SectionTypeKey";
NSString * const kSectionTitleKey = @"SectionTitleKey";
NSString * const kWordRowTypeKey = @"WordRowTypeKey";
NSString * const kContentTypeKey = @"ContentTypeKey";

const CGFloat kTableViewSectionHeaderHeight = 40.0f;
const CGFloat kWordAdditionTypeWordCellHeight = 50.0f;

@interface MZWordAdditionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (weak, nonatomic, readonly) NSArray *tableViewData;

@property (strong, nonatomic) NSString *wordToTranslate;
@property (copy, nonatomic) NSMutableArray *wordTranslations;
@property (strong, nonatomic) NSArray *wordSuggestions;

@end

@implementation MZWordAdditionViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"Add New Word";  // TODO: Localize

	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Cancel"]
																																	style:UIBarButtonItemStylePlain
																																target:self
																																action:@selector(didTapCloseButton:)];
	[self.navigationItem setLeftBarButtonItem:leftButton];

	[self setupTableView];
	[self.tableView reloadData];
}

#pragma mark - Setups

- (void)setupTableView {
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZWordAdditionTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kWordAdditionTableViewHeaderIdentifier];
}

#pragma mark - Data Management

- (NSArray *)tableViewData {
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];

	[mutableArray addObject:@{kSectionTypeKey: @(MZWordAdditionSectionTypeWord),
														kSectionTitleKey: @"Your word",
														kContentTypeKey: @[@{kWordRowTypeKey: @(MZWordAdditionWordRowTypeNewWord),
																								 kContentTypeKey: self.wordToTranslate ?: @""},
																							 @{kWordRowTypeKey: @(MZWordAdditionWordRowTypeTranslation),
																								 kContentTypeKey: @""}]}];

	if (self.wordTranslations.count) {
		[mutableArray addObject:@{kSectionTypeKey: @(MZWordAdditionSectionTypeTranslations),
															kSectionTitleKey: @"Your translations",
															kContentTypeKey: self.wordTranslations}];
	}

	if (self.wordSuggestions.count) {
		[mutableArray addObject:@{kSectionTypeKey: @(MZWordAdditionSectionTypeSuggestions),
															kSectionTitleKey: @"Suggested translations",
															kContentTypeKey: self.wordSuggestions}];
	}

	return mutableArray;
}

#pragma mark - Table View Data Source & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return kTableViewSectionHeaderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.tableViewData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  MZWordAdditionTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kWordAdditionTableViewHeaderIdentifier];
	headerView.headerTitle.text = [self.tableViewData[section][kSectionTitleKey] safeCastToClass:[NSString class]];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([self.tableViewData[indexPath.section][kSectionTypeKey] integerValue]) {
		case MZWordAdditionSectionTypeWord:
			return kWordAdditionTypeWordCellHeight;
		default:
			return UITableViewAutomaticDimension;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableViewData[section][kContentTypeKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([self.tableViewData[indexPath.section][kSectionTypeKey] integerValue]) {
		case MZWordAdditionSectionTypeWord: {
			MZTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldTableViewCellIdentifier
																																			 forIndexPath:indexPath];
			if ([self.tableViewData[indexPath.section][kContentTypeKey][indexPath.row][kWordRowTypeKey] integerValue] == MZWordAdditionWordRowTypeNewWord) {
				cell.cellType = MZTextFieldTableViewCellTypeRegular;
			} else {
				cell.cellType = MZTextFieldTableViewCellTypeAddition;
			}
			return cell;
		}

		default:
			return nil;
			break;
		}
}

#pragma mark - Actions

- (void)didTapCloseButton:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
