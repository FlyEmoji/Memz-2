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
		case MZAssetIdentifierFlagSpain:
			return [UIImage imageNamed:@"Flag-Spain"];
		case MZAssetIdentifierFlagItalie:
			return [UIImage imageNamed:@"Flag-Italy"];
		case MZAssetIdentifierFlagPortugal:
			return [UIImage imageNamed:@"Flag-Portugal"];
		case MZAssetIdentifierCommonCross:
			return [UIImage imageNamed:@"Common-Cross"];
		case MZAssetIdentifierCommonTick:
			return [UIImage imageNamed:@"Common-Tick"];
		case MZAssetIdentifierCommonSocialTwitter:
			return [UIImage imageNamed:@"Common-Social-Twitter"];
		case MZAssetIdentifierCommonSocialFacebook:
			return [UIImage imageNamed:@"Common-Social-Facebook"];
		case MZAssetIdentifierNavigationBarPixel:
			return [UIImage imageNamed:@"Navigation-Bar-Pixel"];
		case MZAssetIdentifierNavigationBarTransparentPixel:
			return [UIImage imageNamed:@"Navigation-Bar-Transparent-Pixel"];
		case MZAssetIdentifierNavigationAdd:
			return [UIImage imageNamed:@"Navigation-Add"];
		case MZAssetIdentifierNavigationBack:
			return [UIImage imageNamed:@"Navigation-Back"];
		case MZAssetIdentifierNavigationCancel:
			return [UIImage imageNamed:@"Navigation-Cancel"];
		case MZAssetIdentifierNavigationSettings:
			return [UIImage imageNamed:@"Navigation-Settings"];
		case MZAssetIdentifierNavigationLargeTick:
			return [UIImage imageNamed:@"Navigation-Large-Tick"];
		case MZAssetIdentifierNavigationForwardTap:
			return [UIImage imageNamed:@"Navigation-Forward-Tap"];
		case MZAssetIdentifierFeedGradient:
			return [UIImage imageNamed:@"Feed-Gradient"];
		case MZAssetIdentifierFeedActiveTick:
			return [UIImage imageNamed:@"Feed-Active-Tick"];
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
