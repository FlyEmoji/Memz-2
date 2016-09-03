//
//  UILabel+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 5/24/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UILabel+MemzAdditions.h"

const CGFloat kEmptyStateLabelParagraphSpacing = 6.0f;

@implementation UILabel (MemzAdditions)

- (void)applyParagraphStyle {
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = kEmptyStateLabelParagraphSpacing;
	paragraphStyle.alignment = NSTextAlignmentCenter;

	NSDictionary *attributes = @{NSFontAttributeName: self.font,
															 NSForegroundColorAttributeName: self.textColor,
															 NSParagraphStyleAttributeName: paragraphStyle};

	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text
																																										 attributes:attributes];
	self.attributedText = attributedText;
}

@end
