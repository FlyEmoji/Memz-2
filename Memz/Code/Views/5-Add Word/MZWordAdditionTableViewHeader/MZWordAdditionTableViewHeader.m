//
//  MZWordAdditionTableViewHeader.m
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordAdditionTableViewHeader.h"

@interface MZWordAdditionTableViewHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation MZWordAdditionTableViewHeader

- (void)awakeFromNib {
	[super awakeFromNib];

	self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	self.backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
	return self.backgroundView.backgroundColor;
}

- (void)setSectionType:(MZWordAdditionSectionType)sectionType {
	_sectionType = sectionType;

	self.clearButton.hidden = sectionType != MZWordAdditionSectionTypeTranslations;

	switch (sectionType) {
		case MZWordAdditionSectionTypeWord:
			self.headerTitle.text = NSLocalizedString(@"WordAdditionYourWordTitle", nil);
			break;
		case MZWordAdditionSectionTypeSuggestions:
			self.headerTitle.text = NSLocalizedString(@"WordAdditionSuggestedTranslationsTitle", nil);
			break;
		case MZWordAdditionSectionTypeTranslations:
			self.headerTitle.text = NSLocalizedString(@"WordAdditionCustomTranslationTitle", nil);
			break;
		case MZWordAdditionSectionTypeManual:
			self.headerTitle.text = NSLocalizedString(@"WordAdditionYourTranslationsTitle", nil);
			break;
	}
}

- (IBAction)clearButtonTapped:(id)sender {
	if ([self.delegate respondsToSelector:@selector(wordAdditionTableViewHeaderDidTapClearButton:)]) {
		[self.delegate wordAdditionTableViewHeaderDidTapClearButton:self];
	}
}

@end
