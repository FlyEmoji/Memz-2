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

@property (nonatomic, strong) IBOutlet UIButton *yourLanguageFlagButton;
@property (nonatomic, strong) IBOutlet UIButton *learnedLanguageFlagButton;
@property (nonatomic, strong) IBOutlet UILabel *yourLanguageLabel;
@property (nonatomic, strong) IBOutlet UILabel *learnedLanguageLabel;

@end

@implementation MZSettingsTableViewHeader

#pragma mark - Custom Getters / Setters

- (void)setKnownLanguage:(MZLanguage)knownLanguage {
	_knownLanguage = knownLanguage;

	[self.yourLanguageFlagButton setImage:[UIImage flagImageForLanguage:knownLanguage] forState:UIControlStateNormal];
	self.yourLanguageLabel.text = [NSString languageNameForLanguage:knownLanguage].uppercaseString;
}

- (void)setNewLanguage:(MZLanguage)newLanguage {
	_newLanguage = newLanguage;

	[self.learnedLanguageFlagButton setImage:[UIImage flagImageForLanguage:newLanguage] forState:UIControlStateNormal];
	self.learnedLanguageLabel.text = [NSString languageNameForLanguage:newLanguage].uppercaseString;
}

- (CGRect)knownLanguageFlagFrame {
	return self.yourLanguageFlagButton.frame;
}

- (CGRect)newLanguageFlagFrame {
	return self.learnedLanguageFlagButton.frame;
}

#pragma mark - Actions

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
