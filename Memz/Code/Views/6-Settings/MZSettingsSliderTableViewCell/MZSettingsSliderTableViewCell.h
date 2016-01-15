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

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) id<MZSettingsSliderTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSUInteger startHour;	  // Between 0 and 24
@property (nonatomic, assign) NSUInteger endHour;		// Between 0 and 24

@end

@protocol MZSettingsSliderTableViewCellDelegate <NSObject>

@optional

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeStartHour:(NSUInteger)startHour;
- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeEndHour:(NSUInteger)endHour;

@end