//
//  MZSettingsSliderTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZSettingsSliderTableViewCellDelegate;

@interface MZSettingsSliderTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
// TODO: Add left and right labels to display actual values

@property (nonatomic, strong) id<MZSettingsSliderTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSUInteger startValue;	  // Default 0
@property (nonatomic, assign) NSUInteger endValue;		// Default 24

@property (nonatomic, assign) NSUInteger minimumValue;	// Default 0
@property (nonatomic, assign) NSUInteger maximumValue;	// Default 24

@end

@protocol MZSettingsSliderTableViewCellDelegate <NSObject>

@optional

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeStartHour:(NSUInteger)startHour;
- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeEndHour:(NSUInteger)endHour;

@end