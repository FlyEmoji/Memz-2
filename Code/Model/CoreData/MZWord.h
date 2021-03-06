//
//  MZWord.h
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord : NSManagedObject

/*
 * Creates or Updates existing word if needed
 */
+ (MZWord *)addWord:(NSString *)word
				 inLanguage:(MZLanguage)wordLanguage
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
											 inLanguage:(MZLanguage)language
												inContext:(nullable NSManagedObjectContext *)context;

/*
 * Updates existing word (adds new translations, remove no longer needed ones)
 */
- (void)updateTranslations:(NSArray<NSString *> *)translations
								inLanguage:(MZLanguage)language
									 forUser:(nullable MZUser *)user
								 inContext:(nullable NSManagedObjectContext *)context;

/*
 * Number of translations
 */
- (NSUInteger)numberTranslationsInLanguage:(MZLanguage)language;

/*
 * Number of times word has been translated in quizzes
 */
- (NSUInteger)numberQuizTranslationsInLanguage:(MZLanguage)language;

/*
 * Number of times word has been successfully translated in quizzes
 */
- (CGFloat)percentageSuccessQuizTranslationsInLanguage:(MZLanguage)language;

@end

NS_ASSUME_NONNULL_END

#import "MZWord+CoreDataProperties.h"
