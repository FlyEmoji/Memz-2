//
//  MZQuiz.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZBingTranslatorCoordinator.h"
#import "MZUser.h"

@class MZWord;

NS_ASSUME_NONNULL_BEGIN

@interface MZQuiz : NSManagedObject

+ (NSArray<NSNumber *> *)allLanguages;

+ (MZQuiz *)randomQuizForUser:(MZUser *)user
								 creationDate:(nullable NSDate *)creationDate;  // default creation current date

+ (MZQuiz *)randomQuizKnownLanguage:(MZLanguage)knownLanguage
												newLanguage:(MZLanguage)newLanguage
														forUser:(nullable MZUser *)user
											 creationDate:(nullable NSDate *)creationDate;  // default creation current date

@end

NS_ASSUME_NONNULL_END

#import "MZQuiz+CoreDataProperties.h"
