//
//  CADisplayLink+MemzBlocks.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^ MZDisplayLinkTriggeredBlock)(CADisplayLink * displayLink);

@interface CADisplayLink (MemzBlocks)

+ (CADisplayLink *)displayLinkWithBlock:(MZDisplayLinkTriggeredBlock)block;

@end
