//
//  MZResponse.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, MZResponseResult) {
	MZResponseResultUnanswered = 0,
	MZResponseResultWrond,
	MZResponseResultLearningInProgress,
	MZResponseResultRight
};

@class MZWord;

NS_ASSUME_NONNULL_BEGIN

@interface MZResponse : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "MZResponse+CoreDataProperties.h"
