//
//  MZWordAdditionTableViewHeader.m
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZWordAdditionTableViewHeader.h"

@implementation MZWordAdditionTableViewHeader

- (void)awakeFromNib {
	[super awakeFromNib];

	self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	self.backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
	return self.backgroundView.backgroundColor;
}

@end
