//
//  MZSettingsTitleTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"
#import "MZSwitch.h"

@protocol MZSettingsTitleTableViewCellDelegate;

@interface MZSettingsTitleTableViewCell : MZTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *settingsNameLabel;
@property (nonatomic, strong) IBOutlet MZSwitch *settingsSwitch;

@property (nonatomic, strong) id<MZSettingsTitleTableViewCellDelegate> delegate;

@end

@protocol MZSettingsTitleTableViewCellDelegate <NSObject>

- (void)settingsTitleTableViewCellDidSwitch:(MZSettingsTitleTableViewCell *)cell;

@end