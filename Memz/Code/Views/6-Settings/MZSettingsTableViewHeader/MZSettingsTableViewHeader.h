//
//  MZSettingsTableViewHeader.h
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLanguageDefinition.h"
#import "MZNibView.h"

@protocol MZSettingsTableViewHeaderDelegate;

@interface MZSettingsTableViewHeader : MZNibView

@property (nonatomic, weak) id<MZSettingsTableViewHeaderDelegate> delegate;

@property (nonatomic, assign) MZLanguage knownLanguage;
@property (nonatomic, assign) MZLanguage newLanguage;

@property (nonatomic, assign, readonly) CGRect knownLanguageFlagFrame;
@property (nonatomic, assign, readonly) CGRect newLanguageFlagFrame;

@end

@protocol MZSettingsTableViewHeaderDelegate <NSObject>

@optional

- (void)settingsTableViewHeaderDidRequestChangeFromLanguage:(MZSettingsTableViewHeader *)tableViewHeader;
- (void)settingsTableViewHeaderDidRequestChangeToLanguage:(MZSettingsTableViewHeader *)tableViewHeader;

@end
