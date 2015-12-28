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

@property (nonatomic, assign) NSUInteger quizPerDay;
@property (nonatomic, assign, readonly) BOOL isActive;

+ (MZQuizManager *)sharedManager;

- (void)startManager;
- (void)stopManager;

- (MZQuizz *)generateQuiz;

@end
