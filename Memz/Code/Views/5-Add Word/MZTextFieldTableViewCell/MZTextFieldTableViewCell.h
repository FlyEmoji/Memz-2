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

@interface MZTextFieldTableViewCell : UITableViewCell

@property (nonatomic, assign) MZTextFieldTableViewCellType cellType;

@property (nonatomic, assign, getter=isShowingBottomSeparator) BOOL showBottomSeparator;
@property (nonatomic, assign) UIColor *separatorColor;

@end
