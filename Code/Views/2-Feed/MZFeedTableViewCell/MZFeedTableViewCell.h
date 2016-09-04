//
//  MZFeedTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"

@interface MZFeedTableViewCell : MZTableViewCell

@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, strong) NSString *cellSubTitle;
@property (nonatomic, strong) NSURL *backgroundImageURL;

@end
