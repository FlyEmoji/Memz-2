//
//  MZCountDown.h
//  Memz
//
//  Created by Bastien Falcou on 12/29/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MZCountDownDelegate;

@interface MZCountDown : NSObject

@property (nonatomic, weak) id<MZCountDownDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign, readonly) NSTimeInterval remainingTime;

+ (instancetype)countDownWithDuration:(NSTimeInterval)duration delegate:(id<MZCountDownDelegate>)delegate;
- (instancetype)initWithDuration:(NSTimeInterval)duration delegate:(id<MZCountDownDelegate>)delegate;

- (void)fire;
- (void)invalidate;

@end

@protocol MZCountDownDelegate <NSObject>

@optional

- (void)countDownDidChange:(MZCountDown *)countDown remainingTime:(NSTimeInterval)remainingTime totalTime:(NSTimeInterval)totalTime;
- (void)countDownDidEnd:(MZCountDown *)countDown;

@end
