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

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) id<MZSettingsStepperTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentValue;

@end

@protocol MZStepperTableViewCellDelegate <NSObject>

@optional

- (void)settingsStepperTableViewCell:(MZSettingsStepperTableViewCell *)cell didUpdateValue:(NSUInteger)value;

@end