//
//  MZTableView.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZTableView.h"

const CGFloat kTableViewOffsetTriggersDismiss = 50.0f;

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

	if (![self.transitionDelegate respondsToSelector:@selector(tableView:didChangeScrollOutOfBoundsPercentage:)]) {
		return;
	}

	CGFloat percentage = 0.0f;
	if (contentOffset.y < 0.0f) {
		percentage = fabs(contentOffset.y) * kTableViewOffsetTriggersDismiss / 100.0f;
	} else if (contentOffset.y > self.contentSize.height) {
		percentage = (contentOffset.y - self.contentSize.height) * kTableViewOffsetTriggersDismiss / 100.0f;
	}

	[self.transitionDelegate tableView:self didChangeScrollOutOfBoundsPercentage:percentage];
}

#pragma mark - Helpers

- (void)updateProgressiveBackgroundViewFrame {
	dispatch_async(dispatch_get_main_queue(), ^(void){
		CGRect newProgressiveBackgroundViewFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
		self.progressiveBackgroundView.frame = newProgressiveBackgroundViewFrame;
	});
}

@end
