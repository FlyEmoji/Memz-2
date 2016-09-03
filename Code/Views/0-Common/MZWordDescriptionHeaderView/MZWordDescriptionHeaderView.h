//
//  MZWordDescriptionHeaderView.h
//  Memz
//
//  Created by Bastien Falcou on 12/26/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZNibView.h"
#import "MZWord.h"

typedef NS_ENUM(NSUInteger, MZWordDescriptionHeaderType) {
	MZWordDescriptionHeaderTypeReadonly = 0,
	MZWordDescriptionHeaderTypeEdit
};

@protocol MZWordDescriptionHeaderViewDelegate;

@interface MZWordDescriptionHeaderView : MZNibView

@property (nonatomic, weak) IBOutlet id<MZWordDescriptionHeaderViewDelegate> delegate;

@property (nonatomic, strong) MZWord *word;
@property (nonatomic, assign) MZWordDescriptionHeaderType headerType;
@property (nonatomic, assign) NSTimeInterval countDownRemainingTime;

@end

@protocol MZWordDescriptionHeaderViewDelegate <NSObject>

@optional

- (void)wordDescriptionHeaderViewDidStartEditing:(MZWordDescriptionHeaderView *)headerView;
- (void)wordDescriptionHeaderViewDidStopEditing:(MZWordDescriptionHeaderView *)headerView;

@end