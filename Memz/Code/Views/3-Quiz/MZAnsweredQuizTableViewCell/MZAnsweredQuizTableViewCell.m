//
//  MZAnsweredQuizTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZAnsweredQuizTableViewCell.h"
#import "NSDate+MemzAdditions.h"
#import "UIVIew+MemzAdditions.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"
#import "MZResponse.h"

@interface MZAnsweredQuizTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *isAnsweredLabel;

@end

@implementation MZAnsweredQuizTableViewCell

#pragma mark - Custom Setters

- (void)setQuiz:(MZQuiz *)quiz {
	_quiz = quiz;

	self.dateLabel.text = [quiz.date relativeOrAbsoluteDateString].uppercaseString;
	self.isAnsweredLabel.text = quiz.isAnswered.boolValue ? NSLocalizedString(@"QuizResponseIsAnswered", nil) : NSLocalizedString(@"QuizResponsePending", nil);
}

@end
