//
//  MZTranslationResponseTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTranslationResponseTableViewCell.h"

@implementation MZTranslationResponseTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.textField.text = @"";
	self.textField.attributedText = [[NSAttributedString alloc] initWithString:@""];
}

- (void)switchToCorrectionDisplayIsRight:(BOOL)isRight correctionText:(NSString *)correction {
	self.textField.userInteractionEnabled = NO;

	if (isRight) {
		return;
	}

	NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.textField.text];
	[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
	[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:correction]];

	[mutableAttributedString addAttribute:NSForegroundColorAttributeName
																	value:[UIColor quizNextButtonWrongColor]
																	range:NSMakeRange(0, self.textField.text.length)];

	[mutableAttributedString addAttribute:NSForegroundColorAttributeName
																	value:[UIColor blackColor]
																	range:NSMakeRange(self.textField.text.length, correction.length)];

	self.textField.attributedText = mutableAttributedString;
}

#pragma mark - Actions

- (IBAction)textFieldDidChange:(id)sender {
	if ([self.delegate respondsToSelector:@selector(translationResponseTableViewCellTextFieldDidChange:)]) {
		[self.delegate translationResponseTableViewCellTextFieldDidChange:self];
	}
}

- (IBAction)textFieldDidTapReturnKey:(id)sender {
	if ([self.delegate respondsToSelector:@selector(translationResponseTableViewCellTextFieldDidHitReturnButton:)]) {
		[self.delegate translationResponseTableViewCellTextFieldDidHitReturnButton:self];
	}
}

@end
