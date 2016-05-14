//
//  Configurations.m
//  Memz
//
//  Created by Bastien Falcou on 5/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "Configurations.h"

#if DEBUG
NSString * const MVMixpanelToken = @"";
#elif SNAPSHOT
NSString * const MVMixpanelToken = @"";
#elif PRODUCTION
NSString * const MVMixpanelToken = @"";
#else
#endif