//
//  MZSettingsStepperTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 1/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZSettingsStepperTableViewCellDelegate;

@interface MZSettingsStepperTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) id<MZSettingsStepperTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSUInteger currentValue;	// Default 0
@property (nonatomic, assign) NSUInteger maximumValue;	// Default 0
@property (nonatomic, assign) NSUInteger minimumValue;	// Default 10

@end

@protocol MZSettingsStepperTableViewCellDelegate <NSObject>

@optional

- (void)settingsStepperTableViewCell:(MZSettingsStepperTableViewCell *)cell didUpdateValue:(NSUInteger)value;

@end