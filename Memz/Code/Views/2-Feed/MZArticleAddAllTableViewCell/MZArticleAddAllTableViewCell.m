//
//  MZArticleAddAllTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleAddAllTableViewCell.h"

@interface MZArticleAddAllTableViewCell ()

@property (strong, nonatomic) IBOutlet UIButton *addAllButton;

@end

@implementation MZArticleAddAllTableViewCell

- (IBAction)didTapButton:(UIButton *)sender {
	if ([self.delegate respondsToSelector:@selector(articleAddAllTableViewCellDidTap:)]) {
		[self.delegate articleAddAllTableViewCellDidTap:self];
	}
}

@end
