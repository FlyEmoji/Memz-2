//
//  MZCountDown.m
//  Memz
//
//  Created by Bastien Falcou on 12/29/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZCountDown.h"

#pragma mark - CountDown Declaration

@interface MZCountDown ()

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSTimeInterval totalTime;

- (void)countDownTimerDidFire:(NSTimer *)timer;

@end

#pragma mark - CountDown Target Reference Declaration & Implementation

/*
 * The CountDown object keeps initiating an NSTimer, itself keeping a strong reference on the CountDown.
 * Subsequently, the CountDown won't be released until it reaches its end (remainingTime == 0), even if
 * there is no other object keeping a reference on the CountDown.
 *
 * In order to avoid that and allow our CountDown to be dealloced when deferenced, we create a weak target
 * reference for our NSTimer.
 */

@interface MVWeakCountDownTargetReference : NSObject

@property (nonatomic, weak) MZCountDown *countDown;

@end

@implementation MVWeakCountDownTargetReference

- (void)countDownTimerDidFire:(NSTimer *)timer {
	[self.countDown countDownTimerDidFire:timer];
}

@end

#pragma mark - CountDown Implementation

@implementation MZCountDown

- (void)dealloc {
	[self.countDownTimer invalidate];
}

#pragma mark - Initializers

- (instancetype)initWithDuration:(NSTimeInterval)duration delegate:(id<MZCountDownDelegate>)delegate {
	if (self = [super init]) {
		_remainingTime = duration;
		_totalTime = duration;
		_delegate = delegate;
	}
	return self;
}

+ (instancetype)countDownWithDuration:(NSTimeInterval)duration delegate:(id<MZCountDownDelegate>)delegate {
	return [[[self class] alloc] initWithDuration:duration delegate:delegate];
}

- (void)fire {
	[self elapseOneSecondFire:YES];
}

- (void)invalidate {
	_isRunning = NO;
	[self.countDownTimer invalidate];

	if ([self.delegate respondsToSelector:@selector(countDownDidEnd:)]) {
		[self.delegate countDownDidEnd:self];
	}
}

#pragma mark - Remaining Time

- (void)elapseOneSecondFire:(BOOL)fire {
	MVWeakCountDownTargetReference *reference = [[MVWeakCountDownTargetReference alloc] init];
	reference.countDown = self;

	[self.countDownTimer invalidate];
	self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
																												 target:reference
																											 selector:@selector(countDownTimerDidFire:)
																											 userInfo:nil
																												repeats:NO];
	if (fire) {
		[self.countDownTimer fire];
	}
}

- (void)countDownTimerDidFire:(NSTimer *)timer {
	if ([self.delegate respondsToSelector:@selector(countDownDidChange:remainingTime:totalTime:)]) {
		[self.delegate countDownDidChange:self remainingTime:self.remainingTime totalTime:self.totalTime];
	}

	_isRunning = YES;

	if (self.remainingTime <= 0.0) {
		[timer invalidate];

		if ([self.delegate respondsToSelector:@selector(countDownDidEnd:)]) {
			[self.delegate countDownDidEnd:self];
		}
	} else {
		_remainingTime = self.remainingTime - 1.0;
		[self elapseOneSecondFire:NO];
	}
}

@end
