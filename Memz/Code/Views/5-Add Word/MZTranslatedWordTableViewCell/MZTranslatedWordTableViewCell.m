//
//  MZTranslatedWordTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZTranslatedWordTableViewCell.h"

@implementation MZTranslatedWordTableViewCell

- (IBAction)didTapRemoveButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(translatedWordTableViewCellDidTapRemoveButton:)]) {
		[self.delegate translatedWordTableViewCellDidTapRemoveButton:self];
	}
}

@end
