//
//  MZWordAdditionViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordAdditionViewController.h"

@implementation MZWordAdditionViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden {		// TODO: DOES NOT WORK
	return YES;
}

#pragma mark - Actions

- (IBAction)didTapCloseButton:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
