//
//  MZUserEntranceViewController.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZUserEntranceViewController.h"
#import "UINavigationController+MemzTransitions.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZMainViewController.h"
#import "MZLanguageDefinition.h"
#import "MZDataManager.h"
#import "MZUser.h"

@interface MZUserEntranceViewController ()

@property (nonatomic, strong) IBOutlet UIButton *enterNavigationButton;

@end

@implementation MZUserEntranceViewController

#pragma mark - Actions

- (IBAction)didTapEnterNavigationButton:(UIButton *)button {
	MZUser *user = [MZUser signUpUserFromLanguage:MZLanguageEnglish toLanguage:MZLanguageFrench];

	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
}

@end
