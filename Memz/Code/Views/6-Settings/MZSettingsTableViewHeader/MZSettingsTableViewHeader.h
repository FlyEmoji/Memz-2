//
//  MZSettingsTableViewHeader.h
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLanguageManager.h"
#import "MZNibView.h"

@protocol MZSettingsTableViewHeaderDelegate;

@interface MZSettingsTableViewHeader : MZNibView

@property (nonatomic, weak) id<MZSettingsTableViewHeaderDelegate> delegate;

@property (nonatomic, assign) MZLanguage fromLanguage;
@property (nonatomic, assign) MZLanguage toLanguage;

@end

@protocol MZSettingsTableViewHeaderDelegate <NSObject>

@optional

- (void)settingsTableViewHeaderDidRequestChangeFromLanguage:(MZSettingsTableViewHeader *)tableViewHeader;
- (void)settingsTableViewHeaderDidRequestChangeToLanguage:(MZSettingsTableViewHeader *)tableViewHeader;

@end
