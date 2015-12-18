//
//  UIColor+MemzColors.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "UIColor+MemzColors.h"

// This file shouldn't be modified in any way. Please use MemzColors.items.h instead.

#define MZCOLORA(name,r,g,b,a) \
+ (UIColor *)name { \
static UIColor * color; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
color = [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]; \
}); \
return color; \
}

#define MZCOLOR(name,r,g,b) MZCOLORA(name,r,g,b, 1.0f)

@implementation UIColor (MemzColors)

#include "MemzColors.items.h"

@end