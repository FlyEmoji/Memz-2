//
//  MZWord.h
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZLanguageDefinition.h"
#import "MZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord : NSManagedObject

/*
 * Creates or Updates existing word if needed
 */
+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage
						forUser:(nullable MZUser *)user
					inContext:(nullable NSManagedObjectContext *)context;

/*
 * Returns an ordered set of existing words starting by specified string
 */
+ (NSOrderedSet<MZWord *> *)existingWordsForLanguage:(MZLanguage)language
																		startingByString:(NSString *)string
																					 inContext:(nullable NSManagedObjectContext *)context;

/*
 * Returns existing word if matches exactly string and language
 */
+ (MZWord *)existingWordForString:(NSString *)string
										 fromLanguage:(MZLanguage)fromLanguage
												inContext:(nullable NSManagedObjectContext *)context;

/*
 * Updates existing word (adds new translations, remove no longer needed ones)
 */
- (void)updateTranslations:(NSArray<NSString *> *)translations
								toLanguage:(MZLanguage)toLanguage
									 forUser:(nullable MZUser *)user
								 inContext:(nullable NSManagedObjectContext *)context;

- (NSUInteger)numberTranslationsToLanguage:(MZLanguage)toLanguage;

- (CGFloat)percentageSuccessTranslationsToLanguage:(MZLanguage)toLanguage;

@end

NS_ASSUME_NONNULL_END

#import "MZWord+CoreDataProperties.h"
