//
//  MZEmptyStateView.m
//  Memz
//
//  Created by Bastien Falcou on 5/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZEmptyStateView.h"

@interface MZEmptyStateView ()

@property (nonatomic, weak) IBOutlet UIImageView *emptyStateImageView;
@property (nonatomic, weak) IBOutlet UILabel *emptyStateLabel;

@end

@implementation MZEmptyStateView

- (void)awakeFromNib {
	[super awakeFromNib];

	[self updateElements];
}

- (void)updateElements {
	self.emptyStateImageView.image = self.emptyStateImage;
	self.emptyStateLabel.text = self.emptyStateDescription;
}

#pragma mark - Custom Setters

- (void)setEmptyStateImage:(UIImage *)emptyStateImage {
	_emptyStateImage = emptyStateImage;

	[self updateElements];
}

- (void)setEmptyStateDescription:(NSString *)emptyStateDescription {
	_emptyStateDescription = emptyStateDescription;

	[self updateElements];
}

@end
