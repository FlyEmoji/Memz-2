//
//  UIScrollView+EthanolKeyboardHelper.m
//  Ethanol
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+KeyboardHelper.h"
#import "UIView+KeyboardHelper.h"

static char defaultKeyboardNotificationBlockKey;
static char scrollViewBottomInsetOffsetKey;
static char scrollViewIndicatorBottomInsetOffsetKey;
static char savedOffsetKey;
static char keyboardScrollOffsetKey;

@implementation UIScrollView (EthanolKeyboardHelper)

- (void)handleKeyboardNotifications {
  [self handleKeyboardNotificationsWithBlock:[self defaultKeyboardNotificationBlock]];
}

- (void)handleKeyboardNotificationsWithOffset:(CGFloat)keyboardOffset {
  objc_setAssociatedObject(self, &keyboardScrollOffsetKey, @(keyboardOffset), OBJC_ASSOCIATION_COPY_NONATOMIC);
  [self handleKeyboardNotifications];
}

- (MZKeyboardNotificationBlock)defaultKeyboardNotificationBlock {
  MZKeyboardNotificationBlock defaultBlock = objc_getAssociatedObject(self, &defaultKeyboardNotificationBlockKey);
  if (defaultBlock == nil) {
    defaultBlock = ^(BOOL show, CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, UIViewAnimationOptions options) {
      CGFloat keyboardOffset = [objc_getAssociatedObject(self, &keyboardScrollOffsetKey) floatValue];
      
      if(show) {
        NSNumber * bottomInset = objc_getAssociatedObject(self, &scrollViewBottomInsetOffsetKey);
        if(bottomInset == nil) {
          bottomInset = @(self.contentInset.bottom);
          objc_setAssociatedObject(self, &scrollViewBottomInsetOffsetKey, bottomInset, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        NSNumber * indicatorBottomInset = objc_getAssociatedObject(self, &scrollViewBottomInsetOffsetKey);
        if(indicatorBottomInset == nil) {
          indicatorBottomInset = @(self.contentInset.bottom);
          objc_setAssociatedObject(self, &scrollViewBottomInsetOffsetKey, indicatorBottomInset, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGPoint positionInWindow = [self.window convertPoint:self.frame.origin fromView:[self superview]];
        
        CGFloat absoluteHeight = positionInWindow.y + self.frame.size.height + self.contentOffset.y;
        
        if(absoluteHeight >= (screenBounds.size.height - endKeyboardRect.size.height)) {
          CGFloat offset = fmax(0.0f, screenBounds.size.height - absoluteHeight);

          offset -= keyboardOffset;
          
          offset = endKeyboardRect.size.height - offset;
          objc_setAssociatedObject(self, &savedOffsetKey, @(offset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

          [UIView animateWithDuration:duration
                                delay:0.0f
                              options:options
                           animations:^{
                             UIEdgeInsets edgeInsets = self.contentInset;
                             edgeInsets.bottom = offset + [bottomInset floatValue];
                             self.contentInset = edgeInsets;
                             edgeInsets = self.scrollIndicatorInsets;
                             edgeInsets.bottom = offset + [indicatorBottomInset floatValue];
                             self.scrollIndicatorInsets = edgeInsets;
                           } completion:nil];
        }
      } else {
        NSNumber * bottomInset = objc_getAssociatedObject(self, &scrollViewBottomInsetOffsetKey);
        NSNumber * indicatorBottomInset = objc_getAssociatedObject(self, &scrollViewBottomInsetOffsetKey);

				objc_setAssociatedObject(self, &savedOffsetKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:options
                         animations:^{
                           UIEdgeInsets edgeInsets = self.contentInset;
                           edgeInsets.bottom = [bottomInset floatValue];
                           self.contentInset = edgeInsets;
                           edgeInsets = self.scrollIndicatorInsets;
                           edgeInsets.bottom = [indicatorBottomInset floatValue];
                           self.scrollIndicatorInsets = edgeInsets;
                         }
                         completion:nil];
        
        objc_setAssociatedObject(self, &scrollViewBottomInsetOffsetKey, nil, OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, &scrollViewIndicatorBottomInsetOffsetKey, nil, OBJC_ASSOCIATION_ASSIGN);
      }
    };
    
    objc_setAssociatedObject(self, &defaultKeyboardNotificationBlockKey, defaultBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  }
  return defaultBlock;
}

- (void)handleKeyboardNotifications {
  return [self handleKeyboardNotifications];
}

- (void)handleKeyboardNotificationsWithOffset:(CGFloat)keyboardOffset {
  return [self handleKeyboardNotificationsWithOffset:keyboardOffset];
}

- (MZKeyboardNotificationBlock)defaultKeyboardNotificationBlock {
  return [self defaultKeyboardNotificationBlock];
}

@end
