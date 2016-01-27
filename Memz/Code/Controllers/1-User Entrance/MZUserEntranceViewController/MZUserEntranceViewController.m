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

NSString * const MZMainViewControllerSegue = @"MZMainViewControllerSegue";

@interface MZUserEntranceViewController ()

@property (nonatomic, strong) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[MZLanguageManager sharedManager];
}

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	[self performSegueWithIdentifier:MZMainViewControllerSegue sender:self];
}

@end
