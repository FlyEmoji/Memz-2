//
//  CADisplayLink+MemzBlocks.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <objc/runtime.h>
#import "CADisplayLink+MemzBlocks.h"

static char kDisplayLinkBlockKey;

@implementation CADisplayLink (MemzBlocks)

+ (CADisplayLink *)displayLinkWithBlock:(MZDisplayLinkTriggeredBlock)block {
	objc_setAssociatedObject(self, &kDisplayLinkBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	return [self displayLinkWithTarget:self selector:@selector(displayLinkTriggered:)];
}

+ (void)displayLinkTriggered:(CADisplayLink *)displayLink {
	MZDisplayLinkTriggeredBlock block = objc_getAssociatedObject(self, &kDisplayLinkBlockKey);
	if (block != nil) {
		block(displayLink);
	} else {
		[displayLink invalidate];
	}
}

@end
