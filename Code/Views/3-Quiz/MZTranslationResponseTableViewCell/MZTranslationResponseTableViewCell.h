//
//  MZTranslationResponseTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTableViewCell.h"

typedef NS_ENUM(NSUInteger, MZTranslationResponseTableViewCellType) {
	MZTranslationResponseTableViewCellTypeUnaswered = 0,
	MZTranslationResponseTableViewCellTypeAnswered
};

@protocol MZTranslationResponseTableViewCellDelegate;

@interface MZTranslationResponseTableViewCell : MZTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, weak) id<MZTranslationResponseTableViewCellDelegate> delegate;
@property (nonatomic, assign, readonly) MZTranslationResponseTableViewCellType status;

- (void)setStatus:(MZTranslationResponseTableViewCellType)status
	userTranslation:(NSString *)userTranslation
			 correction:(NSString *)correction
					isRight:(BOOL)isRight;

@end

@protocol MZTranslationResponseTableViewCellDelegate <NSObject>

@optional

- (void)translationResponseTableViewCellTextFieldDidChange:(MZTranslationResponseTableViewCell *)cell;
- (void)translationResponseTableViewCellTextFieldDidHitReturnButton:(MZTranslationResponseTableViewCell *)cell;

@end