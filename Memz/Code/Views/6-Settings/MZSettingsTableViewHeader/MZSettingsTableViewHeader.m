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

@property (weak, nonatomic) IBOutlet UIImageView *yourLanguageFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *learnedLanguageFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *yourLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnedLanguageLabel;

@end

@implementation MZSettingsTableViewHeader

#pragma mark - Custom Getters / Setters

- (void)setFromLanguage:(MZLanguage)fromLanguage {
	_fromLanguage = fromLanguage;

	self.yourLanguageFlagImageView.image = [UIImage flagImageForLanguage:fromLanguage];
	self.yourLanguageLabel.text = [NSString languageNameForLanguage:fromLanguage];
}

- (void)setToLanguage:(MZLanguage)toLanguage {
	_toLanguage = toLanguage;

	self.learnedLanguageFlagImageView.image = [UIImage flagImageForLanguage:toLanguage];
	self.learnedLanguageLabel.text = [NSString languageNameForLanguage:toLanguage];
}

// TODO: To implement calls to delegate

@end
