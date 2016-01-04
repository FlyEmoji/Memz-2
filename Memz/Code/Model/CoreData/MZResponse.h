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

@protocol MZResponseResultDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MZResponse : NSManagedObject

@property (nonatomic, copy) id<MZResponseResultDelegate> delegate;

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations;		// TODO: Implement object "MZResponseComparator" and pass delegate

@end

@protocol MZResponseResultDelegate <NSObject>

@optional

- (void)responseResult:(MZResponse *)response didCheckTranslation:(NSString *)translation correctWithWord:(MZWord *)correction;

@end

NS_ASSUME_NONNULL_END

#import "MZResponse+CoreDataProperties.h"
