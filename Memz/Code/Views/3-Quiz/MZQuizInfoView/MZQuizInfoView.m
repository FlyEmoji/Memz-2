//
//  MZQuizInfoView.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizInfoView.h"
#import "UIView+MemzAdditions.h"

NSTimeInterval const kAutomaticSwipeScrollViewDelay = 5.0;

@interface MZQuizInfoView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *pageWidthConstraint;
@property (nonatomic, strong) NSTimer *swipeTimer;

// First page: information
@property (nonatomic, weak) IBOutlet UILabel *numberPendingQuizzesLabel;
@property (nonatomic, weak) IBOutlet UILabel *pendingQuizDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *createNewQuizButton;

// Second page: statistics

// Third page: to be decided

@end

@implementation MZQuizInfoView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.numberPendingQuizzesLabel makeCircular];
	self.pageWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;

	self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:kAutomaticSwipeScrollViewDelay
																										 target:self
																									 selector:@selector(swipeToNextPage:)
																									 userInfo:nil
																										repeats:YES];
}

- (void)dealloc {
	[self.swipeTimer invalidate];
}

#pragma mark - Automatic Scroll

- (void)swipeToNextPage:(NSTimer *)timer {
	NSUInteger nextPage = fabs(self.scrollView.contentOffset.x) / self.frame.size.width + 1;
	NSUInteger numberOfPages = self.scrollView.contentSize.width / self.frame.size.width;

	if (nextPage >= numberOfPages) {
		nextPage = 0;
	}

	CGPoint newContentOffset = CGPointMake(nextPage * self.scrollView.frame.size.width, self.scrollView.contentOffset.y);
	[self.scrollView setContentOffset:newContentOffset animated:YES];
}

@end
