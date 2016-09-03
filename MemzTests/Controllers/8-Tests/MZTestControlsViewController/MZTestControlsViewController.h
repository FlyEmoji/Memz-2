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
#import "MZNibViewTest.h"

@interface MZTestControlsViewController : UIViewController

@property (nonatomic, weak) IBOutlet MZSwitch *testSwitch;
@property (nonatomic, weak) IBOutlet MZPageControl *testPageControl;
@property (nonatomic, weak) IBOutlet MZNibViewTest *testNibView;

@end
