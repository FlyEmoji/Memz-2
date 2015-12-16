//
//  MZPollsInfoView.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZPollsInfoView.h"
#import "UIView+MemzAdditions.h"

@interface MZPollsInfoView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *pageWidthConstraint;

// First page: information
@property (nonatomic, weak) IBOutlet UILabel *numberPendingPollsLabel;
@property (nonatomic, weak) IBOutlet UILabel *pendingPollDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *createNewPollButton;

// Second page: statistics

// Third page: to be decided

@end

@implementation MZPollsInfoView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.numberPendingPollsLabel makeCircular];
	self.pageWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
}

@end
