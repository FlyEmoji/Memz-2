//
//  MZArticleAddAllTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"

@protocol MZArticleAddAllTableViewCellDelegate;

@interface MZArticleAddAllTableViewCell : MZTableViewCell

@property (nonatomic, weak) id<MZArticleAddAllTableViewCellDelegate> delegate;

@end

@protocol MZArticleAddAllTableViewCellDelegate <NSObject>

@optional

- (void)articleAddAllTableViewCellDidTap:(MZArticleAddAllTableViewCell *)cell;

@end
