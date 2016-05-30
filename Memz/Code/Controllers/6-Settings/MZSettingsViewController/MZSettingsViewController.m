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
#import "MZPushNotificationManager.h"
#import "UIImage+MemzAdditions.h"
#import "MZWebViewController.h"
#import "MZFlightPickerView.h"
#import "MZDataManager.h"
#import "MZQuizManager.h"
#import "MZTableView.h"

typedef NS_ENUM(NSUInteger, MZSettingsTableViewSectionType) {
	MZSettingsTableViewSectionTypeNotifications,
	MZSettingsTableViewSectionTypeLegal,
	MZSettingsTableViewSectionTypeOthers
};

typedef NS_ENUM(NSUInteger, MZSettingsTableViewRowType) {
	MZSettingsTableViewRowTypeNotificationMain,
	MZSettingsTableViewRowTypeNotificationNumber,
	MZSettingsTableViewRowTypeNotificationHours,
	MZSettingsTableViewRowTypeStatistics,
	MZSettingsTableViewRowTypeTermsAndConditions,
	MZSettingsTableViewRowTypePrivacyPolicy
};

NSString * const MZSettingsDidChangeLanguageNotification = @"MZSettingsDidChangeLanguageNotification";

NSString * const kPresentStatisticsViewControllerSegueIdentifier = @"MZPresentStatisticsViewControllerSegueIdentifier";
NSString * const kShowWebViewControllerSegueIdentifier = @"MZShowWebViewControllerSegueIdentifier";

NSString * const kSettingsTableViewHeaderIdentifier = @"MZSettingsTableViewHeaderIdentifier";
NSString * const kSettingsSwitchTableViewCellIdentifier = @"MZSettingsSwitchTableViewCellIdentifier";
NSString * const kSettingsStepperTableViewCellIdentifier = @"MZSettingsStepperTableViewCellIdentifier";
NSString * const kSettingsSliderTableViewCellIdentifier = @"MZSettingsSliderTableViewCellIdentifier";
NSString * const kSettingsTitleTableViewCellIdentifier = @"MZSettingsTitleTableViewCellIdentifier";

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
NSString * const kWebViewTypeKey = @"WebViewTypeKey";

const CGFloat kSettingsTableViewHeaderHeight = 180.0f;
const CGFloat kCellRegularHeight = 50.0f;
const CGFloat kCellSliderHeight = 105.0f;
const NSTimeInterval kFadeDuration = 0.2f;

@interface MZSettingsViewController () <UITableViewDataSource,
UITableViewDelegate,
MZSettingsTableViewHeaderDelegate,
MZSettingsTitleTableViewCellDelegate,
MZSettingsStepperTableViewCellDelegate,
MZSettingsSliderTableViewCellDelegate,
MZTableViewTransitionDelegate,
UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet MZTableView *tableView;
@property (nonatomic, weak) IBOutlet MZSettingsTableViewHeader *tableViewHeader;
@property (nonatomic, weak) IBOutlet UIView *overlayView;

@property (nonatomic, strong) MZFlightPickerView *languagePickerView;

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *tableViewData;
@property (nonatomic, weak, readonly) NSArray<UIImage *> *languageFlagImages;

@end

@implementation MZSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// (1) Register custom Table View Header
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZSettingsTableViewHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kSettingsTableViewHeaderIdentifier];

	// (2) Setup Table View Header
	self.tableViewHeader.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, kSettingsTableViewHeaderHeight);
	self.tableViewHeader.knownLanguage = [MZUser currentUser].knownLanguage.integerValue;
	self.tableViewHeader.newLanguage = [MZUser currentUser].newLanguage.integerValue;
	self.tableViewHeader.delegate = self;

	// (3) Setup Gesture Recognizer
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
	[self.overlayView addGestureRecognizer:tapGestureRecognizer];

	// (4) Reload Data
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kShowWebViewControllerSegueIdentifier]) {
		MZWebViewController *controller = [segue.destinationViewController safeCastToClass:[MZWebViewController class]];
		NSIndexPath *indexPath = [sender safeCastToClass:[NSIndexPath class]];
		controller.webViewType = [self.tableViewData[indexPath.section][kDataKey][indexPath.row][kWebViewTypeKey] integerValue];
	}
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

	// (2) Setup Table View Data: Legal
	NSMutableArray *legal = @[@{kRowKey: @(MZSettingsTableViewRowTypeTermsAndConditions),
															kTitleKey: NSLocalizedString(@"SettingsLegalTermsAndConditions", nil),
															kWebViewTypeKey: @(MZWebViewTypeTermsAndConditions)}.mutableCopy,
														@{kRowKey: @(MZSettingsTableViewRowTypePrivacyPolicy),
															kTitleKey: NSLocalizedString(@"SettingsLegalPrivacyPolicy", nil),
															kWebViewTypeKey: @(MZWebViewTypePrivacyPolicy)}.mutableCopy].mutableCopy;

	// (3) Setup Table View Data: Others
	NSMutableArray *others = @[@{kRowKey: @(MZSettingsTableViewRowTypeStatistics),
															 kTitleKey: NSLocalizedString(@"SettingsOthersStatisticsTitle", nil)}.mutableCopy].mutableCopy;

	// (4) Unify Table View Data and Return
	return @[@{kSectionKey: @(MZSettingsTableViewSectionTypeNotifications),
						 kDataKey: notificationsSettings},
					 @{kSectionKey: @(MZSettingsTableViewSectionTypeLegal),
						 kDataKey: legal},
					 @{kSectionKey: @(MZSettingsTableViewSectionTypeOthers),
						 kDataKey: others}].mutableCopy;
}

