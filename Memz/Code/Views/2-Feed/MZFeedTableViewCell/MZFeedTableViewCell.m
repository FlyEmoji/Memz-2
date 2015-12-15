//
//  MZFeedTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZFeedTableViewCell.h"
#import "UIImageView+MemzDownloadImage.h"

@interface MZFeedTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellSubTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MZFeedTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.cellTitle = @"";
	self.cellSubTitle = @"";
	self.backgroundImageURL = nil;
}

#pragma mark - Custom Setters

- (void)setCellTitle:(NSString *)cellTitle {
	_cellTitle = cellTitle;

	self.cellTitleLabel.text = cellTitle;
}

- (void)setCellSubTitle:(NSString *)cellSubTitle {
	_cellSubTitle = cellSubTitle;

	self.cellSubTitleLabel.text = cellSubTitle;
}

- (void)setBackgroundImageURL:(NSURL *)backgroundImageURL {
	_backgroundImageURL = backgroundImageURL;

	if (backgroundImageURL == nil) {
		self.backgroundImageView.image = nil;
	} else {
		[self.backgroundImageView setImageWithURL:backgroundImageURL
														 imagePlaceholder:nil
												showActivityIndicator:NO
																		completed:nil];
	}
}

@end
