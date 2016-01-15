//
//  MZSettingsSliderTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsSliderTableViewCell.h"

const NSUInteger kSliderDefaultMinimumValue = 0;
const NSUInteger kSliderDefaultMaximumValue = 24;

const NSUInteger kSliderDefaultStartValue = 0;
const NSUInteger kSliderDefaultEndValue = 24;

@interface MZSettingsSliderTableViewCell ()

@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation MZSettingsSliderTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.minimumValue = kSliderDefaultMinimumValue;
	self.maximumValue = kSliderDefaultMaximumValue;
	self.startValue = kSliderDefaultStartValue;
	self.endValue = kSliderDefaultEndValue;

	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Custom Getters/Setters

- (void)setMinimumValue:(NSUInteger)minimumValue {
	self.slider.minimumValue = minimumValue;

	if (self.startValue < minimumValue) {
		self.startValue = minimumValue;
	}
}

- (NSUInteger)minimumValue {
	return self.slider.minimumValue;
}

- (void)setMaximumValue:(NSUInteger)maximumValue {
	self.slider.maximumValue = maximumValue;

	if (self.endValue > maximumValue) {
		self.endValue = maximumValue;
	}
}

- (NSUInteger)maximumValue {
	return self.slider.maximumValue;
}

- (void)setStarValue:(NSUInteger)startValue {
	if (startValue < self.minimumValue) {
		_startValue = self.minimumValue;
	} else {
		_startValue = startValue;
	}

	// TODO: Update Left Slider
	// TODO: Update Potential Label
}

- (void)setendValue:(NSUInteger)endValue {
	if (endValue > self.maximumValue) {
		_endValue = self.maximumValue;
	} else {
		_endValue = endValue;
	}

	// TODO: Update Right Slider
	// TODO: Update Potential Label
}

#pragma mark - Actions

- (IBAction)sliderValueChanged:(UISlider *)slider {
	self.startValue = slider.value;
	self.endValue = slider.value;
	// TODO: Update start / end hour, call delegate
}

@end