- (NSArray<UIImage *> *)languageFlagImages {
	return @[[UIImage flagImageForLanguage:MZLanguageEnglish],
					 [UIImage flagImageForLanguage:MZLanguageFrench],
					 [UIImage flagImageForLanguage:MZLanguageSpanish],
					 [UIImage flagImageForLanguage:MZLanguageItalian],
					 [UIImage flagImageForLanguage:MZLanguagePortuguese]];
}

- (void)setLanguagePickerView:(MZFlightPickerView *)languagePickerView {
	if (_languagePickerView) {
		[_languagePickerView removeFromSuperview];
		_languagePickerView = nil;
	}
	_languagePickerView = languagePickerView;
}

- (void)didTapView:(UITapGestureRecognizer *)tapGestureRecognizer {
	[self dismissLanguagePickerViewIfNeeded];
}

#pragma mark - Helpers

- (void)dismissLanguagePickerViewIfNeeded {
	if (self.languagePickerView) {
		[self.languagePickerView dismissWithDuration:kFadeDuration];
		[self showOverlayView:NO withDuration:kFadeDuration];
	}
}

- (void)showOverlayView:(BOOL)show withDuration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		self.overlayView.alpha = show ? 1.0f : 0.0f;
	}];
}

#pragma mark - Table View DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.tableViewData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ([self.tableViewData[section][kSectionKey] integerValue]) {
		case MZSettingsTableViewSectionTypeNotifications:
			return NSLocalizedString(@"SettingsNotificationSectionTitle", nil);
		case MZSettingsTableViewSectionTypeLegal:
			return NSLocalizedString(@"SettingsLegalSectionTitle", nil);
		case MZSettingsTableViewSectionTypeOthers:
			return NSLocalizedString(@"SettingsOthersSectionTitle", nil);
	}
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch ([self.tableViewData[section][kSectionKey] integerValue]) {
		case MZSettingsTableViewSectionTypeNotifications:
			return NSLocalizedString(@"SettingsNotificationsSectionFooterTitle", nil);
		case MZSettingsTableViewSectionTypeLegal:
			return NSLocalizedString(@"SettingsLegalSectionFooterTitle", nil);
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
	UITableViewCell * (^ buildTitleCell)(NSString *) = ^(NSString *title) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTitleTableViewCellIdentifier
																														forIndexPath:indexPath];
		cell.textLabel.text = title;
		cell.textLabel.textColor = [UIColor mainLightBlackColor];
		return cell;
	};

	MZSettingsTitleTableViewCell * (^ buildSwitchCell)(NSString *, BOOL) = ^(NSString *title, BOOL isActive) {
		MZSettingsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSwitchTableViewCellIdentifier
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
			return buildSwitchCell(data[kTitleKey],
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

		case MZSettingsTableViewRowTypeStatistics:
		case MZSettingsTableViewRowTypeTermsAndConditions:
		case MZSettingsTableViewRowTypePrivacyPolicy:
			return buildTitleCell(data[kTitleKey]);
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([self.tableViewData[indexPath.section][kDataKey][indexPath.row][kRowKey] integerValue]) {
		case MZSettingsTableViewRowTypeStatistics:
			[self performSegueWithIdentifier:kPresentStatisticsViewControllerSegueIdentifier sender:self];
			break;
		case MZSettingsTableViewRowTypePrivacyPolicy:
			[self performSegueWithIdentifier:kShowWebViewControllerSegueIdentifier sender:indexPath];
			break;
		default:
			break;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self dismissLanguagePickerViewIfNeeded];
}

#pragma mark - Table View Header Delegate Methods

- (void)settingsTableViewHeaderDidRequestChangeFromLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	[self showOverlayView:YES withDuration:kFadeDuration];

	CGPoint startPoint = CGPointMake(self.tableViewHeader.knownLanguageFlagFrame.origin.x + self.tableViewHeader.knownLanguageFlagFrame.size.width / 2.0f,
																	 self.tableViewHeader.knownLanguageFlagFrame.origin.y + self.tableViewHeader.knownLanguageFlagFrame.size.height);

	startPoint = [self.tableView convertPoint:startPoint toView:self.view];

	self.languagePickerView = [MZFlightPickerView displayFlightPickerInView:self.view
																												startingFromPoint:startPoint
																																 withData:self.languageFlagImages
																														 fadeDuration:kFadeDuration
																												 pickAtIndexBlock:
														 ^(NSUInteger selectedIndex) {
															 // (1) Switch languages if selected known language same as new one
															 if ([MZUser currentUser].newLanguage.integerValue == selectedIndex) {
																 [MZUser currentUser].newLanguage = [MZUser currentUser].knownLanguage;
																 self.tableViewHeader.newLanguage = [MZUser currentUser].knownLanguage.integerValue;
															 }

															 // (2) Update known language
															 [MZUser currentUser].knownLanguage = @(selectedIndex);
															 self.tableViewHeader.knownLanguage = selectedIndex;

															 // (3) Update views and rest of the application via notification center
															 [[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
																 [[NSNotificationCenter defaultCenter] postNotificationName:MZSettingsDidChangeLanguageNotification
																																										 object:@(selectedIndex)];
																 [self showOverlayView:NO withDuration:kFadeDuration];
																 [self.languagePickerView dismissWithDuration:kFadeDuration];
															 }];
														 }];
}

