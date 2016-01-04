//
//  MZTranslationResponseTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/28/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZTranslationResponseTableViewCellDelegate;

@interface MZTranslationResponseTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, weak) id<MZTranslationResponseTableViewCellDelegate> delegate;

- (void)switchToCorrectionDisplayIsRight:(BOOL)isRight correctionText:(NSString *)correction;

@end

@protocol MZTranslationResponseTableViewCellDelegate <NSObject>

@optional

- (void)translationResponseTableViewCellTextFieldDidChange:(MZTranslationResponseTableViewCell *)cell;
- (void)translationResponseTableViewCellTextFieldDidHitReturnButton:(MZTranslationResponseTableViewCell *)cell;

@end