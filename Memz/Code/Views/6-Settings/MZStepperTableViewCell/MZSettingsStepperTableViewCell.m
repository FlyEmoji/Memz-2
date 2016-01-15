//
//  MZSettingsStepperTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsStepperTableViewCell.h"

@interface MZSettingsStepperTableViewCell ()

@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

@end

@implementation MZSettingsStepperTableViewCell

#pragma mark - Actions 

- (IBAction)didStepperValueChange:(id)sender {
	// TODO: Update current value and call delegate
}

@end
