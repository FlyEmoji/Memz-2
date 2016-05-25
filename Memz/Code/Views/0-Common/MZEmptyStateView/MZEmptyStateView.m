//
//  MZEmptyStateView.m
//  Memz
//
//  Created by Bastien Falcou on 5/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZEmptyStateView.h"
#import "UIFont+MemzAdditions.h"

const CGFloat kEmptyStateLabelParagraphSpacing = 6.0f;

@interface MZEmptyStateView ()

@property (nonatomic, weak) IBOutlet UIImageView *emptyStateImageView;
@property (nonatomic, weak) IBOutlet UILabel *emptyStateLabel;
@property (nonatomic, weak) IBOutlet UIButton *emptyStateButton;

@end

@implementation MZEmptyStateView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self updateElements];
}

- (void)updateElements {
	if (!self.emptyStateImage || !self.emptyStateLabel) {
		return;
	}

	self.emptyStateImageView.image = self.emptyStateImage;

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = kEmptyStateLabelParagraphSpacing;
	paragraphStyle.alignment = NSTextAlignmentCenter;

	NSDictionary *attributes = @{NSFontAttributeName: self.emptyStateLabel.font,
															 NSForegroundColorAttributeName: self.emptyStateLabel.textColor,
															 NSParagraphStyleAttributeName: paragraphStyle};

	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.emptyStateDescription
																																										 attributes:attributes];
	self.emptyStateLabel.attributedText = attributedText;

	[self.emptyStateButton setTitle:self.suggestionButtonDescription forState:UIControlStateNormal];
}

- (IBAction)didTapSuggestionButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(emptyStateViewDidTapSuggestionButton:)]) {
		[self.delegate emptyStateViewDidTapSuggestionButton:self];
	}
}

#pragma mark - Custom Setters

- (void)setEmptyStateImage:(UIImage *)emptyStateImage {
	_emptyStateImage = emptyStateImage;

	[self updateElements];
}

- (void)setEmptyStateDescription:(NSString *)emptyStateDescription {
	_emptyStateDescription = emptyStateDescription;

	[self updateElements];
}

@end
