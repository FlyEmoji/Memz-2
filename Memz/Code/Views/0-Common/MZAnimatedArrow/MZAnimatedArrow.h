//
//  MZAnimatedArrow.h
//  Memz
//
//  Created by Bastien Falcou on 5/23/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

typedef NS_ENUM(NSInteger, MZAnimatedArrowDirection) {
	MZAnimatedArrowDirectionUp = 0,
	MZAnimatedArrowDirectionDown
};

@interface MZAnimatedArrow : UIView

@property (nonatomic, strong) IBInspectable UIColor *arrowColor;  // default black

- (void)animateContinuouslyWithDirection:(MZAnimatedArrowDirection)direction
											 animationDuration:(NSTimeInterval)animationDuration;
- (void)stopAnimation;

@end
