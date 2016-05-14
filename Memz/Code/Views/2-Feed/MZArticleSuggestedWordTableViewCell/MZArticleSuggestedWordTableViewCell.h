//
//  MZArticleSuggestedWordTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 3/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"
#import "MZWord.h"

@protocol MZArticleSuggestedWordTableViewCellDelegate;

@interface MZArticleSuggestedWordTableViewCell : MZTableViewCell

@property (nonatomic, strong) MZWord *word;
@property (nonatomic, weak) id<MZArticleSuggestedWordTableViewCellDelegate> delegate;

- (void)forceUpdate;

@end

@protocol MZArticleSuggestedWordTableViewCellDelegate <NSObject>

@optional

- (void)articleSuggestedWordTableViewCellDidTap:(MZArticleSuggestedWordTableViewCell *)cell;

@end