//
//  MZMyQuizzesTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZMyQuizzesTableViewCell.h"
#import "NSDate+MemzAdditions.h"
#import "UIVIew+MemzAdditions.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"
#import "MZResponse.h"

@interface MZMyQuizzesTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *isAnsweredLabel;

@property (nonatomic, strong) IBOutlet UIImageView *fromLanguageFlagImageView;
@property (nonatomic, strong) IBOutlet UIImageView *toLanguageFlagImageView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *statusIndicatorViews;

@end

@implementation MZMyQuizzesTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.statusIndicatorViews = [self.statusIndicatorViews sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
		if (view1.frame.origin.y < view2.frame.origin.y) return NSOrderedAscending;
		else if (view1.frame.origin.y > view2.frame.origin.y) return NSOrderedDescending;
		else return NSOrderedSame;
	}];

	for (UIView *statusIndicator in self.statusIndicatorViews) {
		[statusIndicator makeCircular];
	}
}

#pragma mark - Custom Setters

- (void)setQuiz:(MZQuiz *)quiz {
	_quiz = quiz;

	self.dateLabel.text = [quiz.date humanReadableDateString];
	self.isAnsweredLabel.text = quiz.isAnswered.boolValue ? NSLocalizedString(@"QuizResponseIsAnswered", nil) : NSLocalizedString(@"QuizResponsePending", nil);
	self.contentView.backgroundColor = quiz.isAnswered ? [UIColor myQuizzesAnsweredBackgroundColor] : [UIColor myQuizzesPendingBackgroundColor];

	self.fromLanguageFlagImageView.image = [UIImage flagImageForLanguage:quiz.fromLanguage];
	self.toLanguageFlagImageView.image = [UIImage flagImageForLanguage:quiz.toLanguage.integerValue];

	NSArray<MZResponse *> *responsesArray = quiz.responses.allObjects;

	for (NSUInteger i = 0; i < self.statusIndicatorViews.count; i++) {
		UIColor *color = [UIColor lightGrayColor];

		if (quiz.responses.count > i) {
			color = responsesArray[i].result.boolValue ? [UIColor wordDescriptionLearnedStatusColor] : [UIColor wordDescriptionNotLearedColor];
		}
		[(UIView *)self.statusIndicatorViews[i] setBackgroundColor:color];
	}
}

@end
