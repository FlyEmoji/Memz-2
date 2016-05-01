//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "MZMainViewController.h"
#import "MZLanguageManager.h"
#import "UINavigationController+MemzTransitions.h"

@interface MZUserEntranceViewController ()

@property (nonatomic, strong) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	// TODO: Create user object

	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
