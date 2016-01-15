//
//  MZSettingsViewController.m
//  Memz
//
//  Created by Bastien Falcou on 1/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZSettingsViewController.h"
#import "MZSettingsTableViewHeader.h"
#import "MZSettingsTitleTableViewCell.h"
#import "MZSettingsStepperTableViewCell.h"
#import "MZSettingsSliderTableViewCell.h"
#import "MZQuizManager.h"
#import "MZPushNotificationManager.h"

typedef NS_ENUM(NSUInteger, MZSettingsTableViewSectionType) {
	MZSettingsTableViewSectionTypeNotifications,
	MZSettingsTableViewSectionTypeReverseQuiz
};

typedef NS_ENUM(NSUInteger, MZSettingsTableViewRowType) {
	MZSettingsTableViewRowTypeNotificationMain,
	MZSettingsTableViewRowTypeNotificationNumber,
	MZSettingsTableViewRowTypeNotificationHours,
	MZSettingsTableViewRowTypeReverseQuiz
};

NSString * const kSettingsTableViewHeaderIdentifier = @"MZSettingsTableViewHeaderIdentifier";
NSString * const kSettingsTitleTableViewCellIdentifier = @"MZSettingsTitleTableViewCellIdentifier";
NSString * const kSettingsStepperTableViewCellIdentifier = @"MZSettingsStepperTableViewCellIdentifier";
NSString * const kSettingsSliderTableViewCellIdentifier = @"MZSettingsSliderTableViewCellIdentifier";

NSString * const kSectionKey = @"SectionKey";
NSString * const kDataKey = @"DataKey";

NSString * const kRowKey = @"RowKey";
NSString * const kTitleKey = @"TitleKey";
NSString * const kIsActiveKey = @"IsActiveKey";
NSString * const kNotificationsNumber = @"NotificationsNumber";
NSString * const kTimeStartKey = @"TimeStartKey";
NSString * const kTimeEndKey = @"TimeEndKey";

const CGFloat kSettingsTableViewHeaderHeight = 200.0f;
const CGFloat kCellRegularHeight = 60.0f;
const CGFloat kCellSliderHeight = 100.0f;

@interface MZSettingsViewController () <UITableViewDataSource,
UITableViewDelegate,
MZSettingsTableViewHeaderDelegate,
MZSettingsTitleTableViewCellDelegate,
MZSettingsStepperTableViewCellDelegate,
MZSettingsSliderTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *tableViewData;

@end

@implementation MZSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.automaticallyAdjustsScrollViewInsets = NO;

	// (1) Register custom Table View Header
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZSettingsTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kSettingsTableViewHeaderIdentifier];

	// (2) Setup Table View Header
	MZSettingsTableViewHeader *tableViewHeader = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MZSettingsTableViewHeader class])
																																						 owner:self
																																					 options:nil][0];
	tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, kSettingsTableViewHeaderHeight);
	tableViewHeader.delegate = self;
	self.tableView.tableHeaderView = tableViewHeader;

	// (3) Reload Data
	[self.tableView reloadData];
}

