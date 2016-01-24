//
//  MZBaseViewController.h
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPullViewControllerTransition.h"

/* Base for all view controllers throughout the application that will share similar properties and behavior.
 * For instance, all view controllers that can be closed using custom pull transition will take advantage of
 * the delegate declared in this base view controller, to tell the previous view which way the transition 
 * should occur (going down/up).
 */

@protocol MZBaseViewControllerDelegate;

@interface MZBaseViewController : UIViewController

@property (nonatomic, strong) id<MZBaseViewControllerDelegate> delegate;

@end

@protocol MZBaseViewControllerDelegate <NSObject>

@optional

- (void)baseViewControllerDidStartPresenting:(MZBaseViewController *)viewController;
- (void)baseViewControllerDidFinishPresenting:(MZBaseViewController *)viewController;

- (void)baseViewControllerDidStartDismissalAnimatedTransition:(MZBaseViewController *)viewController;
- (void)baseViewController:(MZBaseViewController *)viewController didUpdateDismissalAnimatedTransition:(CGFloat)percent;
- (void)baseViewController:(MZBaseViewController *)viewController didFinishDismissalAnimatedTransitionWithDirection:(MZPullViewControllerTransitionDirection)direction;
- (void)baseViewControllerDidCancelDismissalAnimatedTransition:(MZBaseViewController *)viewController;

@end