//
//  MZSettingsStepperTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsStepperTableViewCell.h"

const NSUInteger kDefaultValue = 0;
const NSUInteger kDefaultMinimumValue = 0;
const NSUInteger kDefaultMaximumValue = 10;

@interface MZSettingsStepperTableViewCell ()

@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

@end

@implementation MZSettingsStepperTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.stepper.value = kDefaultValue;
	self.stepper.minimumValue = kDefaultMinimumValue;
	self.stepper.maximumValue = kDefaultMaximumValue;
}

#pragma mark - Custom Getters/Setters

- (void)setCurrentValue:(NSUInteger)currentValue {
	_currentValue = currentValue;

	self.stepper.value = currentValue;
	self.numberLabel.text = [NSString stringWithFormat:@"%ld", currentValue];
}

- (void)setMinimumValue:(NSUInteger)minimumValue {
	_minimumValue = minimumValue;

	if (self.currentValue < minimumValue) {
		self.currentValue = minimumValue;
	}
}

- (void)setMaximumValue:(NSUInteger)maximumValue {
	_maximumValue = maximumValue;

	if (self.currentValue > maximumValue) {
		self.currentValue = maximumValue;
	}
}

#pragma mark - Actions 

- (IBAction)didStepperValueChange:(UIStepper *)stepper {
	self.currentValue = stepper.value;

	if ([self.delegate respondsToSelector:@selector(settingsStepperTableViewCell:didUpdateValue:)]) {
		[self.delegate settingsStepperTableViewCell:self didUpdateValue:self.currentValue];
	}
}

@end
