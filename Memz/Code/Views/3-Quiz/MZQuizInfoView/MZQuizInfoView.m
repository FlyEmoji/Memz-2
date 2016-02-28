//
//  MZQuizInfoView.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZQuizInfoView.h"
#import "UIView+MemzAdditions.h"

@interface MZQuizInfoView ()

@property (nonatomic, strong) IBOutlet UIButton *createNewQuizButton;

@end

@implementation MZQuizInfoView

#pragma mark - Actions

- (IBAction)didTapRequestNewQuizButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(quizInfoViewDidRequestNewQuiz:)]) {
		[self.delegate quizInfoViewDidRequestNewQuiz:self];
	}
}

@end
