//
//  UIImage+AssetIdentifiers.h
//  Memz
//
//  Created by Bastien Falcou on 1/5/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UIKit;

typedef NS_ENUM(NSInteger, MZAssetIdentifier) {
	MZAssetIdentifierFlagFrance,
	MZAssetIdentifierFlagUnitedKingdom,
	MZAssetIdentifierFlagSpain,
	MZAssetIdentifierFlagItalie,
	MZAssetIdentifierFlagPortugal,
	MZAssetIdentifierCommonCross,
	MZAssetIdentifierCommonTick,
	MZAssetIdentifierCommonSocialTwitter,
	MZAssetIdentifierCommonSocialFacebook,
	MZAssetIdentifierCommonLoaderLarge,
	MZAssetIdentifierCommonCarouselDotInactive,
	MZAssetIdentifierCommonCarouselDotActive,
	MZAssetIdentifierCommonGradient,
	MZAssetIdentifierCommonGradientReversed,
	MZAssetIdentifierNavigationBarPixel,
	MZAssetIdentifierNavigationBarTransparentPixel,
	MZAssetIdentifierNavigationAdd,
	MZAssetIdentifierNavigationBack,
	MZAssetIdentifierNavigationCancel,
	MZAssetIdentifierNavigationSettings,
	MZAssetIdentifierNavigationLargeTick,
	MZAssetIdentifierNavigationForwardTap,
	MZAssetIdentifierFeedActiveTick,
	MZAssetIdentifierQuizEmptyState,
	MZAssetIdentifierMyDictionaryEmptyState,
	MZAssetIdentifierAddWordMinusIcon,
	MZAssetIdentifierAddWordPlusIcon,
	MZAssetIdentifierAddWordTriangleIcon,
	MZAssetIdentifierSettingsRangeSlider,
	MZAssetIdentifierSettingSliderLineFaded,
	MZAssetIdentifierSettingSliderLineChosen
};

@interface UIImage (AssetIdentifier)

+ (instancetype)imageWithAssetIdentifier:(MZAssetIdentifier)assetIdentifier;

@end

