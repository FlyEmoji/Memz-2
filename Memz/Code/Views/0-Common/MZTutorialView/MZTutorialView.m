//
//  MZTutorialView.m
//  Memz
//
//  Created by Bastien Falcou on 5/22/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZTutorialView.h"
#import "MZAnimatedArrow.h"
#import "UIImage+MemzAdditions.h"

const NSTimeInterval kFadeTutorialViewDuration = 0.2;
const NSTimeInterval kTutorialViewContainerDuration = 0.2;
const NSTimeInterval kAnimatedArrowAnimationDuration = 3.0;

const CGFloat kScreenSnapshotBlurRadius = 15.0f;
const NSInteger kScreenSnapshotIterations = 4;

@interface MZTutorialView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *addWordTutorialContainerView;
@property (nonatomic, weak) IBOutlet UIView *settingsTutorialContainerView;
@property (nonatomic, weak) IBOutlet UIView *presentableViewsTutorialContainerView;

@property (nonatomic, weak) IBOutlet MZAnimatedArrow *topAnimatedArrowView;
@property (nonatomic, weak) IBOutlet MZAnimatedArrow *bottomAnimatedArrowView;


@end

@implementation MZTutorialView

#pragma mark - Public 

+ (instancetype)showInView:(UIView *)view
									withType:(MZTutorialViewType)type
									delegate:(id<MZTutorialViewProtocol>)delegate {
	MZTutorialView *tutorialView = [[MZTutorialView alloc] initWithFrame:view.frame];
	tutorialView.type = type;
	tutorialView.delegate = delegate;
	tutorialView.backgroundImageView.image = [UIImage snapshotFromView:view
																													blurRadius:kScreenSnapshotBlurRadius
																													iterations:kScreenSnapshotIterations];

	tutorialView.alpha = 0.0f;
	[view addSubview:tutorialView];

	[UIView animateWithDuration:kFadeTutorialViewDuration animations:^{
		tutorialView.alpha = 1.0f;
	} completion:^(BOOL finished) {
		[tutorialView.topAnimatedArrowView animateContinuouslyWithDirection:MZAnimatedArrowDirectionUp
																											animationDuration:kAnimatedArrowAnimationDuration];
		[tutorialView.bottomAnimatedArrowView animateContinuouslyWithDirection:MZAnimatedArrowDirectionDown
																												 animationDuration:kAnimatedArrowAnimationDuration];
	}];
	return tutorialView;
}

- (void)dismiss {
	[UIView animateWithDuration:kFadeTutorialViewDuration animations:^{
		self.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
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
										 self.presentableViewsTutorialContainerView.alpha = type == MZTutorialViewTypePresentableView ? 1.0f : 0.0f;
									 }];
}

#pragma mark - Gesture Recognizer Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if ([self.delegate respondsToSelector:@selector(tutorialView:didRequestDismissForType:)]) {
		[self.delegate tutorialView:self didRequestDismissForType:self.type];
	}
}

@end
