//
//  MZTextFieldTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MZTextFieldTableViewCellType) {
	MZTextFieldTableViewCellTypeRegular,
	MZTextFieldTableViewCellTypeAddition
};

@protocol MZTextFieldTableViewCellDelegate;

@interface MZTextFieldTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;

@property (nonatomic, weak) id<MZTextFieldTableViewCellDelegate> delegate;
@property (nonatomic, assign) MZTextFieldTableViewCellType cellType;
@property (nonatomic, strong, readonly) NSString *cellText;

@end

@protocol MZTextFieldTableViewCellDelegate <NSObject>

- (void)textFieldTableViewCellDidTapAddButton:(MZTextFieldTableViewCell *)cell;

@end
