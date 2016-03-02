//
//  MZPendingQuizTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 3/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPendingQuizTableViewCell.h"
#import "NSDate+MemzAdditions.h"

@interface MZPendingQuizTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation MZPendingQuizTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.dateLabel.hidden = self.quiz ? ![self.quiz.creationDate isToday] : YES;
}

#pragma mark - Custom Setter

- (void)setQuiz:(MZQuiz *)quiz {
	_quiz = quiz;

	self.dateLabel.hidden = ![quiz.creationDate isToday];		// TODO: Not only display TODAY but 2D, 1W, 1M..
}

@end
