//
//  MZMyDictionaryTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyDictionaryTableViewCell.h"

@interface MZMyDictionaryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *countTranslationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *translationsLabel;

@end

@implementation MZMyDictionaryTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.wordLabel.text = @"";
	self.translationsLabel.text = @"";
	self.countTranslationsLabel.text = @"";
}

- (void)setupTranslations:(NSArray<MZWord *> *)translations {
	self.translationsLabel.text = @"";
	[translations enumerateObjectsUsingBlock:^(MZWord *translation, NSUInteger idx, BOOL *stop) {
		self.translationsLabel.text = [self.translationsLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ - ", translation.word]];
	}];

	self.countTranslationsLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)translations.count, NSLocalizedString(@" translations", nil)];
}

@end
