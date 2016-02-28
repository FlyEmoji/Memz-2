//
//  MZStoryboardSegue.m
//  Memz
//
//  Created by Bastien Falcou on 1/27/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZStoryboardSegue.h"
#import "MZTransitioningDefaultBehavior.h"
#import "MZNavigationController.h"
#import "MZPresentableViewController.h"

@interface MZStoryboardSegue ()

@property (nonatomic, strong) MZTransitioningDefaultBehavior *transitioningBehavior;

@end

@implementation MZStoryboardSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	if (self = [super initWithIdentifier:identifier source:source destination:destination]) {
		self.transitioningBehavior = [MZTransitioningDefaultBehavior new];
	}
	return self;
}

- (void)perform {
	void (^ checkPresentableViewController)(UIViewController __kindof *) = ^(UIViewController __kindof *viewController) {
		if ([viewController isKindOfClass:[MZPresentableViewController class]]) {
			MZPresentableViewController *presentableViewController = viewController;
			presentableViewController.transitionDelegate = self.transitioningBehavior;
		}
	};

	self.destinationViewController.transitioningDelegate = self.transitioningBehavior;
	self.destinationViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;	// TODO: To refactor, duplicated assignations

	if ([self.destinationViewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = self.destinationViewController;
		UIViewController *rootViewController = navigationController.viewControllers.firstObject;
		checkPresentableViewController(rootViewController);
	}

	checkPresentableViewController(self.destinationViewController);

	[self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
}

- (void)dealloc {
	self.transitioningBehavior = nil;
}

@end
