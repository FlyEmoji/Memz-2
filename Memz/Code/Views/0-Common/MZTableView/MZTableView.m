//
//  MZTableView.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZTableView.h"

const CGFloat kTableViewOffsetTriggersDismiss = 70.0f;

@interface MZTableView ()

@property (nonatomic, strong) UIView *progressiveBackgroundView;

@end

@implementation MZTableView

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	if (self = [super initWithFrame:frame style:style]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	// (1) Create and add progressive background view at bottom most level
	CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
	self.progressiveBackgroundView = [[UIView alloc] initWithFrame:frame];
	[self insertSubview:self.progressiveBackgroundView atIndex:0];

	// (2) Configure default color
	self.progressiveBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
	self.progressiveBackgroundView.backgroundColor = self.progressiveBackgroundColor;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[self updateProgressiveBackgroundViewFrame];
}

#pragma mark - Custom Getters/Setters

- (UIColor *)progressiveBackgroundColor {
	return self.progressiveBackgroundView.backgroundColor;
}

- (void)setProgressiveBackgroundColor:(UIColor *)progressiveBackgroundColor {
	self.progressiveBackgroundView.backgroundColor = progressiveBackgroundColor;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];

	[self updateProgressiveBackgroundViewFrame];
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[super setContentOffset:contentOffset];

	if (![self.transitionDelegate respondsToSelector:@selector(tableView:didChangeScrollOutOfBoundsPercentage:goingUp:)]) {
		return;
	}

	CGFloat percentage = 0.0f;
	if (contentOffset.y < 0.0f) {
		percentage = fabs(contentOffset.y) / kTableViewOffsetTriggersDismiss;
	} else if (self.frame.size.height + contentOffset.y >= self.contentSize.height) {
		// If actual content size height smaller than frame, consider frame instead (progressive background height)
		CGFloat actualContentSize = fmaxf(self.contentSize.height, self.frame.size.height);
		CGFloat distanceFromBottom = self.frame.size.height + contentOffset.y - actualContentSize;
		percentage = distanceFromBottom / kTableViewOffsetTriggersDismiss;
	}

	[self.transitionDelegate tableView:self didChangeScrollOutOfBoundsPercentage:fabs(percentage) goingUp:contentOffset.y > 0.0f];
}

#pragma mark - Helpers

- (void)updateProgressiveBackgroundViewFrame {
	dispatch_async(dispatch_get_main_queue(), ^(void){
		CGRect newProgressiveBackgroundViewFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
		self.progressiveBackgroundView.frame = newProgressiveBackgroundViewFrame;
	});
}

@end
