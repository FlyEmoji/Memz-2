//
//  MZWordDescriptionTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"

@interface MZWordDescriptionTableViewCell : MZTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UILabel *wordLabel;

@end
