//
//  MZStatisticsExtendedNavigationBarView.m
//  Memz
//
//  Created by Bastien Falcou on 2/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZStatisticsExtendedNavigationBarView.h"

@interface MZStatisticsExtendedNavigationBarView ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MZStatisticsExtendedNavigationBarView

- (void)willMoveToWindow:(UIWindow *)newWindow {
	// (1) Use the layer shadow to draw a one pixel hairline under this view.
	self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f / UIScreen.mainScreen.scale);
	self.layer.shadowRadius = 0.0f;

	// (2) UINavigationBar's hairline is adaptive, its properties change with
	// the contents it overlies.
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.25f;
}

#pragma mark - Actions

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
	if ([self.delegate respondsToSelector:@selector(statisticsExtendedNavigationBarView:didSelectStatisticsGranularity:)]) {
		[self.delegate statisticsExtendedNavigationBarView:self
												didSelectStatisticsGranularity:segmentedControl.selectedSegmentIndex];
	}
}

@end
