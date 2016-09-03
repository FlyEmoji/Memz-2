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
		case MZAssetIdentifierCommonIconWhite:
			return [UIImage imageNamed:@"Common-Icon-White"];
		case MZAssetIdentifierCommonIconWhiteShadows:
			return [UIImage imageNamed:@"Common-Icon-White-Shadows"];
		case MZAssetIdentifierCommonIconBlue:
			return [UIImage imageNamed:@"Common-Icon-Blue"];
		case MZAssetIdentifierCommonIconBlueShadows:
			return [UIImage imageNamed:@"Common-Icon-Blue-Shadows"];
		case MZAssetIdentifierCommonTitleIcon:
			return [UIImage imageNamed:@"Common-Titled-Logo"];
		case MZAssetIdentifierCommonCross:
			return [UIImage imageNamed:@"Common-Cross"];
		case MZAssetIdentifierCommonTick:
			return [UIImage imageNamed:@"Common-Tick"];
		case MZAssetIdentifierCommonSocialTwitter:
			return [UIImage imageNamed:@"Common-Social-Twitter"];
		case MZAssetIdentifierCommonSocialFacebook:
			return [UIImage imageNamed:@"Common-Social-Facebook"];
		case MZAssetIdentifierCommonCarouselDotInactive:
			return [UIImage imageNamed:@"Common-Carousel-Dot-Inactive"];
		case MZAssetIdentifierCommonCarouselDotActive:
			return [UIImage imageNamed:@"Common-Carousel-Dot-Active"];
		case MZAssetIdentifierCommonLoaderLarge:
			return [UIImage imageNamed:@"Loader-Large"];
		case MZAssetIdentifierCommonGradient:
			return [UIImage imageNamed:@"Common-Gradient"];
		case MZAssetIdentifierCommonGradientReversed:
			return [UIImage imageNamed:@"Common-Gradient-Reversed"];
		case MZAssetIdentifierCommonTutorialRightArrow:
			return [UIImage imageNamed:@"Common-Tutoral-Right-Arrow"];
		case MZAssetIdentifierCommonTutorialLeftArrow:
			return [UIImage imageNamed:@"Common-Tutoral-Left-Arrow"];
		case MZAssetIdentifierCommonMask:
			return [UIImage imageNamed:@"Common-Mask"];
		case MZAssetIdentifierUserEntranceFlag:
			return [UIImage imageNamed:@"User-Entrance-Flag"];
		case MZAssetIdentifierUserEntranceDictionary:
			return [UIImage imageNamed:@"User-Entrance-Dictionary"];
		case MZAssetIdentifierUserEntranceNotification:
			return [UIImage imageNamed:@"User-Entrance-Notification"];
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
		case MZAssetIdentifierFeedActiveTick:
			return [UIImage imageNamed:@"Feed-Active-Tick"];
		case MZAssetIdentifierQuizEmptyState:
			return [UIImage imageNamed:@"Quiz-Empty-State"];
		case MZAssetIdentifierQuizChronometerIcon:
			return [UIImage imageNamed:@"Quiz-Chronometer-Icon"];
		case MZAssetIdentifierMyDictionaryEmptyState:
			return [UIImage imageNamed:@"My-Dictionary-Empty-State"];
		case MZAssetIdentifierAddWordMinusIcon:
			return [UIImage imageNamed:@"Add-Word-Minus-Icon"];
		case MZAssetIdentifierAddWordPlusIcon:
			return [UIImage imageNamed:@"Add-Word-Plus-Icon"];
		case MZAssetIdentifierAddWordTriangleIcon:
			return [UIImage imageNamed:@"Add-Word-Triangle-Icon"];
		case MZAssetIdentifierSettingsRangeSlider:
			return [UIImage imageNamed:@"Settings-Range-Slider"];
		case MZAssetIdentifierSettingSliderLineFaded:
			return [UIImage imageNamed:@"Settings-Slider-Line-Faded"];
		case MZAssetIdentifierSettingSliderLineChosen:
			return [UIImage imageNamed:@"Settings-Slider-Line-Chosen"];
		}
	NSAssert(NO, @"+[UIImage imageWithAssetIdentifier:]: Invalid asset identifier provided '%ld'", (long)assetIdentifier);
	return nil;
}

@end
