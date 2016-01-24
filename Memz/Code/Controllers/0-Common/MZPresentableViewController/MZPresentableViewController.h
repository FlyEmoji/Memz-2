//
//  MZPresentableViewController.h
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPullViewControllerTransition.h"
#import "MZTableView.h"

/* Base for all view controllers throughout the application that will share similar properties and behavior.
 * For instance, all view controllers that can be closed using custom pull transition will take advantage of
 * the delegate declared in this base view controller, to tell the previous view which way the transition 
 * should occur (going down/up).
 */

@protocol MZPresentableViewControllerTransitioning;

@interface MZPresentableViewController : UIViewController <MZTableViewTransitionDelegate>

@property (nonatomic, strong) id<MZPresentableViewControllerTransitioning> transitionDelegate;

- (void)showStatusBar:(BOOL)show;

@end

@protocol MZPresentableViewControllerTransitioning <NSObject>

@optional

- (void)presentableViewControllerDidStartPresentAnimatedTransition:(MZPresentableViewController *)viewController;
- (void)presentableViewControllerDidFinishPresentAnimatedTransition:(MZPresentableViewController *)viewController;

- (void)presentableViewControllerDidStartDismissalAnimatedTransition:(MZPresentableViewController *)viewController;
- (void)presentableViewController:(MZPresentableViewController *)viewController didUpdateDismissalAnimatedTransition:(CGFloat)percent;
- (void)presentableViewController:(MZPresentableViewController *)viewController didFinishDismissalAnimatedTransitionWithDirection:(MZPullViewControllerTransitionDirection)direction;
- (void)presentableViewControllerDidCancelDismissalAnimatedTransition:(MZPresentableViewController *)viewController;

@end