//
//  MZTestControlsViewController.h
//  Memz
//
//  Created by Bastien Falcou on 5/21/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MZSwitch.h"
#import "MZPageControl.h"

@interface MZTestControlsViewController : UIViewController

@property (strong, nonatomic) IBOutlet MZSwitch *testSwitch;
@property (strong, nonatomic) IBOutlet MZPageControl *testPageControl;

@end
