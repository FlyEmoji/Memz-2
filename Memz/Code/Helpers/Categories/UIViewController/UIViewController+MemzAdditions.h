//
//  UIViewController+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MemzAdditions)

+ (UIViewController *)topMostViewController;

- (void)presentError:(NSError *)error;
- (void)configureTapEndEditing;

@end
