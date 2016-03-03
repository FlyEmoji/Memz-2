//
//  MZWordStatusView.m
//  Memz
//
//  Created by Bastien Falcou on 3/2/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZWordStatusView.h"
#import "UIView+MemzAdditions.h"

NSString * const kColorChangeAnimationKey = @"MZColorChangeAnimationKey";

@interface MZWordStatusView ()

@property (nonatomic, strong) IBOutlet UIView *statusView;

@property (nonatomic, strong) CABasicAnimation *animation;

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

	[self startLightening];
}

#pragma mark - Private Color Continuous Change Animation

- (void)startLightening {		// TODO: Should be triggered in sync, every two seconds
	[self stopLightening];

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = @(1.0f);
	animation.toValue = @(0.3f);
	animation.repeatCount = HUGE_VAL;
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

	[self.statusView.layer addAnimation:animation forKey:kColorChangeAnimationKey];
}

- (void)stopLightening {
	[self.statusView.layer removeAnimationForKey:kColorChangeAnimationKey];
}

@end
