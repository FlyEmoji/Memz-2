//
//  MZBaseViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZBaseViewController.h"

@implementation MZBaseViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self.delegate respondsToSelector:@selector(baseViewControllerDidStartPresenting:)]) {
		[self.delegate baseViewControllerDidStartPresenting:self];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	if ([self.delegate respondsToSelector:@selector(baseViewControllerDidFinishPresenting:)]) {
		[self.delegate baseViewControllerDidFinishPresenting:self];
	}
}

@end
