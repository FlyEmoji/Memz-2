//
//  MZDataManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZDataBackgroundTaskWrapper.h"

@import CoreData;
@import DATAStack;

@interface MZDataManager : NSObject

@property (nonatomic, strong, readonly) DATAStack *dataStack;
@property (nonatomic, weak, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedDataManager;

- (void)saveChangesWithCompletionHandler:(void(^)(void))completionHandler;

- (void)saveChangesInBackground:(NSManagedObjectContext *)backgroundContext
							completionHandler:(MZDataTaskCompletionBlock)completionHandler;

- (void)rollBackChanges;

@end
