//
//  MZLanguageCollectionViewCell.m
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZLanguageCollectionViewCell.h"
#import "MZCollectionViewLayoutAttributes.h"
#import "UIImage+MemzAdditions.h"
#import "NSString+MemzAdditions.h"

NSString * const kAnimationKey = @"MZLanguageCollectionViewCellAnimationKey";

@interface MZLanguageCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UILabel *languageTitleLabel;

@end

@implementation MZLanguageCollectionViewCell

#pragma mark - Custom Setter

- (void)setLanguage:(MZLanguage)language {
	_language = language;

	self.flagImageView.image = [UIImage flagImageForLanguage:language];
	self.languageTitleLabel.text = [NSString languageNameForLanguage:language];
}

#pragma mark - Animation

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	MZCollectionViewLayoutAttributes *attributes = [layoutAttributes safeCastToClass:[MZCollectionViewLayoutAttributes class]];
	[[self layer] addAnimation:attributes.animation forKey:kAnimationKey];
}

@end