- (void)settingsTableViewHeaderDidRequestChangeToLanguage:(MZSettingsTableViewHeader *)tableViewHeader {
	[self showOverlayView:YES withDuration:kFadeDuration];

	CGPoint startPoint = CGPointMake(self.tableViewHeader.newLanguageFlagFrame.origin.x + self.tableViewHeader.newLanguageFlagFrame.size.width / 2.0f,
																	 self.tableViewHeader.newLanguageFlagFrame.origin.y + self.tableViewHeader.newLanguageFlagFrame.size.height);

	startPoint = [self.tableView convertPoint:startPoint toView:self.view];

	self.languagePickerView = [MZFlightPickerView displayFlightPickerInView:self.view
																												startingFromPoint:startPoint
																																 withData:self.languageFlagImages
																														 fadeDuration:kFadeDuration
																												 pickAtIndexBlock:
														 ^(NSUInteger selectedIndex) {
															 // (1) Switch languages if selected new language same as known one
															 if ([MZUser currentUser].knownLanguage.integerValue == selectedIndex) {
																 [MZUser currentUser].knownLanguage = [MZUser currentUser].newLanguage;
																 self.tableViewHeader.knownLanguage = [MZUser currentUser].newLanguage.integerValue;
															 }

															 // (2) Update known language
															 [MZUser currentUser].newLanguage = @(selectedIndex);
															 self.tableViewHeader.newLanguage = selectedIndex;

															 // (3) Update views and rest of the application via notification center
															 [[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:^{
																 [[NSNotificationCenter defaultCenter] postNotificationName:MZSettingsDidChangeLanguageNotification
																																										 object:@(selectedIndex)];
																 [self showOverlayView:NO withDuration:kFadeDuration];
																 [self.languagePickerView dismissWithDuration:kFadeDuration];
															 }];
														 }];
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
  default:
			break;
	}
}

#pragma mark - Stepper Table View Cell Delegate Methods

- (void)settingsStepperTableViewCell:(MZSettingsStepperTableViewCell *)cell didUpdateValue:(NSUInteger)value {
	[MZQuizManager sharedManager].quizPerDay = value;
}

#pragma mark - Slider Table View Cell Delegate Methods

- (void)settingsSliderTableViewCell:(MZSettingsSliderTableViewCell *)cell
								 didChangeStartHour:(NSUInteger)startHour
														endHour:(NSUInteger)endHour {
	[MZQuizManager sharedManager].startHour = startHour;
	[MZQuizManager sharedManager].endHour = endHour;
}

@end
