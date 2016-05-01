//
//  MZWordAdditionViewHeader.h
//  Memz
//
//  Created by Bastien Falcou on 5/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZWordAdditionViewHeaderProtocol;

@interface MZWordAdditionViewHeader : UIView

@property (nonatomic, weak) id<MZWordAdditionViewHeaderProtocol> delegate;
@property (nonatomic, assign, getter=isEnabled) BOOL enable;  // controls add button enabled

@end

@protocol MZWordAdditionViewHeaderProtocol <NSObject>

- (void)wordAdditionViewHeaderDidTapAddButton:(MZWordAdditionViewHeader *)header;

@end
