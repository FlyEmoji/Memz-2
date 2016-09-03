//
//  MZAnsweredQuizTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"
#import "MZQuiz.h"

@interface MZAnsweredQuizTableViewCell : MZTableViewCell

@property (nonatomic, strong) MZQuiz *quiz;

@end
