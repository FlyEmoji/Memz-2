//
//  MZLanguageCollectionViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguageCollectionViewCell.h"
#import "MZCollectionViewLayoutAttributes.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"
#import "MZUser+StatisticsProvider.h"

NSString * const kAnimationKey = @"MZLanguageCollectionViewCellAnimationKey";

@interface MZLanguageCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UILabel *languageTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *noDataContainerView;

@property (strong, nonatomic) IBOutlet UILabel *numberWordsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberTranslationsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberGoodAnswersLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberWordsLearnedLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageSuccessLabel;

@end

@implementation MZLanguageCollectionViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.noDataContainerView.hidden = YES;
}

#pragma mark - Custom Setter

- (void)setLanguage:(MZLanguage)language {
	_language = language;

	self.flagImageView.image = [UIImage flagImageForLanguage:language];
	self.languageTitleLabel.text = [NSString languageNameForLanguage:language].uppercaseString;

	if ([[MZUser currentUser] wordsForLanguage:language].count == 0) {
		self.noDataContainerView.hidden = NO;
		return;
	}

	self.numberWordsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatisticsNumberWordsTitle", nil),
																[[MZUser currentUser] wordsForLanguage:language].count];
	self.numberTranslationsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatisticsNumberTranslationsTitle", nil),
																			 [[MZUser currentUser] translationsForLanguage:language].count];
	self.numberGoodAnswersLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatisticsNumberGoodAnswersTitle", nil),
																			[[MZUser currentUser] successfulTranslationsForLanguage:language].count];
	self.numberWordsLearnedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatisticsNumberWordsLearnedTitle", nil),
																			 [[MZUser currentUser] wordsLearnedForLanguage:language].count];
	self.percentageSuccessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatisticsPercentageTranslationsSuccessTitle", nil),
																			[[MZUser currentUser] percentageTranslationSuccessForLanguage:language]];
}

#pragma mark - Animation

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	MZCollectionViewLayoutAttributes *attributes = [layoutAttributes safeCastToClass:[MZCollectionViewLayoutAttributes class]];
	[[self layer] addAnimation:attributes.animation forKey:kAnimationKey];
}

@end
