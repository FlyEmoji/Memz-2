//
//  MZTextFieldTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTextFieldTableViewCell.h"

CGFloat const kAddButtonDefaultWidthConstraint = 30.0f;

@interface MZTextFieldTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonWidthConstant;

@end

@implementation MZTextFieldTableViewCell

#pragma mark - Custom Getters / Setters

- (void)setCellType:(MZTextFieldTableViewCellType)cellType {
	_cellType = cellType;

	self.addButtonWidthConstant.constant = cellType == MZTextFieldTableViewCellTypeRegular ? 0.0f : kAddButtonDefaultWidthConstraint;
	[self layoutIfNeeded];
}

- (NSString *)cellText {
	return self.textField.text;
}

#pragma mark - Actions

- (IBAction)didTapAddButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidTapAddButton:)]) {
		[self.delegate textFieldTableViewCellDidTapAddButton:self];
	}
}

@end
