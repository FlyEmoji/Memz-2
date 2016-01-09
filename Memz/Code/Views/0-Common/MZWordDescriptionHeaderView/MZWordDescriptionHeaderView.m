//
//  MZWordDescriptionHeaderView.m
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordDescriptionHeaderView.h"
#import "UIVIew+MemzAdditions.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"

const CGFloat kCountDownDefaultBottomSeparatorConstraint = 8.0f;
const CGFloat kCountDownSectionHeightConstraint = 35.0f;

@interface MZWordDescriptionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *learnedStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *learnedStatusView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTranslationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageSuccessLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownSectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownBottomSeparatorConstraint;

@property (assign, nonatomic) BOOL isEditing;

@end

@implementation MZWordDescriptionHeaderView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.learnedStatusView makeCircular];
}

- (void)setWord:(MZWord *)word {
	_word = word;

	// (1) Update Center View
	self.wordLabel.text = word.word;
	self.flagImageView.image = [UIImage flagImageForLanguage:self.word.language.integerValue];

	// (2) Update Status (Left)
	if (word.learningIndex.integerValue == MZWordIndexLearned) {
		self.learnedStatusView.backgroundColor = [UIColor wordDescriptionLearnedStatusColor];
		self.learnedStatusLabel.text = NSLocalizedString(@"WordDescriptionLearned", nil);
	} else if (word.learningIndex.integerValue >= trunc(MZWordIndexLearned / 2.0f)) {
		self.learnedStatusView.backgroundColor = [UIColor wordDescriptionLearningInProgressColor];
		self.learnedStatusLabel.text = NSLocalizedString(@"WordDescriptionLearningInProgressStatus", nil);
	} else {
		self.learnedStatusView.backgroundColor = [UIColor wordDescriptionNotLearedColor];
		self.learnedStatusLabel.text = NSLocalizedString(@"WordDescriptionNotLearnedStatus", nil);
	}

	// (3) Update Statistics (Right)
	NSUInteger numberTranslations = [self.word numberTranslationsToLanguage:[MZLanguageManager sharedManager].toLanguage];
	CGFloat percentageSuccess = [self.word percentageSuccessTranslationsToLanguage:[MZLanguageManager sharedManager].toLanguage];
	NSString *numberOfTranslationsString, *percentageSuccessString;

	if (numberTranslations == 0) {
		numberOfTranslationsString = NSLocalizedString(@"WordDescriptionNeverTranslated", nil);
		percentageSuccessString = [[NSString alloc] init];
	} else if (numberTranslations == 1) {
		numberOfTranslationsString = NSLocalizedString(@"WordDescriptionTranslatedOnce", nil);
		percentageSuccessString = [NSString stringWithFormat:NSLocalizedString(@"WordDescriptionPercentageSuccess", nil), percentageSuccess];
	} else {
		numberOfTranslationsString = [NSString stringWithFormat:NSLocalizedString(@"WordDescriptionTranslatedTimes", nil), numberTranslations];
		percentageSuccessString = [NSString stringWithFormat:NSLocalizedString(@"WordDescriptionPercentageSuccess", nil), percentageSuccess];
	}

	self.numberOfTranslationsLabel.text = numberOfTranslationsString;
	self.percentageSuccessLabel.text = percentageSuccessString;
}

- (void)setHeaderType:(MZWordDescriptionHeaderType)headerType {
	_headerType = headerType;

	switch (headerType) {
		case MZWordDescriptionHeaderTypeReadonly:
			self.countDownBottomSeparatorConstraint.constant = kCountDownDefaultBottomSeparatorConstraint;
			self.countDownSectionHeightConstraint.constant = kCountDownSectionHeightConstraint;
			self.editButton.hidden = YES;
			break;
		case MZWordDescriptionHeaderTypeEdit:
			self.countDownBottomSeparatorConstraint.constant = 0.0f;
			self.countDownSectionHeightConstraint.constant = 0.0f;
			self.editButton.hidden = NO;
			break;
	}
	[self layoutIfNeeded];
}

- (void)setCountDownRemainingTime:(NSTimeInterval)countDownRemainingTime {
	_countDownRemainingTime = countDownRemainingTime;

	self.countDownLabel.text = [NSString stringForDuration:countDownRemainingTime];
}

#pragma mark - Edition 

- (void)setIsEditing:(BOOL)isEditing {
	_isEditing = isEditing;

	if (isEditing) {
		[self.editButton setTitle:NSLocalizedString(@"CommonDone", nil) forState:UIControlStateNormal];
		if ([self.delegate respondsToSelector:@selector(wordDescriptionHeaderViewDidStartEditing:)]) {
			[self.delegate wordDescriptionHeaderViewDidStartEditing:self];
		}
	} else {
		[self.editButton setTitle:NSLocalizedString(@"CommonEdit", nil) forState:UIControlStateNormal];
		if ([self.delegate respondsToSelector:@selector(wordDescriptionHeaderViewDidStopEditing:)]) {
			[self.delegate wordDescriptionHeaderViewDidStopEditing:self];
		}
	}
}

#pragma mark - Actions

- (IBAction)editButtonTapped:(id)sender {
	self.isEditing = !self.isEditing;
}

@end
