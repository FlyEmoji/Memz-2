//
//  MZTranslatedWordTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLanguageDefinition.h"

@protocol MZTranslatedWordTableViewCellDelegate;

@interface MZTranslatedWordTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MZTranslatedWordTableViewCellDelegate> delegate;
@property (nonatomic, assign) MZLanguage language;

@property (nonatomic, strong) IBOutlet UILabel *translatedWordLabel;

@end

@protocol MZTranslatedWordTableViewCellDelegate <NSObject>

- (void)translatedWordTableViewCellDidTapRemoveButton:(MZTranslatedWordTableViewCell *)cell;

@end