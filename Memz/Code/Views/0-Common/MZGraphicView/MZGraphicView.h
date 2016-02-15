//
//  MZGraphicView.h
//  Memz
//
//  Created by Bastien Falcou on 2/6/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZNibView.h"

typedef NS_ENUM(NSUInteger, MZGraphYOriginType) {
	MZGraphYOriginTypeAutomatic = 0,	// chooses best fit between Zero and MinimumValue for optimal display, default value
	MZGraphYOriginTypeZero,						// y origin will always be zero
	MZGraphYOriginTypeMinimumValue		// y origin will be minimum value in the list
};

IB_DESIGNABLE

@interface MZGraphicView : MZNibView

@property (nonatomic, strong) IBInspectable UIColor *gradientStartColor;	// default iOS yellow to red colors
@property (nonatomic, strong) IBInspectable UIColor *gradientEndColor;
@property (nonatomic, strong) IBInspectable UIColor *gradientUnderGraphStartColor;  // TODO: Should be generated

@property (nonatomic, assign) IBInspectable BOOL showAverageLine;	 // default YES

@property (nonatomic, strong) IBInspectable NSString *title;
@property (nonatomic, strong) IBInspectable UIFont *textFont;	 // does not affect text size
@property (nonatomic, strong) IBInspectable UIColor *textColor;  // default white, subTitles and top separator line take tintColor

@property (nonatomic, assign) MZGraphYOriginType yOriginType;

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *values;
@property (nonatomic, copy, readonly) NSArray<NSString *> *metrics;

- (void)transitionToValues:(NSArray<NSNumber *> *)values withMetrics:(NSArray<NSString *> *)metrics animated:(BOOL)animated;

@end
