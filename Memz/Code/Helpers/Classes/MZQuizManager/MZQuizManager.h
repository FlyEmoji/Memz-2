//
//  MZQuizManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZQuizz.h"

@interface MZQuizManager : NSObject

@property (nonatomic, assign) NSUInteger quizPerDay;	// Between 1 and 5, default 3

@property (nonatomic, assign) NSUInteger startTimeHour;		// Default 8am
@property (nonatomic, assign) NSUInteger stopTimeHour;	 // Default 8pm

@property (nonatomic, assign, readonly) BOOL isActive;

+ (MZQuizManager *)sharedManager;

- (void)startManager;
- (void)stopManager;

- (MZQuizz *)generateQuiz;

@end
