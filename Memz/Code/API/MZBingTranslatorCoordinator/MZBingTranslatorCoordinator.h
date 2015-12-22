//
//  MZBingTranslatorCoordinator.h
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBingTranslationWrapper.h"
#import "MZLanguageManager.h"

@interface MZBingTranslatorCoordinator : NSObject

+ (MZBingTranslatorCoordinator *)sharedManager;

- (void)translateString:(NSString *)stringToTranslate
					 fromLanguage:(MZLanguage)fromLanguage
						 toLanguage:(MZLanguage)toLanguage
			completionHandler:(nonnull MZBingTranslationCompletionHandler)completionHandler;

@end


// TODO :
//  - Fix warnings