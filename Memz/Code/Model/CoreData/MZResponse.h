//
//  MZResponse.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MZResponseComparator.h"

@class MZWord;

NS_ASSUME_NONNULL_BEGIN

@interface MZResponse : NSManagedObject

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations delegate:(id<MZResponseComparatorDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

#import "MZResponse+CoreDataProperties.h"
