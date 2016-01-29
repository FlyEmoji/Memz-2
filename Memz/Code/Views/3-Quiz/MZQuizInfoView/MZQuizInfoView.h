//
//  MZQuizInfoView.h
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZNibView.h"

@protocol MZQuizInfoViewDelegate;

@interface MZQuizInfoView : MZNibView

@property (nonatomic, weak) id<MZQuizInfoViewDelegate> delegate;

@end

@protocol MZQuizInfoViewDelegate <NSObject>

- (void)quizInfoViewDidRequestNewQuiz:(MZQuizInfoView *)quizInfoView;
- (void)quizInfoViewDidRequestStatistics:(MZQuizInfoView *)quizInfoView;

@end
