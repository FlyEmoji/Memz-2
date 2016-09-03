//
//  Configurations.m
//  Memz
//
//  Created by Bastien Falcou on 5/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "Configurations.h"

#if DEBUG
NSString * const MZSegmentToken = @"Y24rfqCbuUWtuP5uQnhbGr8foM9Rsipe";
#elif SNAPSHOT
NSString * const MZSegmentToken = @"Y24rfqCbuUWtuP5uQnhbGr8foM9Rsipe";
#elif PRODUCTION
NSString * const MZSegmentToken = @"EMCAdThjAGa6mYPiewkPzfvTAcErlgpT";
#else
#endif