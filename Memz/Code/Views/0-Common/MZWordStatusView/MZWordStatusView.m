//
//  MZWordStatusView.m
//  Memz
//
//  Created by Bastien Falcou on 3/2/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZWordStatusView.h"
#import "UIView+MemzAdditions.h"

@interface MZWordStatusView ()

@property (strong, nonatomic) IBOutlet UIView *statusView;

@end

@implementation MZWordStatusView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.statusView makeCircular];
}

#pragma mark - Custom Setter

- (void)setWord:(MZWord *)word {
	_word = word;

	if (word.learningIndex.integerValue == MZWordIndexLearned) {
		self.statusView.backgroundColor = [UIColor wordDescriptionLearnedStatusColor];
	} else if (word.learningIndex.integerValue >= trunc(MZWordIndexLearned / 2.0f)) {
		self.statusView.backgroundColor = [UIColor wordDescriptionLearningInProgressColor];
	} else {
		self.statusView.backgroundColor = [UIColor wordDescriptionNotLearedColor];
	}

	[self.statusView startGlowing];
}

@end
