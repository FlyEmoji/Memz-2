//
//  MZQuizViewController.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZQuizz.h"
#import "MZResponse.h"

typedef void (^ MZQuizCompletionBlock)(void);

@interface MZQuizViewController : UIViewController

+ (void)askQuiz:(MZQuizz *)quizz fromViewController:(UIViewController *)fromViewController completionBlock:(void (^)(void))completionBlock;

@property (nonatomic, strong) MZResponse *response;
@property (nonatomic, copy) MZQuizCompletionBlock didGiveTranslationResponse;

@end
