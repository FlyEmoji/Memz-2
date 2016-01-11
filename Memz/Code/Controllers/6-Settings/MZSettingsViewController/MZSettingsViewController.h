//
//  MZSettingsViewController.h
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *settingsNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;

@end
