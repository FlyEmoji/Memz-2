//
//  MZStatisticsProvider.h
//  Memz
//
//  Created by Bastien Falcou on 2/2/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZWord.h"

@interface MZStatisticsProvider : NSObject

+ (NSArray<MZWord *> *)wordsForLanguage:(MZLanguage)language;
+ (NSArray<MZWord *> *)wordsTranslationsForLanguage:(MZLanguage)language;

+ (NSArray<MZQuiz *> *)quizzesForLanguage:(MZLanguage)language;

+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language;
+ (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language forDay:(NSDate *)date;

+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language;
+ (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language forDay:(NSDate *)date;

@end
