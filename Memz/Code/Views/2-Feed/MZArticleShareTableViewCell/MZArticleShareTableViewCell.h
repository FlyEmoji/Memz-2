//
//  MZArticleShareTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZShareManager.h"
#import "MZTableViewCell.h"

@protocol MZArticleShareTableViewCellDelegate;

@interface MZArticleShareTableViewCell : MZTableViewCell

@property (nonatomic, weak) id<MZArticleShareTableViewCellDelegate> delegate;

@end

@protocol MZArticleShareTableViewCellDelegate <NSObject>

@optional

- (void)articleShareTableViewCell:(MZArticleShareTableViewCell *)cell
								didTapShareOption:(MZShareOption)shareOption;

@end