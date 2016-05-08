//
//  NSArray+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 5/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MemzAdditions)

- (NSArray<NSString *> *)allLowercaseStrings;
+ (NSArray<NSString *> *)removeDuplicatesCaseInsensitiveWithArray:(NSArray<NSString *> *)array;

@end
