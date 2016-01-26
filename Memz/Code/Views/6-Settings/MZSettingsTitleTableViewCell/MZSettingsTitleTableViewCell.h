//
//  MZSettingsTitleTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZSettingsTitleTableViewCellDelegate;

@interface MZSettingsTitleTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *settingsNameLabel;
@property (nonatomic, strong) IBOutlet UISwitch *settingsSwitch;

@property (nonatomic, strong) id<MZSettingsTitleTableViewCellDelegate> delegate;

@end

@protocol MZSettingsTitleTableViewCellDelegate <NSObject>

- (void)settingsTitleTableViewCellDidSwitch:(MZSettingsTitleTableViewCell *)cell;

@end