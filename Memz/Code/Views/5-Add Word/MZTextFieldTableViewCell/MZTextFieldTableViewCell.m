//
//  MZTextFieldTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTextFieldTableViewCell.h"
#import "UIImage+MemzAdditions.h"

CGFloat const kAddButtonDefaultWidthConstraint = 30.0f;

@interface MZTextFieldTableViewCell ()

@property (nonatomic, strong) IBOutlet UIButton *addButton;
@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;

@end

@implementation MZTextFieldTableViewCell

#pragma mark - Custom Getters / Setters

- (void)setCellType:(MZTextFieldTableViewCellType)cellType {
	_cellType = cellType;

	self.addButton.hidden = cellType == MZTextFieldTableViewCellTypeRegular;
}

- (void)setLanguage:(MZLanguage)language {
	_language = language;

	self.flagImageView.image = [UIImage flagImageForLanguage:language];
}

#pragma mark - Actions

- (IBAction)didTapAddButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidTapAddButton:)]) {
		[self.delegate textFieldTableViewCellDidTapAddButton:self];
	}
}

- (IBAction)editingDidChange:(id)sender {
	if ([self.delegate respondsToSelector:@selector(textFieldTableViewCell:textDidChange:)]) {
		[self.delegate textFieldTableViewCell:self textDidChange:self.textField.text];
	}
}

@end
