//
//  MZTranslationResponseTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MZTranslationResponseTableViewCellType) {
	MZTranslationResponseTableViewCellTypeUnaswered = 0,
	MZTranslationResponseTableViewCellTypeAnswered
};

@protocol MZTranslationResponseTableViewCellDelegate;

@interface MZTranslationResponseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

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