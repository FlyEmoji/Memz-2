//
//  MZTableView.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <objc/runtime.h>
#import "MZTableView.h"
#import "MZProtocolInterceptor.h"

const CGFloat kTableViewOffsetTriggersDismiss = 70.0f;

/* Progressive Background View is not the only advantage this subclass provides. Indeed, it also allows to
 * intercept scroll view delegate methods and perform custom operations before being forwarded to the actual
 * delegate. This behavior is handled at runtime, perfectly encapsulated (hidden to the outside world), and
 * finally (and very importantly) safely implemented.
 */

@interface MZTableView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *progressiveBackgroundView;
@property (nonatomic, strong) MZProtocolInterceptor *protocolInterceptor;

@property (nonatomic, assign) BOOL didStartScrollingOutOfBounds;
@property (nonatomic, assign, readonly) BOOL isScrollingOutOfBoundsUp;

@end

@implementation MZTableView

#pragma mark - Initializers 

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

	// (3) Configure protocol interceptor to handle scroll events and forward them
	self.protocolInterceptor = [[MZProtocolInterceptor alloc] initWithInterceptedProtocol:objc_getProtocol("UIScrollViewDelegate")];
	self.protocolInterceptor.middleMan = self;
}

#pragma mrak - Other Overriden Methods

- (void)awakeFromNib {
	[super awakeFromNib];

	[self updateProgressiveBackgroundViewFrame];
}

- (void)dealloc {
	self.protocolInterceptor = nil;
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

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
	self.protocolInterceptor.receiver = delegate;
	[super setDelegate:(id)self.protocolInterceptor];
}

- (id<UITableViewDelegate>)delegate {
	return self.protocolInterceptor.receiver;
}

- (CGFloat)percentageOutOfBounds {
	CGFloat percentage = 0.0f;

	if (self.contentOffset.y < 0.0f) {
		percentage = fabs(self.contentOffset.y) / kTableViewOffsetTriggersDismiss;
	} else if (self.frame.size.height + self.contentOffset.y >= self.contentSize.height) {
		// If actual content size height smaller than frame, consider frame instead (progressive background height)
		CGFloat actualContentSize = fmaxf(self.contentSize.height, self.frame.size.height);
		CGFloat distanceFromBottom = self.frame.size.height + self.contentOffset.y - actualContentSize;
		percentage = distanceFromBottom / kTableViewOffsetTriggersDismiss;
	}

	return percentage;
}

- (BOOL)isScrollingOutOfBoundsUp {
	return self.contentOffset.y > 0.0f;
}

#pragma mark - Intercepted Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// (1) Calculation of scroll out of bounds arbitrary percentage
	CGFloat percentage = self.percentageOutOfBounds;

	// (2) Notifiy transition delegate for start if needed
	if (percentage > 0.0f && !self.didStartScrollingOutOfBounds) {
		self.didStartScrollingOutOfBounds = YES;
		if ([self.transitionDelegate respondsToSelector:@selector(tableViewDidStartScrollOutOfBounds:)]) {
			[self.transitionDelegate tableViewDidStartScrollOutOfBounds:self];
		}
	}

	// (3) Notifiy transition delegate for scroll update if needed
	if (percentage > 0.0f && self.didStartScrollingOutOfBounds) {
		if ([self.transitionDelegate respondsToSelector:@selector(tableView:didScrollOutOfBoundsPercentage:goingUp:)]) {
			[self.transitionDelegate tableView:self didScrollOutOfBoundsPercentage:percentage goingUp:self.isScrollingOutOfBoundsUp];
		}
	}

	// (4) Update internal states if needed
	if (percentage <= 0.0f) {
		self.didStartScrollingOutOfBounds = NO;
	}

	// (5) Forward intercepted scroll event to potential actual delegate
	if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[self.delegate scrollViewDidScroll:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	// (1) This is an intercepted scroll event, start to check if transitionDelegate set
	if (![self.transitionDelegate respondsToSelector:@selector(tableView:didEndScrollOutOfBoundsPercentage:goingUp:)]) {
		return;
	}

	// (2) Calculation of scroll out of bounds arbitrary percentage
	CGFloat percentage = self.percentageOutOfBounds;

	// (3) Notifiy transition delegate
	[self.transitionDelegate tableView:self didEndScrollOutOfBoundsPercentage:fabs(percentage) goingUp:self.isScrollingOutOfBoundsUp];

	// (4) Forward intercepted scroll event to potential actual delegate
	if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		[self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	}
}

#pragma mark - Helpers

- (void)updateProgressiveBackgroundViewFrame {
	dispatch_async(dispatch_get_main_queue(), ^(void){
		CGRect newProgressiveBackgroundViewFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
		self.progressiveBackgroundView.frame = newProgressiveBackgroundViewFrame;
	});
}

@end
