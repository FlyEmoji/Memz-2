//
//  MZPullViewControllerTransition.h
//  Memz
//
//  Created by Bastien Falcou on 1/16/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MZPullViewControllerTransitionDirection) {
	MZPullViewControllerTransitionDown = 0,
	MZPullViewControllerTransitionUp
};

@protocol MZPullViewControllerTransitionDelegate;

@interface MZPullViewControllerTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) id<MZPullViewControllerTransitionDelegate> delegate;
@property (nonatomic, assign) MZPullViewControllerTransitionDirection transitionDirection;

- (instancetype)initWithTransitionDirection:(MZPullViewControllerTransitionDirection)transitionDirection;

@end

@protocol MZPullViewControllerTransitionDelegate <NSObject>

@optional

- (void)pullViewControllerTransitionDidFinish:(MZPullViewControllerTransition *)transition;

@end
