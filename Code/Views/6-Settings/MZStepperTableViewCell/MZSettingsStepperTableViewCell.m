//
//  MZSettingsStepperTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsStepperTableViewCell.h"

const NSUInteger kStepperDefaultValue = 0;
const NSUInteger kStepperDefaultMinimumValue = 0;
const NSUInteger kStepperDefaultMaximumValue = 10;

@interface MZSettingsStepperTableViewCell ()

@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;

@end

@implementation MZSettingsStepperTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.stepper.value = kStepperDefaultValue;
	self.stepper.minimumValue = kStepperDefaultMinimumValue;
	self.stepper.maximumValue = kStepperDefaultMaximumValue;
}

#pragma mark - Custom Getters/Setters

- (void)setCurrentValue:(NSUInteger)currentValue {
	_currentValue = currentValue;

	self.stepper.value = currentValue;
	self.numberLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)currentValue];
}

- (void)setMinimumValue:(NSUInteger)minimumValue {
	self.stepper.minimumValue = minimumValue;

	if (self.currentValue < minimumValue) {
		self.currentValue = minimumValue;
	}
}

- (NSUInteger)minimumValue {
	return self.stepper.minimumValue;
}

- (void)setMaximumValue:(NSUInteger)maximumValue {
	self.stepper.maximumValue = maximumValue;

	if (self.currentValue > maximumValue) {
		self.currentValue = maximumValue;
	}
}

- (NSUInteger)maximumValue {
	return self.stepper.maximumValue;
}

#pragma mark - Actions 

- (IBAction)didStepperValueChange:(UIStepper *)stepper {
	self.currentValue = stepper.value;

	if ([self.delegate respondsToSelector:@selector(settingsStepperTableViewCell:didUpdateValue:)]) {
		[self.delegate settingsStepperTableViewCell:self didUpdateValue:self.currentValue];
	}
}

@end
