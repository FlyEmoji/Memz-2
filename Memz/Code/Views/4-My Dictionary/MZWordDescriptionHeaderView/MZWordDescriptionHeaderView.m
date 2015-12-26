//
//  MZWordDescriptionHeaderView.m
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordDescriptionHeaderView.h"
#import "UIVIew+MemzAdditions.h"

@interface MZWordDescriptionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnedStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *learnedStatusView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTranslationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageSuccessLabel;

@end

@implementation MZWordDescriptionHeaderView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.learnedStatusView makeCircular];
}

- (void)setWord:(MZWord *)word {
	_word = word;

	self.wordLabel.text = word.word;
}

@end
