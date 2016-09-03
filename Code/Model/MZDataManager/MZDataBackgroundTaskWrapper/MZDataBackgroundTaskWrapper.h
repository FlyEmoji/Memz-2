//
//  MZDataBackgroundTaskWrapper.h
//  Memz
//
//  Created by Bastien Falcou on 3/7/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ MZDataTaskCompletionBlock)(NSError *error);

@interface MZDataBackgroundTaskWrapper : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, copy) MZDataTaskCompletionBlock completionBlock;

+ (instancetype)dataBackgroundTaskWithContext:(NSManagedObjectContext *)context
															completionBlock:(MZDataTaskCompletionBlock)completionBlock;

- (instancetype)initWithContext:(NSManagedObjectContext *)context
								completionBlock:(MZDataTaskCompletionBlock)completionBlock;

@end
