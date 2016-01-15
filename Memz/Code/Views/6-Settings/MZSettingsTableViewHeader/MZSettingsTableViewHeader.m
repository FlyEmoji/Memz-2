//
//  MZSettingsTableViewHeader.m
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsTableViewHeader.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"

@interface MZSettingsTableViewHeader ()

@property (weak, nonatomic) IBOutlet UIButton *yourLanguageFlagButton;
@property (weak, nonatomic) IBOutlet UIButton *learnedLanguageFlagButton;
@property (weak, nonatomic) IBOutlet UILabel *yourLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnedLanguageLabel;

@end

@implementation MZSettingsTableViewHeader

#pragma mark - Custom Getters / Setters

- (void)setFromLanguage:(MZLanguage)fromLanguage {
	_fromLanguage = fromLanguage;

	[self.yourLanguageFlagButton setImage:[UIImage flagImageForLanguage:fromLanguage] forState:UIControlStateNormal];
	self.yourLanguageLabel.text = [NSString languageNameForLanguage:fromLanguage];
}

- (void)setToLanguage:(MZLanguage)toLanguage {
	_toLanguage = toLanguage;

	[self.learnedLanguageFlagButton setImage:[UIImage flagImageForLanguage:toLanguage] forState:UIControlStateNormal];
	self.learnedLanguageLabel.text = [NSString languageNameForLanguage:toLanguage];
}

- (IBAction)didTapYourLanguageFlagButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(settingsTableViewHeaderDidRequestChangeFromLanguage:)]) {
		[self.delegate settingsTableViewHeaderDidRequestChangeFromLanguage:self];
	}
}

- (IBAction)didTapLearnedLanguageButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(settingsTableViewHeaderDidRequestChangeToLanguage:)]) {
		[self.delegate settingsTableViewHeaderDidRequestChangeToLanguage:self];
	}
}

@end
