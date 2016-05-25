//
//  MZEmptyStateView.h
//  Memz
//
//  Created by Bastien Falcou on 5/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"

IB_DESIGNABLE

@protocol MZEmptyStateViewProtocol;

@interface MZEmptyStateView : MZNibView

@property (nonatomic, weak) IBOutlet id<MZEmptyStateViewProtocol> delegate;

@property (nonatomic, strong) IBInspectable UIImage *emptyStateImage;
@property (nonatomic, strong) IBInspectable NSString *emptyStateDescription;
@property (nonatomic, strong) IBInspectable NSString *suggestionButtonDescription;

@end

@protocol MZEmptyStateViewProtocol <NSObject>

@optional

- (void)emptyStateViewDidTapSuggestionButton:(MZEmptyStateView *)view;

@end