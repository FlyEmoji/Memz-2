//
//  MZFlightPickerView.m
//  Memz
//
//  Created by Bastien Falcou on 5/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZFlightPickerView.h"
#import "MZFlightPickerViewCell.h"

NSString * const kFlightPickerViewCellIdentifier = @"MZFlightPickerViewCellIdentifier";

const CGFloat kFlightPickerWidth = 40.0f;
const CGFloat kBottomSpaceInset = 30.0f;
const NSTimeInterval kFadeInOutAnimationDuration = 0.3;

@interface MZFlightPickerView () <UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) MZFlightPickerCompletionHandler completionBlock;

@end

@implementation MZFlightPickerView

+ (MZFlightPickerView *)displayFlightPickerInView:(UIView *)containerView
																startingFromPoint:(CGPoint)topCenterPoint
																				 withData:(NSArray<UIImage *> *)data
																				 animated:(BOOL)animated
																 pickAtIndexBlock:(MZFlightPickerCompletionHandler)completionHandler {
	MZFlightPickerView *flightPickerView = [[MZFlightPickerView alloc] init];
	flightPickerView.pickableData = data;
	flightPickerView.completionBlock = completionHandler;
	flightPickerView.frame = CGRectMake(topCenterPoint.x - kFlightPickerWidth,
																			topCenterPoint.y,
																			kFlightPickerWidth,
																			containerView.frame.size.height - topCenterPoint.y - kBottomSpaceInset);
	flightPickerView.alpha = 0.0f;
	[containerView addSubview:flightPickerView];

	[UIView animateWithDuration:animated ? kFadeInOutAnimationDuration : 0.0 animations:^{
		flightPickerView.alpha = 1.0f;
	}];
	
	return flightPickerView;
}

#pragma mark - Initializers

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZFlightPickerViewCell class]) bundle:nil]
			 forCellReuseIdentifier:kFlightPickerViewCellIdentifier];
}

#pragma mark - Public 

- (void)dismissAnimated:(BOOL)animated {
	if (self.completionBlock) {
		self.completionBlock(NO_INDEX);
		self.completionBlock = nil;
	}

	[UIView animateWithDuration:animated ? kFadeInOutAnimationDuration : 0.0 animations:^{
		self.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.pickableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZFlightPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFlightPickerViewCellIdentifier
																																 forIndexPath:indexPath];
	cell.imageView.image = self.pickableData[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.completionBlock) {
		self.completionBlock(indexPath.row);
	}
}

@end
