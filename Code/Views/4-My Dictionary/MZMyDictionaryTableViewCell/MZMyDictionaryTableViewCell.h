//
//  MZMyDictionaryTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZWordStatusView.h"
#import "MZTableViewCell.h"
#import "MZWord+CoreDataProperties.h"

@interface MZMyDictionaryTableViewCell : MZTableViewCell

@property (nonatomic, strong) MZWord *word;

@end
