//
//  MZPageControl.h
//  Ethanol
//
//  Created by Bastien Falcou on 1/9/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/* Custom implementation of native UIPageControl allowing for a lot of features often needed, that would be tricky/hacky
 * to implement with this native control.
 *
 * This class implements all public UIPageControl methods/functions in order to allow for injection.
 */

@interface MZPageControl : UIView

@property (nonatomic, assign) IBInspectable NSInteger numberOfPages;
@property (nonatomic, assign) IBInspectable NSInteger currentPage;

@property (nonatomic, assign) IBInspectable CGFloat dotsSpace;	// default 6.0f
@property (nonatomic, assign) IBInspectable BOOL hidesForSinglePage;  // default NO

@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL defersCurrentPageDisplay;  // defers updating current page until call updateCurrentPageDisplay

@property (nonatomic, strong) IBInspectable UIImage *leftDotImageInactive;  // take middle dot if nil
@property (nonatomic, strong) IBInspectable UIImage *middleDotImageInactive;
@property (nonatomic, strong) IBInspectable UIImage *rightDotImageInactive;  // take middle dot if nil

@property (nonatomic, strong) IBInspectable UIImage *leftDotImageActive;  // take middle dot if nil
@property (nonatomic, strong) IBInspectable UIImage *middleDotImageActive;
@property (nonatomic, strong) IBInspectable UIImage *rightDotImageActive;  // take middle dot if nil

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;  // minimum size needed to display dots for given page count

- (void)updateCurrentPageDisplay;  // updates the page indicator to currentPage

@end