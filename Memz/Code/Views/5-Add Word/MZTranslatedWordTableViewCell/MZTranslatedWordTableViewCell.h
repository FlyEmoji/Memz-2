//
//  MZTranslatedWordTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZTranslatedWordTableViewCellDelegate;

@interface MZTranslatedWordTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MZTranslatedWordTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *translatedWordLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;

@end

@protocol MZTranslatedWordTableViewCellDelegate <NSObject>

- (void)translatedWordTableViewCellDidTapRemoveButton:(MZTranslatedWordTableViewCell *)cell;

@end