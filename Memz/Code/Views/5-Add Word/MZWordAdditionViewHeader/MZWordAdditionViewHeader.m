//
//  MZWordAdditionViewHeader.m
//  Memz
//
//  Created by Bastien Falcou on 5/1/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZWordAdditionViewHeader.h"

@interface MZWordAdditionViewHeader ()

@property (nonatomic, strong) IBOutlet UIButton *addButton;

@end

@implementation MZWordAdditionViewHeader

#pragma mark - Custom Getters / Setters

- (BOOL)isEnabled {
	return self.addButton.enabled;
}

- (void)setEnable:(BOOL)enable {
	self.addButton.enabled = enable;
}

#pragma mark - Actions

- (IBAction)addButtonTapped:(id)sender {
	if ([self.delegate respondsToSelector:@selector(wordAdditionViewHeaderDidTapAddButton:)]) {
		[self.delegate wordAdditionViewHeaderDidTapAddButton:self];
	}
}

@end
