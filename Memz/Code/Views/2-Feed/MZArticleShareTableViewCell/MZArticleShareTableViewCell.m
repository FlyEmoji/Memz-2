//
//  MZArticleShareTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleShareTableViewCell.h"

@interface MZArticleShareTableViewCell ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareButtons;

@end

@implementation MZArticleShareTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	for (UIButton *button in self.shareButtons) {
		button.imageView.contentMode = UIViewContentModeScaleAspectFit;
	}
}

#pragma mark - Actions

- (IBAction)didTapTwitterButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(articleShareTableViewCell:didTapShareOption:)]) {
		[self.delegate articleShareTableViewCell:self didTapShareOption:MZShareOptionTwitter];
	}
}

- (IBAction)didTapFacebookButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(articleShareTableViewCell:didTapShareOption:)]) {
		[self.delegate articleShareTableViewCell:self didTapShareOption:MZShareOptionFacebook];
	}
}

- (IBAction)didTapOthersButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(articleShareTableViewCell:didTapShareOption:)]) {
		[self.delegate articleShareTableViewCell:self didTapShareOption:MZShareOptionShareSheet];
	}
}

@end
