//
//  MZQuiz.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZLanguageDefinition.h"
#import "MZUser.h"

@class MZWord;

NS_ASSUME_NONNULL_BEGIN

@interface MZQuiz : NSManagedObject

@property (nonatomic, assign, readonly) MZLanguage fromLanguage;

+ (NSArray<NSNumber *> *)allLanguages;

+ (MZQuiz *)randomQuizForUser:(MZUser *)user;  

+ (MZQuiz *)randomQuizKnownLanguage:(MZLanguage)knownLanguage
												newLanguage:(MZLanguage)newLanguage
														forUser:(nullable MZUser *)user; 

@end

NS_ASSUME_NONNULL_END

#import "MZQuiz+CoreDataProperties.h"
