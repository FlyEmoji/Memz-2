//
//  MZTranslationResponseTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTranslationResponseTableViewCell.h"

@implementation MZTranslationResponseTableViewCell

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
