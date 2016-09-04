//
//  MZWordStatusView.h
//  Memz
//
//  Created by Bastien Falcou on 3/2/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZNibView.h"
#import "MZWord.h"

@interface MZWordStatusView : MZNibView

@property (nonatomic, strong) MZWord *word;

@end
