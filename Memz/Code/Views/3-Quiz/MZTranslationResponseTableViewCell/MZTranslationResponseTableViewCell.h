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

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) id<MZTranslationResponseTableViewCellDelegate> delegate;

@end

@protocol MZTranslationResponseTableViewCellDelegate <NSObject>

@optional

- (void)translationResponseTableViewCellTextFieldDidChange:(MZTranslationResponseTableViewCell *)cell;
- (void)translationResponseTableViewCellTextFieldDidHitReturnButton:(MZTranslationResponseTableViewCell *)cell;

@end