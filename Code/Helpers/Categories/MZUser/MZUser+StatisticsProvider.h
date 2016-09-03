//
//  MZUser+StatisticsProvider.h
//  Memz
//
//  Created by Bastien Falcou on 5/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZUser.h"
#import "MZWord.h"
#import "MZQuiz.h"
#import "MZResponse.h"

@interface MZUser (StatisticsProvider)

- (NSArray<MZWord *> *)wordsForLanguage:(MZLanguage)language;
- (NSArray<MZWord *> *)wordsTranslationsForLanguage:(MZLanguage)language;
- (NSArray<MZWord *> *)wordsLearnedForLanguage:(MZLanguage)language;

- (NSArray<MZQuiz *> *)quizzesForLanguage:(MZLanguage)language;

- (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language;
- (NSArray<MZResponse *> *)translationsForLanguage:(MZLanguage)language forDay:(NSDate *)date;

- (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language;
- (NSArray<MZResponse *> *)successfulTranslationsForLanguage:(MZLanguage)language forDay:(NSDate *)date;

- (CGFloat)percentageTranslationSuccessForLanguage:(MZLanguage)language;

@end
