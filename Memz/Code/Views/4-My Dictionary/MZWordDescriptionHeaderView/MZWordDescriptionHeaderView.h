//
//  MZWordDescriptionHeaderView.h
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZWord.h"

@protocol MZWordDescriptionHeaderViewDelegate;

@interface MZWordDescriptionHeaderView : UIView

@property (nonatomic, weak) id<MZWordDescriptionHeaderViewDelegate> delegate;
@property (nonatomic, strong) MZWord *word;

@end

@protocol MZWordDescriptionHeaderViewDelegate <NSObject>

@optional

- (void)wordDescriptionHeaderViewDidStartEditing:(MZWordDescriptionHeaderView *)headerView;
- (void)wordDescriptionHeaderViewDidStopEditing:(MZWordDescriptionHeaderView *)headerView;

@end