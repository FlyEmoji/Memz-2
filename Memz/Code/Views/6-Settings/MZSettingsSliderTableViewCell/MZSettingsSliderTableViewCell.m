//
//  MZSettingsSliderTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsSliderTableViewCell.h"

@interface MZSettingsSliderTableViewCell ()

@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation MZSettingsSliderTableViewCell

#pragma mark - Actions

- (IBAction)sliderValueChanged:(UISlider *)slider {
	// TODO: Update start / end hour, call delegate
}

@end
