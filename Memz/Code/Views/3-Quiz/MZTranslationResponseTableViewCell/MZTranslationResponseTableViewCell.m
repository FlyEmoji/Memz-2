//
//  MZTranslationResponseTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTranslationResponseTableViewCell.h"

const CGFloat kRightImageWidthCorrectionConstant = 30.0f;
const NSTimeInterval kCorrectionAnimationDuration = 0.3;

@interface MZTranslationResponseTableViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *rightImageView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightImageViewWidthConstraint;

@end

@implementation MZTranslationResponseTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.textField.text = @"";
	self.textField.attributedText = [[NSAttributedString alloc] initWithString:@""];
}

- (void)setStatus:(MZTranslationResponseTableViewCellType)status
	userTranslation:(NSString *)userTranslation
			 correction:(NSString *)correction
					isRight:(BOOL)isRight {
	_status = status;

	switch (status) {
		case MZTranslationResponseTableViewCellTypeUnaswered:
			self.textField.userInteractionEnabled = YES;
			self.textField.text = userTranslation;
			break;
		case MZTranslationResponseTableViewCellTypeAnswered:
			self.textField.userInteractionEnabled = NO;
			[self animateCorrectionIsRight:isRight];

			// Translations can be considered correct even if different - if very slightly different (usually one character)
			// In that case and even if the right image shows correct indicator, we still want to display the wrong but almost
			// true proposed translation, and the actual corrected translation for user to realize it was not exactly perfect, and learn.

			if (![userTranslation isEqualToString:correction]) {
				NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:userTranslation];
				[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
				[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:correction]];

				[mutableAttributedString addAttribute:NSForegroundColorAttributeName
																				value:[UIColor quizNextButtonWrongColor]
																				range:NSMakeRange(0, userTranslation.length)];

				[mutableAttributedString addAttribute:NSForegroundColorAttributeName
																				value:[UIColor blackColor]
																				range:NSMakeRange(userTranslation.length, correction.length)];

				self.textField.attributedText = mutableAttributedString;
			} else {
				self.textField.text = correction;
			}
	}
}

#pragma mark - Animations 

- (void)animateCorrectionIsRight:(BOOL)isRight {
	UIImage *image = [UIImage imageWithAssetIdentifier:isRight ? MZAssetIdentifierQuizTick : MZAssetIdentifierQuizCross];
	self.rightImageView.image = image;

	self.rightImageViewWidthConstraint.constant = kRightImageWidthCorrectionConstant;
	[UIView animateWithDuration:kCorrectionAnimationDuration animations:^{
		[self.contentView layoutIfNeeded];
	}];
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
