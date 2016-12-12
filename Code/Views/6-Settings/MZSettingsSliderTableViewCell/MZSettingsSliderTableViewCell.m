//
//  MZSettingsSliderTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsSliderTableViewCell.h"
#import "NMRangeSlider.h"

const NSUInteger kSliderDefaultMinimumValue = 0;
const NSUInteger kSliderDefaultMaximumValue = 24;

const NSUInteger kSliderDefaultStartValue = 0;
const NSUInteger kSliderDefaultEndValue = 24;

const NSTimeInterval kCallbackDelayerFrequency = 2.0;

@interface MZSettingsSliderTableViewCell ()

@property (nonatomic, strong) IBOutlet NMRangeSlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *startValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *endValueLabel;

@property (nonatomic, strong) NSTimer *callbackDelayer;
@property (nonatomic, assign) BOOL shouldUpdate;

@end

@implementation MZSettingsSliderTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

	self.minimumValue = kSliderDefaultMinimumValue;
	self.maximumValue = kSliderDefaultMaximumValue;

	self.startValue = kSliderDefaultStartValue;
	self.endValue = kSliderDefaultEndValue;

	self.slider.lowerValue = kSliderDefaultStartValue;
	self.slider.upperValue = kSliderDefaultEndValue;

	self.slider.tintColor = [UIColor mainBlueColor];
	
	self.slider.lowerHandleImageNormal = [UIImage imageWithAssetIdentifier:MZAssetIdentifierSettingsRangeSlider];
	self.slider.upperHandleImageNormal = [UIImage imageWithAssetIdentifier:MZAssetIdentifierSettingsRangeSlider];

	self.slider.trackBackgroundImage = [UIImage imageWithAssetIdentifier:MZAssetIdentifierSettingSliderLineFaded];
	self.slider.trackImage = [UIImage imageWithAssetIdentifier:MZAssetIdentifierSettingSliderLineChosen];

	self.callbackDelayer = [NSTimer scheduledTimerWithTimeInterval:kCallbackDelayerFrequency
																													target:self
																												selector:@selector(callbackIfNeeded:)
																												userInfo:nil
																												 repeats:YES];
}

- (void)dealloc {
	// TODO: Test if called when deallocating
	[self.callbackDelayer invalidate];
	self.callbackDelayer = nil;
}

#pragma mark - Update Controller If Needed

- (void)callbackIfNeeded:(NSTimer *)timer {
	if (!self.shouldUpdate || ![self.delegate respondsToSelector:@selector(settingsSliderTableViewCell:didChangeStartHour:endHour:)]) {
		return;
	}

	[self.delegate settingsSliderTableViewCell:self didChangeStartHour:self.slider.lowerValue endHour:self.slider.upperValue];
	self.shouldUpdate = NO;
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

- (void)setStartValue:(NSUInteger)startValue {
	if (_startValue == startValue) {
		return;
	} else if (startValue < self.minimumValue) {
		_startValue = self.minimumValue;
	} else {
		_startValue = startValue;
	}

	self.startValueLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.startValue];
	self.slider.lowerValue = self.startValue;
}

- (void)setEndValue:(NSUInteger)endValue {
	if (_endValue == endValue) {
		return;
	} else if (endValue > self.maximumValue) {
		_endValue = self.maximumValue;
	} else {
		_endValue = endValue;
	}

	self.endValueLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.endValue];
	self.slider.upperValue = self.endValue;
}

#pragma mark - Actions

- (IBAction)sliderValueChanged:(NMRangeSlider *)slider {
	_startValue = slider.lowerValue;
	_endValue = slider.upperValue;

	self.startValueLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)slider.lowerValue];
	self.endValueLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)slider.upperValue];

	self.shouldUpdate = YES;
}

@end
