//
//  MZStatisticsExtendedNavigationBarView.h
//  Memz
//
//  Created by Bastien Falcou on 2/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MZStatisticsGranularity) {
	MZStatisticsGranularityDay,
	MZStatisticsGranularityWeek,
	MZStatisticsGranularityMonth,
	MZStatisticsGranularityYear
};

/*
 * Extended navigation bar view containing statistics segmented control.
 * This implementation is based on an Apple sample code project found here: 
 * https://developer.apple.com/library/ios/samplecode/NavBar/Introduction/Intro.html
 */

@protocol MZStatisticsExtendedNavigationBarViewDelegate;

@interface MZStatisticsExtendedNavigationBarView : UIView

@property (nonatomic, strong) id<MZStatisticsExtendedNavigationBarViewDelegate> delegate;

@end

@protocol MZStatisticsExtendedNavigationBarViewDelegate <NSObject>

@optional

- (void)statisticsExtendedNavigationBarView:(MZStatisticsExtendedNavigationBarView *)view
						 didSelectStatisticsGranularity:(MZStatisticsGranularity)granularity;

@end