- (NSMutableArray<NSMutableDictionary *> *)tableViewData {
	// (1) Setup Table View Data: Notifications
	NSMutableArray *notificationsSettings = @[@{kRowKey: @(MZSettingsTableViewRowTypeNotificationMain),
																							kTitleKey: NSLocalizedString(@"SettingsNotificationsActivateTitle", nil),
																							kIsActiveKey: @([MZPushNotificationManager sharedManager].isActivated)}.mutableCopy].mutableCopy;

	if ([MZPushNotificationManager sharedManager].isActivated) {
		[notificationsSettings addObject:@{kRowKey: @(MZSettingsTableViewRowTypeNotificationNumber),
																			 kTitleKey: NSLocalizedString(@"SettingsNotificationsNumberTitle", nil),
																			 kNotificationsNumber: @([MZQuizManager sharedManager].quizPerDay)}.mutableCopy];

		[notificationsSettings addObject:@{kRowKey: @(MZSettingsTableViewRowTypeNotificationHours),
																			 kTitleKey: NSLocalizedString(@"SettingsNotificationsHoursTitle", nil),
																			 kTimeStartKey: @([MZPushNotificationManager sharedManager].startHour),
																			 kTimeEndKey: @([MZPushNotificationManager sharedManager].endHour)}.mutableCopy];
	}

	// (2) Setup Table View Data: Quiz
	NSMutableArray *reverseQuiz = @[@{kRowKey: @(MZSettingsTableViewRowTypeReverseQuiz),
																		kTitleKey: NSLocalizedString(@"SettingsQuizReverseTitle", nil),
																		kIsActiveKey: @([MZQuizManager sharedManager].isReversed)}.mutableCopy].mutableCopy;

	// (3) Unify Table View Data and Return
	return @[@{kSectionKey: @(MZSettingsTableViewSectionTypeNotifications),
						 kDataKey: notificationsSettings},
					 @{kSectionKey: @(MZSettingsTableViewSectionTypeReverseQuiz),
						 kDataKey: reverseQuiz}].mutableCopy;
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.tableViewData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ([self.tableViewData[section][kSectionKey] integerValue]) {
		case MZSettingsTableViewSectionTypeNotifications:
			return NSLocalizedString(@"SettingsNotificationSectionTitle", nil);
		case MZSettingsTableViewSectionTypeReverseQuiz:
			return NSLocalizedString(@"SettingsQuizSetionTitle", nil);
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *data = [self.tableViewData[indexPath.section][kDataKey][indexPath.row] safeCastToClass:[NSMutableDictionary class]];
	switch ([data[kRowKey] integerValue]) {
		case MZSettingsTableViewRowTypeNotificationHours:
			return kCellSliderHeight;
		default:
			return kCellRegularHeight;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *array = [self.tableViewData[section][kDataKey] safeCastToClass:[NSMutableArray class]];
	return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZSettingsTitleTableViewCell * (^ buildTitleCell)(NSString *, BOOL) = ^(NSString *title, BOOL isActive) {
		MZSettingsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTitleTableViewCellIdentifier
																																				 forIndexPath:indexPath];
		cell.settingsNameLabel.text = title;
		cell.settingsSwitch.on = isActive;
		cell.delegate = self;
		return cell;
	};

	MZSettingsStepperTableViewCell * (^ buildStepperCell)(NSString *, NSUInteger) = ^(NSString *title, NSUInteger value) {
		MZSettingsStepperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsStepperTableViewCellIdentifier
																																				 forIndexPath:indexPath];
		cell.titleLabel.text = title;
		cell.currentValue = value;
		cell.delegate = self;
		// TODO: Need to set Min and Max values
		return cell;
	};

	MZSettingsSliderTableViewCell * (^ buildSliderCell)(NSString *, NSUInteger, NSUInteger) = ^(NSString *title, NSUInteger startValue, NSUInteger endValue) {
		MZSettingsSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSliderTableViewCellIdentifier
																																				 forIndexPath:indexPath];
		cell.titleLabel.text = title;
		cell.startHour = startValue;
		cell.endHour = endValue;
		cell.delegate = self;
		return cell;
	};

	NSMutableDictionary *data = [self.tableViewData[indexPath.section][kDataKey][indexPath.row] safeCastToClass:[NSMutableDictionary class]];

	switch ([data[kRowKey] integerValue]) {
		case MZSettingsTableViewRowTypeNotificationMain:
		case MZSettingsTableViewRowTypeReverseQuiz:
			return buildTitleCell(data[kTitleKey], data[kIsActiveKey]);
		case MZSettingsTableViewRowTypeNotificationNumber:
			return buildStepperCell(data[kTitleKey], [data[kNotificationsNumber] integerValue]);
		case MZSettingsTableViewRowTypeNotificationHours:
			return buildSliderCell(data[kTitleKey], [data[kTimeStartKey] integerValue], [data[kTimeEndKey] integerValue]);
	}
	return nil;
}

#pragma mark - Table View Header Delegate Methods

- (void)settingsTableViewHeaderDidRequestChangeFromLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	// TODO: To implement
}

- (void)settingsTableViewHeaderDidRequestChangeToLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	// TODO: To implement
}

#pragma mark - Title Table View Cell Delegate Methods

- (void)settingsTitleTableViewCellDidSwitch:(MZSettingsTitleTableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

	MZSettingsTableViewRowType rowType = [self.tableViewData[indexPath.section][kDataKey][indexPath.row][kRowKey] integerValue];
	BOOL isOn = cell.settingsSwitch.on;

	switch (rowType) {
		case MZSettingsTableViewRowTypeNotificationMain: {
			[MZPushNotificationManager sharedManager].activated = isOn;

			NSArray<NSIndexPath *> *indexPathsToAnimate = @[[NSIndexPath indexPathForItem:MZSettingsTableViewRowTypeNotificationNumber
																																					inSection:MZSettingsTableViewSectionTypeNotifications],
																											[NSIndexPath indexPathForItem:MZSettingsTableViewRowTypeNotificationHours
																																					inSection:MZSettingsTableViewSectionTypeNotifications]];

			if (isOn) {
				[self.tableView insertRowsAtIndexPaths:indexPathsToAnimate withRowAnimation:UITableViewRowAnimationFade];
			} else {
				[self.tableView deleteRowsAtIndexPaths:indexPathsToAnimate withRowAnimation:UITableViewRowAnimationFade];
			}
			break;
		}
		case MZSettingsTableViewRowTypeReverseQuiz:
			[MZQuizManager sharedManager].reversed = isOn;
			break;
  default:
			break;
	}
}

#pragma mark - Stepper Table View Cell Delegate Methods

- (void)settingsStepperTableViewCell:(MZSettingsStepperTableViewCell *)cell didUpdateValue:(NSUInteger)value {

}

#pragma mark - Slider Table View Cell Delegate Methods

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeStartHour:(NSUInteger)startHour {

}

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeEndHour:(NSUInteger)endHour {

}

@end
