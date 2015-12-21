//
//  MZBingTranslatorCoordinator.h
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLanguageManager.h"

@interface MZBingTranslatorCoordinator : NSObject

+ (MZBingTranslatorCoordinator *)sharedManager;

- (void)translateString:(NSString *)stringToTranslate
					 fromLanguage:(MZLanguage)fromLanguage
						 toLanguage:(MZLanguage)toLanguage
			completionHandler:(nonnull void (^)(NSArray<NSString *> *translations, NSError *error))completionHandler;

@end
