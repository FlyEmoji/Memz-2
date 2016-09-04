//
//  UINavigationController+MemzTransitions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Define the behavior used when a view controller is set to the new root view controller in the
 *  transitionToNewRootViewController: methods
 */
typedef NS_OPTIONS(NSUInteger, MZAnimatedTransitionNewRootOptions) {
	/**
	 *  No option (Default). The view controller is assigned as-is.
	 */
	MZAnimatedTransitionNewRootOptionNone = 0,
	/**
	 *  The view controller is first wrapped into a UINavigationController, and then this navigation controller
	 *  is used as the new root view controller.
	 */
	MZAnimatedTransitionNewRootOptionNavigationController = (1 << 0),
};

@interface UINavigationController (MemzTransitions)

/**
 *  Retuns Application current main navigation controller.
 */
+ (UINavigationController *)mainNavigationController;

/**
 *  Perform a transition to a new view controller, allowing to specify the animation type.
 *
 *  @param viewController    The view controller to perform the transition to.
 *  @param transitionOption  The transition animation to use. It must start with UIViewAnimationOptionTransition.
 *  @param completionHandler A block called when the transition animation has completed.
 */
- (void)animatedTransitionToViewController:(UIViewController *)viewController
													transitionOption:(UIViewAnimationOptions)transitionOption
																completion:(void (^)(BOOL finished))completionHandler;

/**
 *  Perform a transition to a new view controller instantly, discarding the current navigation stack.
 *  The used navigation controller is the one injected from the ETHFramework injector,
 *  which defaults to UINavigationController.
 *
 *  @param viewController    The view controller to perform the transition to.
 *  @param completionHandler A block called when the transition animation has completed.
 *
 *  @return The newly created navigation controller.
 */
- (UINavigationController *)transitionToNewRootViewController:(UIViewController *)viewController
																									 completion:(void (^)(BOOL finished))completionHandler;
/**
 *  Perform a transition to a new view controller, discarding the current navigation stack, and allowing to specify the animation type.
 *  The used navigation controller type is the type of the navigation controller used to call the method.
 *
 *  @param viewController    The view controller to perform the transition to.
 *  @param transitionOption  The transition animation to use. It must start with UIViewAnimationOptionTransition.
 *  @param completionHandler A block called when the transition animation has completed.
 *
 *  @return The newly created navigation controller.
 */
- (UINavigationController *)transitionToNewRootViewController:(UIViewController *)viewController
																						 transitionOption:(UIViewAnimationOptions)transitionOption
																									 completion:(void (^)(BOOL finished))completionHandler;
/**
 *  Perform a transition to a new view controller, discarding the current navigation stack, and allowing to specify the animation type.
 *  The used navigation controller type is the type of the navigation controller used to call the method.
 *
 *  @param viewController    The view controller to perform the transition to.
 *  @param options           The options which defines the behavior when assigning the new root view controller.
 *  @param transitionOption  The transition animation to use. It must start with UIViewAnimationOptionTransition.
 *  @param completionHandler A block called when the transition animation has completed.
 *
 *  @return The newly created navigation controller.
 */
- (UIViewController *)transitionToNewRootViewController:(UIViewController *)viewController
																								options:(MZAnimatedTransitionNewRootOptions)options
																			 transitionOption:(UIViewAnimationOptions)transitionOption
																						 completion:(void (^)(BOOL finished))completionHandler;

/**
 *  Pop the current view controller with the specifed animation.
 *
 *  @param transitionOption  The animation to use. It must start with UIViewAnimationOptionTransition.
 *  @param completionHandler A block called when the transition animation has completed.
 *
 *  @return The popped view controller.
 */
- (UIViewController *)popViewControllerWithTransitionOption:(UIViewAnimationOptions)transitionOption
																								 completion:(void (^)(BOOL finished))completionHandler;
/**
 *  Pop the current view controller, with an animation matching which was used to push the view controller.
 *  If such an animation is not found, its behavior is equivalent to popViewControllerAnimated:.
 *
 *  @param animated          Specify whether or not the pop should be animated.
 *  @param completionHandler A block called when the transition animation has completed.
 *
 *  @return The popped view controller.
 */
- (UIViewController *)popViewControllerWithMatchingAnimationAnimated:(BOOL)animated
																													completion:(void (^)(BOOL finished))completionHandler;

/**
 *  Retrieve the currently displayed back button title (if any).
 *  @discussion This method also accounts for back button title or custom back button set in UINavigationItem+Ethanol.
 *  @return The current back button title, or nil if there is no back button.
 */
- (NSString *)currentBackButtonTitle;

@end
