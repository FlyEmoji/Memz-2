//
//  MZLanguageManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MZLanguage) {
	MZLanguageEnglish,
	MZLanguageFrench
};

@interface MZLanguageManager : NSObject

+ (MZLanguageManager *)sharedManager;

@property (nonatomic, assign) MZLanguage fromLanguage;
@property (nonatomic, assign) MZLanguage toLanguage;

@property (nonatomic, weak, readonly) NSArray<NSNumber *> *allLanguages;

@end
