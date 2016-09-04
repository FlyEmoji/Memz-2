//
//  MZWordDescriptionViewController.h
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPresentableViewController.h"
#import "MZWord.h"

@interface MZWordDescriptionViewController : MZPresentableViewController

@property (nonatomic, strong) MZWord *word;

@end
