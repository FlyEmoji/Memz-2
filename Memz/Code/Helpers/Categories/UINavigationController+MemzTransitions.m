//
//  UINavigationController+MemzTransitions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationController+MemzTransitions.h"
#import "UINavigationItem+MemzAdditions.h"

static const char kTransitionOptionKey;

@implementation UINavigationController (MemzTransitions)

- (void)animatedTransitionToViewController:(UIViewController *)viewController
															transitionOption:(UIViewAnimationOptions)transitionOption
																		completion:(void (^)(BOOL finished))completionHandler {
	[UIView transitionWithView:self.view
										duration:[self animationDurationForAnimation:transitionOption]
										 options:transitionOption
									animations:^{
										[UIView performWithoutAnimation:^{
											[self pushViewController:viewController
																			animated:NO];
										}];
									}
									completion:completionHandler];

	objc_setAssociatedObject(viewController, &kTransitionOptionKey, @([self reverseAnimationForAnimation:transitionOption]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	[viewController.navigationItem setCustomBackButtonActionBlock:^(UIButton *backButton, MZCustomBackButtonActionCompletedBlock completedBlock) {
		[self popViewControllerWithMatchingAnimationAnimated:YES completion:^(BOOL finished) {
			completedBlock(YES);
		}];
	}                                                       // Since the new view controller is already pushed, this returns the correct back button title
																													title:[self currentBackButtonTitle]];
}

- (UINavigationController *)transitionToNewRootViewController:(UIViewController *)viewController
																											 completion:(void (^)(BOOL))completionHandler {
	return [self transitionToNewRootViewController:viewController transitionOption:UIViewAnimationOptionTransitionNone completion:completionHandler];
}

- (UINavigationController *)transitionToNewRootViewController:(UIViewController *)viewController
																								 transitionOption:(UIViewAnimationOptions)transitionOption
																											 completion:(void (^)(BOOL finished))completionHandler {
	return (UINavigationController *)[self transitionToNewRootViewController:viewController
																																			 options:MZAnimatedTransitionNewRootOptionNavigationController
																															transitionOption:transitionOption
																																		completion:completionHandler];
}

- (UIViewController *)transitionToNewRootViewController:(UIViewController *)viewController
																										options:(MZAnimatedTransitionNewRootOptions)options
																					 transitionOption:(UIViewAnimationOptions)transitionOption
																								 completion:(void (^)(BOOL finished))completionHandler {
	UIWindow *window = self.view.window ?: [[UIApplication sharedApplication].windows firstObject];
	UIViewController *resultViewController = nil;

	if (!!(options & MZAnimatedTransitionNewRootOptionNavigationController)) {
		NSLog(@"Transition to new root controller (%@), creating a new instance of UINavigationController for it", viewController);
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		resultViewController = navigationController;
	} else {
		NSLog(@"Transition to new root controller (%@)", viewController);
		resultViewController = viewController;
	}

	void (^viewTransitionAnimations)() = ^() {
		window.rootViewController = resultViewController;
	};

	// Don't perform the transition if there is no animation option
	if (transitionOption == UIViewAnimationOptionTransitionNone) {
		viewTransitionAnimations();

		if (completionHandler) {
			completionHandler(YES);
		}
		return resultViewController;
	}

	[UIView transitionWithView:window
										duration:[self animationDurationForAnimation:transitionOption]
										 options:transitionOption
									animations:^{
										[UIView performWithoutAnimation:^{
											viewTransitionAnimations();
										}];
									}
									completion:completionHandler];

	return resultViewController;
}

- (UIViewController *)popViewControllerWithTransitionOption:(UIViewAnimationOptions)transitionOption
																										 completion:(void (^)(BOOL finished))completionHandler {
	UIViewController * viewController = self.viewControllers[self.viewControllers.count - 1];
	[UIView transitionWithView:self.view
										duration:[self animationDurationForAnimation:transitionOption]
										 options:transitionOption
									animations:^{
										[UIView performWithoutAnimation:^{
											[self popViewControllerAnimated:NO];
										}];
									}
									completion:completionHandler];

	return viewController;
}

- (UIViewController *)popViewControllerWithMatchingAnimationAnimated:(BOOL)animated
																															completion:(void (^)(BOOL finished))completionHandler {
	if(self.viewControllers.count == 0) {
		return nil;
	}

	UIViewController * viewController = self.viewControllers[self.viewControllers.count - 1];
	if (!animated) {
		[self popViewControllerAnimated:NO];

		if (completionHandler != nil) {
			completionHandler(YES);
		}
	} else {
		NSNumber * transitionOption = objc_getAssociatedObject(viewController, &kTransitionOptionKey);
		if (transitionOption != nil) {
			UIViewAnimationOptions popAnimation = [transitionOption integerValue];
			[self popViewControllerWithTransitionOption:(animated ? popAnimation : UIViewAnimationOptionTransitionNone) completion:completionHandler];
		} else {
			[self popViewControllerAnimated:YES];

			if (completionHandler != nil) {
				completionHandler(YES);
			}
		}
	}

	return viewController;
}

- (UIViewAnimationOptions)reverseAnimationForAnimation:(UIViewAnimationOptions)animation {
	switch (animation) {
		case UIViewAnimationOptionTransitionCurlUp:
			return UIViewAnimationOptionTransitionCurlDown;
		case UIViewAnimationOptionTransitionCurlDown:
			return UIViewAnimationOptionTransitionCurlUp;
		case UIViewAnimationOptionTransitionFlipFromBottom:
			return UIViewAnimationOptionTransitionFlipFromTop;
		case UIViewAnimationOptionTransitionFlipFromLeft:
			return UIViewAnimationOptionTransitionFlipFromRight;
		case UIViewAnimationOptionTransitionFlipFromRight:
			return UIViewAnimationOptionTransitionFlipFromLeft;
		case UIViewAnimationOptionTransitionFlipFromTop:
			return UIViewAnimationOptionTransitionFlipFromBottom;
		default:
			return animation;
	}
}

- (NSTimeInterval)animationDurationForAnimation:(UIViewAnimationOptions)animation {
	switch (animation) {
		default:
		case UIViewAnimationOptionTransitionCurlUp:
		case UIViewAnimationOptionTransitionCurlDown:
			return 0.35f;
		case UIViewAnimationOptionTransitionFlipFromBottom:
		case UIViewAnimationOptionTransitionFlipFromLeft:
		case UIViewAnimationOptionTransitionFlipFromRight:
		case UIViewAnimationOptionTransitionFlipFromTop:
			return 0.75f;
		case UIViewAnimationOptionTransitionNone:
			return 0.0f;
	}
}

- (NSString *)currentBackButtonTitle {
	// Less than 2 views controller, so no back button
	if (self.viewControllers.count < 2) {
		return nil;
	}

	UIViewController * current = self.viewControllers[self.viewControllers.count - 1];
	UIViewController * previous = self.viewControllers[self.viewControllers.count - 2];
	if (current.navigationItem.customBackButton != nil) {
		return [current.navigationItem.customBackButton titleForState:UIControlStateNormal];
	}

	if (previous.navigationItem.nextBackButtonTitle != nil) {
		return previous.navigationItem.nextBackButtonTitle;
	}

	return previous.navigationController.navigationBar.backItem.title;
}

@end
