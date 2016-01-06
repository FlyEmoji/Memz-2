//
//  UIImage+AssetIdentifiers.m
//  Memz
//
//  Created by Bastien Falcou on 1/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UIImage+AssetIdentifiers.h"

@implementation UIImage (AssetIdentifiers)

+ (instancetype)imageWithAssetIdentifier:(MZAssetIdentifier)assetIdentifier {
	switch (assetIdentifier) {
		case MZAssetIdentifierFlagFrance:
			return [UIImage imageNamed:@"Flag-France"];
		case MZAssetIdentifierFlagUnitedKingdom:
			return [UIImage imageNamed:@"Flag-United-Kingdom"];
		case MZAssetIdentifierNavigationAdd:
			return [UIImage imageNamed:@"Navigation-Add"];
		case MZAssetIdentifierNavigationBack:
			return [UIImage imageNamed:@"Navigation-Back"];
		case MZAssetIdentifierNavigationCancel:
			return [UIImage imageNamed:@"Navigation-Cancel"];
		case MZAssetIdentifierNavigationSettings:
			return [UIImage imageNamed:@"Navigation-Settings"];
		case MZAssetIdentifierFeedGradient:
			return [UIImage imageNamed:@"Feed-Gradient"];
		case MZAssetIdentifierQuizBell:
			return [UIImage imageNamed:@"Quiz-Bell"];
		case MZAssetIdentifierQuizCross:
			return [UIImage imageNamed:@"Quiz-Cross"];
		case MZAssetIdentifierQuizTick:
			return [UIImage imageNamed:@"Quiz-Tick"];
		case MZAssetIdentifierAddWordMinusIcon:
			return [UIImage imageNamed:@"Add-Word-Minus-Icon"];
		case MZAssetIdentifierAddWordPlusIcon:
			return [UIImage imageNamed:@"Add-Word-Plus-Icon"];
		case MZAssetIdentifierAddWordTriangleIcon:
			return [UIImage imageNamed:@"Add-Word-Triangle-Icon"];
		}
	NSAssert(NO, @"+[UIImage imageWithAssetIdentifier:]: Invalid asset identifier provided '%ld'", (long)assetIdentifier);
	return nil;
}

@end
