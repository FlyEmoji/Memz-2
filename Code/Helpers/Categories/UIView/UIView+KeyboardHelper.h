//
//  UIView+EthanolKeyboardHelper.h
//  Memz
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ MZKeyboardNotificationBlock)(BOOL show, CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, UIViewAnimationOptions options);

@interface UIView (KeyboardHelper)

/**
 *  Helper method that tells you if the keyboard is currently shown or not.
 *
 *  @return YES if the keyboard is shown, NO otherwise.
 */
+ (BOOL)isKeyboardShown;

/**
 *  Add observers for keyboard appearance and keyboard disappearance with a custom notification block.
 *
 *  @param handlerBlock The block which will be called when handling the keyboard notifications
 */
- (void)handleKeyboardNotificationsWithBlock:(MZKeyboardNotificationBlock)handlerBlock;

/**
 *  Get the block called when the show/hide keyboard notification is sent.
 */
@property (nonatomic, strong, setter=setKeyboardNotificationBlock:) MZKeyboardNotificationBlock keyboardNotificationBlock;

/**
 *  Get the displayed keyboard size. The size is CGSizeZero if the keyboard is not displayed.
 */
@property (nonatomic, assign, setter=setKeyboardSize:) CGSize keyboardSize;

@end
