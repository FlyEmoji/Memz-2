//
//  UIScrollView+EthanolKeyboardHelper.h
//  Memz
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZKeyboardNotificationBehavior;

@interface UIScrollView (KeyboardHelper)

/**
 *  Add observers for keyboard appearance and keyboard disappearance with the default notification block.
 *  The default block handles everything for you in term of keyboard management when a UITextField is selected.
 */
- (void)handleKeyboardNotifications;

/**
 *  Add observers for keyboard appearance and keyboard disappearance with the default notification block.
 *  The default block handles everything for you in term of keyboard management when a UITextField is selected.
 *  This method also adds a inset to the keyboard notifications
 */
- (void)handleKeyboardNotificationsWithOffset:(CGFloat)keyboardOffset;

/**
 *  Get the default block implementation used with -handleKeyboardNotfications.
 *
 *  @return The default block. Is never nil.
 */
@property (nonatomic, copy, readonly) MZKeyboardNotificationBlock defaultKeyboardNotificationBlock;

@end
