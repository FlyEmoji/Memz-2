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
const NSUInteger kDayMaximumQuizNumber = 5;

@interface MZQuizManager : NSObject

@property (nonatomic, assign) NSUInteger quizPerDay;	// Between 1 and 5, default 3

@property (nonatomic, assign) NSUInteger startHour;		// Defaut 8 (8am)
@property (nonatomic, assign) NSUInteger endHour;		// Defaut 20 (8pm)

@property (nonatomic, assign, getter=isActive) BOOL active;	 // Default YES
@property (nonatomic, assign, getter=isReversed) BOOL reversed;	 // Will allow for translations both ways (randomly)

+ (MZQuizManager *)sharedManager;

- (void)scheduleQuizNotifications;
- (void)cancelQuizNotifications;

@end
