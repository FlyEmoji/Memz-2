//
//  MZDataManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;
@import DATAStack;

@interface MZDataManager : NSObject

@property (nonatomic, strong, readonly, nonnull) DATAStack *dataStack;
@property (nonatomic, weak, readonly) NSManagedObjectContext *managedObjectContext;

+ (nonnull instancetype)sharedDataManager;

- (void)saveChangesWithCompletionHandler:(void (^ __nullable)(void))completionHandler;
- (void)rollBackChanges;

@end
