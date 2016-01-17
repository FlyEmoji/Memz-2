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
	MZSettingsTableViewSectionTypeQuiz
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
NSString * const kMinimumValueKey = @"MinimumValueKey";
NSString * const kMaximumValueKey = @"MaximumValueKey";

const CGFloat kSettingsTableViewHeaderHeight = 200.0f;
const CGFloat kCellRegularHeight = 50.0f;
const CGFloat kCellSliderHeight = 95.0f;
const CGFloat kTableViewOffsetTriggersDismiss = 40.0f;

@interface MZSettingsViewController () <UITableViewDataSource,
UITableViewDelegate,
MZSettingsTableViewHeaderDelegate,
MZSettingsTitleTableViewCellDelegate,
MZSettingsStepperTableViewCellDelegate,
MZSettingsSliderTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *tableViewData;
@property (weak, nonatomic) IBOutlet MZSettingsTableViewHeader *tableViewHeader;

@end

@implementation MZSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationController.navigationBarHidden = YES;
	self.modalPresentationCapturesStatusBarAppearance = YES;

	//self.extendedLayoutIncludesOpaqueBars = YES;
	self.edgesForExtendedLayout = UIRectEdgeNone;

	[self setNeedsStatusBarAppearanceUpdate];

	// (1) Register custom Table View Header
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZSettingsTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kSettingsTableViewHeaderIdentifier];

	// (2) Setup Table View Header
	self.tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, kSettingsTableViewHeaderHeight);
	self.tableViewHeader.delegate = self;

	// (3) Reload Data
	[self.tableView reloadData];
}

- (NSMutableArray<NSMutableDictionary *> *)tableViewData {
	// (1) Setup Table View Data: Notifications
	NSMutableArray *notificationsSettings = @[@{kRowKey: @(MZSettingsTableViewRowTypeNotificationMain),
																							kTitleKey: NSLocalizedString(@"SettingsNotificationsActivateTitle", nil),
																							kIsActiveKey: @([MZQuizManager sharedManager].isActive)}.mutableCopy].mutableCopy;

	if ([MZQuizManager sharedManager].isActive) {
		[notificationsSettings addObject:@{kRowKey: @(MZSettingsTableViewRowTypeNotificationNumber),
																			 kTitleKey: NSLocalizedString(@"SettingsNotificationsNumberTitle", nil),
																			 kNotificationsNumber: @([MZQuizManager sharedManager].quizPerDay),
																			 kMinimumValueKey: @(kDayMinimumQuizNumber),
																			 kMaximumValueKey: @(kDayMaximumQuizNumber)}.mutableCopy];

		[notificationsSettings addObject:@{kRowKey: @(MZSettingsTableViewRowTypeNotificationHours),
																			 kTitleKey: NSLocalizedString(@"SettingsNotificationsHoursTitle", nil),
																			 kTimeStartKey: @([MZQuizManager sharedManager].startHour),
																			 kTimeEndKey: @([MZQuizManager sharedManager].endHour),
																			 kMinimumValueKey: @(0),
																			 kMaximumValueKey: @(24)}.mutableCopy];
	}

	// (2) Setup Table View Data: Quiz
	NSMutableArray *reverseQuiz = @[@{kRowKey: @(MZSettingsTableViewRowTypeReverseQuiz),
																		kTitleKey: NSLocalizedString(@"SettingsQuizReverseTitle", nil),
																		kIsActiveKey: @([MZQuizManager sharedManager].isReversed)}.mutableCopy].mutableCopy;

	// (3) Unify Table View Data and Return
	return @[@{kSectionKey: @(MZSettingsTableViewSectionTypeNotifications),
						 kDataKey: notificationsSettings},
					 @{kSectionKey: @(MZSettingsTableViewSectionTypeQuiz),
						 kDataKey: reverseQuiz}].mutableCopy;
}

#pragma mark - Statius Bar Handling

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationFade;
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.tableViewData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ([self.tableViewData[section][kSectionKey] integerValue]) {
		case MZSettingsTableViewSectionTypeNotifications:
			return NSLocalizedString(@"SettingsNotificationSectionTitle", nil);
		case MZSettingsTableViewSectionTypeQuiz:
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

	MZSettingsStepperTableViewCell * (^ buildStepperCell)(NSString *, NSUInteger, NSUInteger, NSUInteger) =
	^(NSString *title, NSUInteger value, NSUInteger minimumValue, NSUInteger maximumValue) {
		MZSettingsStepperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsStepperTableViewCellIdentifier
																																				 forIndexPath:indexPath];
		cell.titleLabel.text = title;
		cell.minimumValue = minimumValue;
		cell.maximumValue = maximumValue;
		cell.currentValue = value;
		cell.delegate = self;
		return cell;
	};

	MZSettingsSliderTableViewCell * (^ buildSliderCell)(NSString *, NSUInteger, NSUInteger, NSUInteger, NSUInteger) =
	^(NSString *title, NSUInteger startValue, NSUInteger endValue, NSUInteger minimumValue, NSUInteger maximumValue) {
		MZSettingsSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSliderTableViewCellIdentifier
																																				 forIndexPath:indexPath];
		cell.titleLabel.text = title;
		cell.minimumValue = minimumValue;
		cell.maximumValue = maximumValue;
		cell.startValue = startValue;
		cell.endValue = endValue;
		cell.delegate = self;
		return cell;
	};

	NSMutableDictionary *data = [self.tableViewData[indexPath.section][kDataKey][indexPath.row] safeCastToClass:[NSMutableDictionary class]];

	switch ([data[kRowKey] integerValue]) {
		case MZSettingsTableViewRowTypeNotificationMain:
		case MZSettingsTableViewRowTypeReverseQuiz:
			return buildTitleCell(data[kTitleKey],
														[data[kIsActiveKey] boolValue]);

		case MZSettingsTableViewRowTypeNotificationNumber:
			return buildStepperCell(data[kTitleKey],
															[data[kNotificationsNumber] integerValue],
															[data[kMinimumValueKey] integerValue],
															[data[kMaximumValueKey] integerValue]);

		case MZSettingsTableViewRowTypeNotificationHours:
			return buildSliderCell(data[kTitleKey],
														 [data[kTimeStartKey] integerValue],
														 [data[kTimeEndKey] integerValue],
														 [data[kMinimumValueKey] integerValue],
														 [data[kMaximumValueKey] integerValue]);
	}
	return nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (scrollView.contentOffset.y < -kTableViewOffsetTriggersDismiss) {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
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
			[MZQuizManager sharedManager].active = isOn;

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
	[MZQuizManager sharedManager].quizPerDay = value;
}

#pragma mark - Slider Table View Cell Delegate Methods

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeStartHour:(NSUInteger)startHour {
	[MZQuizManager sharedManager].startHour = startHour;
}

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell didChangeEndHour:(NSUInteger)endHour {
	[MZQuizManager sharedManager].endHour = endHour;
}

@end
