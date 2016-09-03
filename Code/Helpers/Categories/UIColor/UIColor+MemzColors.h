//
//  UIColor+MemzColors.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

// This file shouldn't be modified in any way. Please use MemzColors.items.h instead.

#define MZCOLORA(name,r,g,b,a) \
+ (UIColor *)name;
#define MZCOLOR(name,r,g,b) MZCOLORA(name,r,g,b, 1.0f)

@interface UIColor (MemzColors)

#include "MemzColors.items.h"

@end

#undef MZCOLOR
#undef MZCOLORA
