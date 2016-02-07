//
//  MZGraphicView.h
//  Memz
//
//  Created by Bastien Falcou on 2/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZNibView.h"

IB_DESIGNABLE

@interface MZGraphicView : MZNibView

@property (nonatomic, strong) IBInspectable UIColor *gradientStartColor;	// Default iOS yellow to red colors
@property (nonatomic, strong) IBInspectable UIColor *gradientEndColor;
@property (nonatomic, strong) IBInspectable UIColor *gradientUnderGraphStartColor;

@property (nonatomic, strong) NSArray<NSNumber *> *values;

@end
