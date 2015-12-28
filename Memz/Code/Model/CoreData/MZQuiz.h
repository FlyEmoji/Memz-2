//
//  MZQuiz.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZWord;

NS_ASSUME_NONNULL_BEGIN

@interface MZQuiz : NSManagedObject

+ (MZQuiz *)generateRandomQuiz;

@end

NS_ASSUME_NONNULL_END

#import "MZQuiz+CoreDataProperties.h"
