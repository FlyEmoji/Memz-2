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

@interface MZUser : NSManagedObject

+ (MZUser *)currentUser;

@end

NS_ASSUME_NONNULL_END

#import "MZUser+CoreDataProperties.h"
