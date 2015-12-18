//
//  MZDataManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@import DATAStack;

@interface MZDataManager : NSObject

@property (nonatomic, strong, readonly) DATAStack * dataStack;
@property (nonatomic, strong, readonly) NSManagedObjectContext * managedObjectContext;

+ (instancetype)sharedDataManager;

- (NSError *)saveChanges;
- (NSError *)rollBackChanges;

@end
