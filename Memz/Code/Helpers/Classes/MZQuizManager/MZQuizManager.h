//
//  MZQuizManager.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZQuiz.h"

@interface MZQuizManager : NSObject

@property (nonatomic, assign) NSUInteger quizPerDay;	// Between 1 and 5, default 3

@property (nonatomic, assign, readonly) BOOL isActive;
@property (nonatomic, assign, getter=isReversed) BOOL reversed;	// Will allow for translations both ways (randomly)

+ (MZQuizManager *)sharedManager;

- (void)startManager;
- (void)stopManager;

@end
