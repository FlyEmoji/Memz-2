//
//  MZPendingQuizTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 3/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"
#import "MZQuiz.h"

@interface MZPendingQuizTableViewCell : MZTableViewCell

@property (nonatomic, strong) MZQuiz *quiz;

@end
