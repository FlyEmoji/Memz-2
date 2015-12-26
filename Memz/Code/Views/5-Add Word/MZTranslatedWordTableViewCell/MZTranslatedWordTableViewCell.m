//
//  MZTranslatedWordTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTranslatedWordTableViewCell.h"
#import "UIImage+MemzAdditions.h"

@interface MZTranslatedWordTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@end

@implementation MZTranslatedWordTableViewCell

- (void)setLanguage:(MZLanguage)language {
	_language = language;

	self.flagImageView.image = [UIImage flagImageForLanguage:language];
}

- (IBAction)didTapRemoveButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(translatedWordTableViewCellDidTapRemoveButton:)]) {
		[self.delegate translatedWordTableViewCellDidTapRemoveButton:self];
	}
}

@end
