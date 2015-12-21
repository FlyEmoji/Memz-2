//
//  MZBingTranslatorCoordinator.h
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLanguageManager.h"

typedef void (^ MZBingTranslatorCompletionHandler)(NSArray<NSString *> *translations, NSError *error);

@interface MZBingTranslatorCoordinator : NSObject

+ (MZBingTranslatorCoordinator *)sharedManager;

- (void)translateString:(NSString *)stringToTranslate
					 fromLanguage:(MZLanguage)fromLanguage
						 toLanguage:(MZLanguage)toLanguage
			completionHandler:(nonnull MZBingTranslatorCompletionHandler)completionHandler;

@end


// TODO :
//  - Object for expiration
//  - Expiration issue to fix
//  - Handle concurrent calls / multiple completion handlers
//  - Fix warnings