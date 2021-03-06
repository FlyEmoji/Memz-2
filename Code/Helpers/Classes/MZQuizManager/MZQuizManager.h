//
//  MZQuizManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZQuiz.h"

const NSUInteger kDayMinimumQuizNumber = 1;
const NSUInteger kDayMaximumQuizNumber = 20;

@interface MZQuizManager : NSObject

@property (nonatomic, assign) NSUInteger quizPerDay;  // between kDayMinimumQuizNumber and kDayMaximumQuizNumber, default 5

@property (nonatomic, assign) NSUInteger startHour;	 // defaut 8 (8am)
@property (nonatomic, assign) NSUInteger endHour;	 // defaut 20 (8pm)

@property (nonatomic, assign, getter=isActive) BOOL active;	 // default YES

@property (nonatomic, weak, readonly) NSArray<NSDate *> *datesMissedQuizzes; // connected user unanswered quiz dates since last app session

+ (MZQuizManager *)sharedManager;

- (void)scheduleQuizNotifications;
- (void)cancelQuizNotifications;

@end
