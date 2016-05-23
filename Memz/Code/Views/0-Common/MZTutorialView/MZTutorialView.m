//
//  MZTutorialView.m
//  Memz
//
//  Created by Bastien Falcou on 5/22/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZTutorialView.h"

const NSTimeInterval kTutorialViewContainerDuration = 0.2;

@interface MZTutorialView ()

@property (weak, nonatomic) IBOutlet UIView *addWordTutorialContainerView;
@property (weak, nonatomic) IBOutlet UIView *settingsTutorialContainerView;

@end

@implementation MZTutorialView

- (void)awakeFromNib {
	[super awakeFromNib];

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																																											action:@selector(didTapView:)];
	[self addGestureRecognizer:gestureRecognizer];
}

- (void)didTapView:(UITapGestureRecognizer *)gestureRecognizer {
	if ([self.delegate respondsToSelector:@selector(tutorialView:didRequestDismissForType:)]) {
		[self.delegate tutorialView:self didRequestDismissForType:self.type];
	}
}

#pragma mark - Custom Getters & Setters

- (void)setType:(MZTutorialViewType)type {
	[self setType:type animated:NO];
}

- (void)setType:(MZTutorialViewType)type animated:(BOOL)animated {
	_type = type;

	[UIView animateWithDuration:animated ? kTutorialViewContainerDuration : 0.0
									 animations:^{
										 self.addWordTutorialContainerView.alpha = type == MZTutorialViewTypeAddWord ? 1.0f : 0.0f;
										 self.settingsTutorialContainerView.alpha = type == MZTutorialViewTypeSettings ? 1.0f : 0.0f;
									 }];
}

@end
