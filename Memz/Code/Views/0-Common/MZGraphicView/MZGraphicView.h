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

@property (nonatomic, assign) IBInspectable BOOL showAverageLine;	 // Default YES

@property (nonatomic, strong) IBInspectable NSString *title;
@property (nonatomic, strong) IBInspectable UIFont *textFont;	 // Does not affect size
@property (nonatomic, strong) IBInspectable UIColor *textColor;  // Default white, subTitles and top separator line take tintColor

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *values;
@property (nonatomic, copy, readonly) NSArray<NSString *> *metrics;

- (void)transitionToValues:(NSArray<NSNumber *> *)values withMetrics:(NSArray<NSString *> *)metrics animated:(BOOL)animated;

@end
