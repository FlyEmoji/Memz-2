//
//  MZArticleSuggestedWordTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZArticleSuggestedWordTableViewCell.h"

@interface MZArticleSuggestedWordTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutlet UILabel *wordTranslation;
@property (nonatomic, strong) IBOutlet UIButton *leftButton;

@end

@implementation MZArticleSuggestedWordTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	[self updateUI];
}

- (void)updateUI {
	self.wordLabel.text = self.word.word.uppercaseString;
	self.wordTranslation.text = self.word.translations.allObjects.firstObject.word.capitalizedString;

	if ([MZWord existingWordForString:self.word.word fromLanguage:self.word.language.integerValue inContext:nil]) {  // TODO: check in user object instead
		[self.leftButton setImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierFeedActiveTick]
										 forState:UIControlStateNormal];
	} else {
		[self.leftButton setImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierCommonTick]
										 forState:UIControlStateNormal];
	}
}

#pragma mark - Custom Setter

- (void)setWord:(MZWord *)word {
	_word = word;

	[self updateUI];
}

#pragma mark - Actions

- (IBAction)didTapButton:(UIButton *)sender {
	if ([self.delegate respondsToSelector:@selector(articleSuggestedWordTableViewCellDidTap:)]) {
		[self.delegate articleSuggestedWordTableViewCellDidTap:self];
	}
}

@end
