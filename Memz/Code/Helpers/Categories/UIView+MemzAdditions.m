//
//  UIView+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "UIView+MemzAdditions.h"

const CGFloat kCircularRadius = 0.5f;

@implementation UIView (MemzAdditions)

- (void)applyCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = (CGFloat)fmin(self.frame.size.width, self.frame.size.height) * cornerRadius;
	self.layer.masksToBounds = YES;
}

- (void)makeCircular {
	[self applyCornerRadius:kCircularRadius];
}

@end
