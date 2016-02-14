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
@property (nonatomic, strong) IBInspectable UIColor *gradientUnderGraphStartColor;  // TODO: Should be generated

@property (nonatomic, assign) IBInspectable BOOL showAverage;	 // Default YES

@property (nonatomic, strong) IBInspectable UIFont *textFont;	 // Does not affect size
@property (nonatomic, strong) IBInspectable UIColor *textColor;  // Default white

@property (nonatomic, strong) NSArray<NSNumber *> *values;

@end
