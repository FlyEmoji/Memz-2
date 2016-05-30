//
//  MZUser.h
//  
//
//  Created by Bastien Falcou on 5/1/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZQuiz, MZWord;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MZUserDidAuthenticateNotification;

@interface MZUser : NSManagedObject

+ (MZUser *)currentUser;

+ (MZUser *)signUpUserKnownLanguage:(MZLanguage)knownLanguage
												newLanguage:(MZLanguage)newLanguage;

- (MZWord *)addWord:(NSString *)word
			 translations:(NSArray<NSString *> *)translations
					inContext:(nullable NSManagedObjectContext *)context;

- (void)addPendingQuizzesForCreationDates:(NSArray<NSDate *> *)quizzesDates;

@end

NS_ASSUME_NONNULL_END

#import "MZUser+CoreDataProperties.h"
