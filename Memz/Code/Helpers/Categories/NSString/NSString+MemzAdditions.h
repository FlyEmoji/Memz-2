//
//  NSString+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/21/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLanguageManager.h"

@interface NSString (MemzAdditions)

+ (NSString *)urlEncodedStringFromString:(NSString *)original;
+ (NSString *)stringForDuration:(NSTimeInterval)duration;
+ (NSString *)languageNameForLanguage:(MZLanguage)language;

@end
