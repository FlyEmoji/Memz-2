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

const CGFloat kFlightPickerWidth = 60.0f;
const CGFloat kBottomSpaceInset = 30.0f;
const CGFloat kCornerRadius = 5.0f;

const CGFloat kTableViewCellHeight = 50.0f;

@interface MZFlightPickerView () <UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (nonatomic, copy) MZFlightPickerCompletionHandler completionBlock;

@end

@implementation MZFlightPickerView

+ (MZFlightPickerView *)displayFlightPickerInView:(UIView *)containerView
																startingFromPoint:(CGPoint)topCenterPoint
																				 withData:(NSArray<UIImage *> *)data
																		 fadeDuration:(NSTimeInterval)duration
																 pickAtIndexBlock:(MZFlightPickerCompletionHandler)completionHandler {
	MZFlightPickerView *flightPickerView = [[MZFlightPickerView alloc] init];
	flightPickerView.pickableData = data;
	flightPickerView.completionBlock = completionHandler;
	flightPickerView.frame = CGRectMake(topCenterPoint.x - kFlightPickerWidth / 2.0f,
																			topCenterPoint.y,
																			kFlightPickerWidth,
																			fmin(containerView.frame.size.height - topCenterPoint.y - kBottomSpaceInset,
																					 data.count * kTableViewCellHeight + flightPickerView.tableViewTopConstraint.constant));
	flightPickerView.layer.cornerRadius = kCornerRadius;
	flightPickerView.layer.masksToBounds = YES;
	flightPickerView.alpha = 0.0f;

	[containerView addSubview:flightPickerView];

	[UIView animateWithDuration:duration animations:^{
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
	self.opaque = NO;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	UIBezierPath *graphPath = [[UIBezierPath alloc] init];

	[graphPath moveToPoint:CGPointMake(rect.size.width / 2.0f, 0.0f)];
	[graphPath addLineToPoint:CGPointMake(rect.size.width, self.tableView.frame.origin.y)];
	[graphPath addLineToPoint:CGPointMake(0.0f, self.tableView.frame.origin.y)];
	[graphPath closePath];

	[self.tableView.backgroundColor setFill];
	[graphPath fill];

	CGContextRestoreGState(context);
}

#pragma mark - Public

- (void)dismissWithDuration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		self.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

#pragma mark - Table View Data Source & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.pickableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MZFlightPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFlightPickerViewCellIdentifier
																																 forIndexPath:indexPath];
	cell.pickerImageView.image = self.pickableData[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.completionBlock) {
		self.completionBlock(indexPath.row);
	}
}

@end
