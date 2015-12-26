//
//  MZTextFieldTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLanguageManager.h"

typedef NS_ENUM(NSInteger, MZTextFieldTableViewCellType) {
	MZTextFieldTableViewCellTypeRegular,
	MZTextFieldTableViewCellTypeAddition
};

@protocol MZTextFieldTableViewCellDelegate;

@interface MZTextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;

@property (nonatomic, weak) id<MZTextFieldTableViewCellDelegate> delegate;
@property (nonatomic, assign) MZTextFieldTableViewCellType cellType;
@property (nonatomic, assign) MZLanguage language;

@end

@protocol MZTextFieldTableViewCellDelegate <NSObject>

- (void)textFieldTableViewCellDidTapAddButton:(MZTextFieldTableViewCell *)cell;
- (void)textFieldTableViewCell:(MZTextFieldTableViewCell *)cell textDidChange:(NSString *)text;

@end
