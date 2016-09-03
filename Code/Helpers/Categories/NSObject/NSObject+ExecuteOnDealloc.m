//
//  NSObject+ExecuteOnDealloc.m
//  Memz
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+ExecuteOnDealloc.h"

static char MZInternalDeallocExecuterKey;

@interface MZInternalDeallocExecuter : NSObject

@property (nonatomic, copy) MZPerformOnDeallocBlock deallocBlock;
@property (nonatomic, unsafe_unretained) id object;

@end

@implementation MZInternalDeallocExecuter

- (void)dealloc {
  if (_deallocBlock != nil) {
    _deallocBlock(_object);
  }
}

@end

@implementation NSObject (ExecuteOnDealloc)

- (void)performBlockOnDealloc:(MZPerformOnDeallocBlock)deallocBlock {
  MZInternalDeallocExecuter *deallocExecuter = objc_getAssociatedObject(self, &MZInternalDeallocExecuterKey);

  if (deallocExecuter == nil && deallocBlock != nil) {
    deallocExecuter = [[MZInternalDeallocExecuter alloc] init];
    deallocExecuter.object = self;
    deallocExecuter.deallocBlock = deallocBlock;
    objc_setAssociatedObject(self, &MZInternalDeallocExecuterKey, deallocExecuter, OBJC_ASSOCIATION_RETAIN);
  } else if (deallocExecuter != nil) {
    deallocExecuter.deallocBlock = deallocBlock;
  } else if(deallocBlock == nil) {
    deallocExecuter.deallocBlock = nil;
    objc_setAssociatedObject(self, &MZInternalDeallocExecuterKey, nil, OBJC_ASSOCIATION_ASSIGN);
  }
}

@end
