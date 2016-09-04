//
//  NSObject+ExecuteOnDealloc.h
//  Memz
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ MZPerformOnDeallocBlock)(id object);

@interface NSObject (EthanolExecuteOnDealloc)

/**
 *  Perform a block on when an object is dealloc'd.
 *  The object passed as an argument is the object that is being dealloc'd.
 *  This argument is unsafe_unretained, and in case it means that sending any messages to this object might crash.
 *  This is mainly useful to remove any observers this object may be attached to (KVO/NotificationCenter/etc)
 *
 *  @param deallocBlock Return block to execute on dealloc.
 */
- (void)performBlockOnDealloc:(MZPerformOnDeallocBlock)deallocBlock;

@end
