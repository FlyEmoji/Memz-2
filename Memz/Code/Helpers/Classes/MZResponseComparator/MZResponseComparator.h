//
//  MZResponseComparator.h
//  Memz
//
//  Created by Bastien Falcou on 1/3/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZResponse;
@class MZWord;

typedef NS_ENUM(NSUInteger, MZResponseResult) {
	MZResponseResultUnanswered = 0,
	MZResponseResultWrond,
	MZResponseResultLearningInProgress,
	MZResponseResultRight
};

@protocol MZResponseComparatorDelegate;

@interface MZResponseComparator : NSObject

@property (nonatomic, strong) id<MZResponseComparatorDelegate> delegate;
@property (nonatomic, strong, readonly) MZResponse *response;

- (instancetype)initWithResponse:(MZResponse *)response;
+ (instancetype)responseComparatorWithResponse:(MZResponse *)response;

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations;

@end

@protocol MZResponseComparatorDelegate <NSObject>

@optional

- (void)responseComparator:(MZResponseComparator *)response didCheckTranslation:(NSString *)translation correctWithWord:(MZWord *)correction;

@end