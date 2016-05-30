//
//  MZMyDictionaryTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyDictionaryTableViewCell.h"

@interface MZMyDictionaryTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutlet UILabel *countTranslationsLabel;
@property (nonatomic, strong) IBOutlet MZWordStatusView *wordStatusView;

@end

@implementation MZMyDictionaryTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.wordLabel.text = @"";
	self.countTranslationsLabel.text = @"";
}

#pragma mark - Custom Setter

- (void)setWord:(MZWord *)word {
	_word = word;

	self.wordLabel.text = word.word.uppercaseString;
	self.wordStatusView.word = word;
	self.countTranslationsLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)[word numberTranslationsInLanguage:[MZUser currentUser].knownLanguage.integerValue], NSLocalizedString(@" translations", nil)];
}

@end
