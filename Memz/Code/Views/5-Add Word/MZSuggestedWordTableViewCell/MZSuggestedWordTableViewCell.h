//
//  MZSuggestedWordTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/25/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLanguageManager.h"

@interface MZSuggestedWordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UILabel *suggestedWordLabel;

@property (assign, nonatomic) MZLanguage language;

@end
