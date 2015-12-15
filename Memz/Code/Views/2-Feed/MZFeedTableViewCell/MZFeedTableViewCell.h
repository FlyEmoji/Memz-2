//
//  MZFeedTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZFeedTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cellTitle;
@property (nonatomic, weak) IBOutlet UILabel *cellSubTitle;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@end
