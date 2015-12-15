//
//  NSObject+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MemzAdditions)

- (id)safeCastToClass:(__unsafe_unretained Class)classType;

@end
