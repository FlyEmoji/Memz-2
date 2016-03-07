//
//  MZArticleViewController.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleViewController.h"
#import "MZArticlePictureTableViewCell.h"
#import "MZArticleTitleTableViewCell.h"
#import "MZArticleDetailsTableViewCell.h"
#import "MZArticleBodyTableViewCell.h"
#import "MZArticleAddAllTableViewCell.h"
#import "UIImageView+MemzDownloadImage.h"
#import "NSDate+MemzAdditions.h"
#import "MZTableView.h"

typedef NS_ENUM(NSUInteger, MZArticleTableViewRowType) {
	MZArticleTableViewRowTypePicture,
	MZArticleTableViewRowTypeTitle,
	MZArticleTableViewRowTypeDetails,
	MZArticleTableViewRowTypeBody,
	MZArticleTableViewRowTypeAddAll
};

NSString * const kArticlePictureTableViewCellIdentifier = @"MZArticlePictureTableViewCellIdentifier";
NSString * const kArticleTitleTableViewCellIdentifier = @"MZArticleTitleTableViewCellIdentifier";
NSString * const kArticleDetailsTableViewCellIdentifier = @"MZArticleDetailsTableViewCellIdentifier";
NSString * const kArticleBodyTableViewCellIdentifier = @"MZArticleBodyTableViewCellIdentifier";
NSString * const kArticleAddAllTableViewCellIdentifier = @"MZArticleAddAllTableViewCellIdentifier";

const CGFloat kArticleTableViewEstimatedRowHeight = 100.0f;

@interface MZArticleViewController () <UITableViewDataSource,
UITableViewDelegate,
MZArticleAddAllTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet MZTableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *tableViewData;

@end

@implementation MZArticleViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.estimatedRowHeight = kArticleTableViewEstimatedRowHeight;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupTableViewData {
	if (!self.article) {
		return;
	}

	self.tableViewData = [@[@{@"cellType": @(MZArticleTableViewRowTypePicture),
													 @"content": self.article.imageUrl},
												  @{@"cellType": @(MZArticleTableViewRowTypeTitle),
													 @"content": self.article.title},
												  @{@"cellType": @(MZArticleTableViewRowTypeDetails),
													 @"content": self.article.additionDate,
													 @"secondaryContent": self.article.source},
												  @{@"cellType": @(MZArticleTableViewRowTypeBody),
													 @"content": self.article.body}] mutableCopy];

	if (self.article.suggestedWords) {
		[self.tableViewData addObject:@{@"cellType": @(MZArticleTableViewRowTypeAddAll)}];
	}
}

#pragma mark - Custom Setters

- (void)setArticle:(MZArticle *)article {
	_article = article;

	[self setupTableViewData];
	[self.tableView reloadData];
}

#pragma mark - Table View Data Source & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.tableViewData[indexPath.row][@"cellType"] integerValue] == MZArticleTableViewRowTypePicture) {
		return self.view.frame.size.height / 3.0f;
	}
	return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([self.tableViewData[indexPath.row][@"cellType"] integerValue]) {
		case MZArticleTableViewRowTypePicture: {
			MZArticlePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticlePictureTableViewCellIdentifier
																																						forIndexPath:indexPath];
			[cell.articleImageView setImageWithURL:self.tableViewData[indexPath.row][@"content"]];
			return cell;
		}
		case MZArticleTableViewRowTypeTitle: {
			MZArticleTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleTitleTableViewCellIdentifier
																																						forIndexPath:indexPath];
			cell.titleLabel.text = self.tableViewData[indexPath.row][@"content"];
			return cell;
		}
		case MZArticleTableViewRowTypeDetails: {
			MZArticleDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleDetailsTableViewCellIdentifier
																																						forIndexPath:indexPath];
			NSDate *articleDate = [self.tableViewData[indexPath.row][@"content"] safeCastToClass:[NSDate class]];
			cell.dateLabel.text = [articleDate humanReadableDateString];
			cell.sourceLabel.text = self.tableViewData[indexPath.row][@"secondaryContent"];
			return cell;
		}
		case MZArticleTableViewRowTypeBody: {
			MZArticleBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleBodyTableViewCellIdentifier
																																				 forIndexPath:indexPath];
			cell.bodyLabel.text = self.tableViewData[indexPath.row][@"content"];
			return cell;
		}
		case MZArticleTableViewRowTypeAddAll: {
			MZArticleAddAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleAddAllTableViewCellIdentifier
																																					 forIndexPath:indexPath];
			cell.delegate = self;
			return cell;
		}
	}
	return nil;
}

#pragma mark - Add All Suggested Words Cell Delegate

- (void)articleAddAllTableViewCellDidTap:(MZArticleAddAllTableViewCell *)cell {
	// TODO
}

@end
