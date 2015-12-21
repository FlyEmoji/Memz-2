//
//  MZBingTranslatorCoordinator.h
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBingTranslatorCoordinator : NSObject

+ (MZBingTranslatorCoordinator *)sharedManager;

- (void)clearAccessToken;		// TODO: Same
- (void)getAccessTokenWithCompletionHandler:(nonnull void (^)(NSError *error))completionHandler;		// TODO: Should be private

@end
