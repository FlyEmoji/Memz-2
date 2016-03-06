//
//  MZArticleViewController.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleViewController.h"
#import "MZArticlePictureTableViewCell.h"
#import "UIImageView+MemzDownloadImage.h"
#import "MZTableView.h"

typedef NS_ENUM(NSUInteger, MZArticleTableViewRowType) {
	MZArticleTableViewRowTypePicture,
	MZArticleTableViewRowTypeTitle,
	MZArticleTableViewRowTypeText
};

NSString * const kArticlePictureTableViewCellIdentifier = @"MZArticlePictureTableViewCellIdentifier";

const CGFloat kArticleTableViewEstimatedRowHeight = 100.0f;

@interface MZArticleViewController () <UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) IBOutlet MZTableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary *> *tableViewData;

@end

@implementation MZArticleViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.tableFooterView = [[UIView alloc] init];

	[self setupTableViewData];
	[self.tableView reloadData];
}

- (void)setupTableViewData {
	self.tableViewData = @[@{@"cellType": @(MZArticleTableViewRowTypePicture),
													 @"content": [NSURL URLWithString:@"http://2.bp.blogspot.com/-QE32IeFhaTw/T3LUeIlyp1I/AAAAAAAAAtk/w3ID_Z6YF0E/s1600/Oliver+Sweeney+Shades.jpg"]}];
}

#pragma mark - Table View Data Source & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.tableViewData[indexPath.row][@"cellType"] integerValue] == MZArticleTableViewRowTypePicture) {
		return 150.0f;
	}
	return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZArticlePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticlePictureTableViewCellIdentifier
																																				 forIndexPath:indexPath];
	[cell.imageView setImageWithURL:self.tableViewData[indexPath.row][@"content"]];
	return cell;
}

@end
