//
//  MZWord.h
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord : NSManagedObject

+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage;

+ (NSOrderedSet<MZWord *> *)existingWordsForLanguage:(MZLanguage)language
																		startingByString:(NSString *)string;

- (void)updateTranslations:(NSArray<NSString *> *)translations
								toLanguage:(MZLanguage)toLanguage;

@end

NS_ASSUME_NONNULL_END

#import "MZWord+CoreDataProperties.h"
