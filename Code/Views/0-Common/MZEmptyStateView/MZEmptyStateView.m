//
//  MZEmptyStateView.m
//  Memz
//
//  Created by Bastien Falcou on 5/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZEmptyStateView.h"
#import "UIFont+MemzAdditions.h"
#import "UILabel+MemzAdditions.h"

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
	[self.emptyStateButton setTitle:self.suggestionButtonDescription forState:UIControlStateNormal];

	self.emptyStateLabel.text = self.emptyStateDescription;
	[self.emptyStateLabel applyParagraphStyle];
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
