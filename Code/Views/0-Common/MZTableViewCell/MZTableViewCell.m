//
//  MZTableViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 5/10/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZTableViewCell.h"

@interface MZTableViewCell ()

@end

@implementation MZTableViewCell

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
	UIView *selectedBackgroundView = [[UIView alloc] init];
	selectedBackgroundView.backgroundColor = selectedBackgroundColor;
	self.selectedBackgroundView = selectedBackgroundView;
}

- (UIColor *)selectedBackgroundColor {
	return self.selectedBackgroundView.backgroundColor;
}

@end
