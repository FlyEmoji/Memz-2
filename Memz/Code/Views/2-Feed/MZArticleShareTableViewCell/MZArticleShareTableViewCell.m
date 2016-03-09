//
//  MZArticleShareTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleShareTableViewCell.h"

@implementation MZArticleShareTableViewCell

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
