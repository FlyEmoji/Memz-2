//
//  MZQuizManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZQuiz.h"

extern NSString * const MZQuizManagerMissedQuizzesNotification;  // number of untracked missed quizzes notification
extern NSString * const MZNotificationNumberMissedQuizzesKey;  // notification key to extract number

const NSUInteger kDayMinimumQuizNumber = 1;
const NSUInteger kDayMaximumQuizNumber = 5;

@interface MZQuizManager : NSObject

@property (nonatomic, assign) NSUInteger quizPerDay;	// between kDayMinimumQuizNumber and kDayMaximumQuizNumber, default 3

@property (nonatomic, assign) NSUInteger startHour;		// defaut 8 (8am)
@property (nonatomic, assign) NSUInteger endHour;		// defaut 20 (8pm)

@property (nonatomic, assign, getter=isActive) BOOL active;	 // default YES
@property (nonatomic, assign, getter=isReversed) BOOL reversed;	 // will allow for translations both ways (randomly)

+ (MZQuizManager *)sharedManager;

- (void)scheduleQuizNotifications;
- (void)cancelQuizNotifications;

@end
