//
//  MZSuggestedWordTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/25/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZSuggestedWordTableViewCell.h"
#import "UIImage+MemzAdditions.h"

@interface MZSuggestedWordTableViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;

@end

@implementation MZSuggestedWordTableViewCell

- (void)setLanguage:(MZLanguage)language {
	_language = language;

	self.flagImageView.image = [UIImage flagImageForLanguage:language];
}

@end
