//
//  MZPresenterViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/25/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZPresenterViewController.h"

@implementation MZPresenterViewController

#pragma mark - Initialization

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.transitioningBehavior = [[MZTransitioningDefaultBehavior alloc] init];
}

@end
