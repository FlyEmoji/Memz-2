//
//  MZRemoteServerCoordinator.h
//  Memz
//
//  Created by Bastien Falcou on 3/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Will in the long run implement the actual api calls, when api will be ready.
 * Fakes for now those calls, providing with an interface that should not change regardless what is actually
 * happening insed this coordinator.
 */
@interface MZRemoteServerCoordinator : NSObject

+ (void)fetchFeedWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error))completionHandler;

@end
