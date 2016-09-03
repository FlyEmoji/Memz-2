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

/* Presentable View Controller behavior for all presented view controllers throughout the application that will 
 * share similar properties and behavior (notably transitioning). For instance, all view controllers that can 
 * be closed using custom pull transition will take advantage of the delegate declared in this subclass View 
 * Controller, to tell the previous view which way the transition should occur (going down/up), etc.
 *
 * Implements MZTableViewTransitionDelegate for its subclasses to conform it if needed and automatically enjoy
 * its behavior already implemented and handled.
 */

@protocol MZPresentableViewControllerTransitioning;

@interface MZPresentableViewController : UIViewController <MZTableViewTransitionDelegate>

@property (nonatomic, strong) id<MZPresentableViewControllerTransitioning> transitionDelegate;

- (void)showStatusBar:(BOOL)show;
- (void)dismissViewControllerWithCompletion:(void (^)())completionHandler;		// TODO: See if can not find something more elegant

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