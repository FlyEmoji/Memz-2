//
//  MZSettingsTitleTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsTitleTableViewCell.h"

@implementation MZSettingsTitleTableViewCell

#pragma mark - Actions

- (IBAction)didSwitchValueChange:(UISwitch *)theSwitch {
	if ([self.delegate respondsToSelector:@selector(settingsTitleTableViewCellDidSwitch:)]) {
		[self.delegate settingsTitleTableViewCellDidSwitch:self];
	}
}

@end
