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

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *pageWidthConstraint;
@property (nonatomic, strong) NSTimer *swipeTimer;

// First page: information
@property (strong, nonatomic) IBOutlet UIView *statusPendingPage;
@property (nonatomic, strong) IBOutlet UILabel *numberPendingQuizzesLabel;
@property (nonatomic, strong) IBOutlet UILabel *pendingQuizDescriptionLabel;
@property (nonatomic, strong) IBOutlet UIButton *createNewQuizButton;

// Second page: statistics
@property (strong, nonatomic) IBOutlet UIView *statisticsPage;

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

	UITapGestureRecognizer *statisticsTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																																																	 action:@selector(didTapStatisticsPage:)];
	[self.statisticsPage addGestureRecognizer:statisticsTapGestureRecognizer];
}

- (void)didTapStatisticsPage:(UITapGestureRecognizer *)tapGestureRecognizer {
	if ([self.delegate respondsToSelector:@selector(quizInfoViewDidRequestStatistics:)]) {
		[self.delegate quizInfoViewDidRequestStatistics:self];
	}
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

#pragma mark - Actions

- (IBAction)didTapRequestNewQuizButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(quizInfoViewDidRequestNewQuiz:)]) {
		[self.delegate quizInfoViewDidRequestNewQuiz:self];
	}
}

@end
