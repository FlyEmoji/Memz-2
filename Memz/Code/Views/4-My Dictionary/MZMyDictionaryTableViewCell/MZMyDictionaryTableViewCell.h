//
//  MZMyDictionaryTableViewCell.h
//  Memz
//
//  Created by Bastien Falcou on 12/19/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZWord+CoreDataProperties.h"

@interface MZMyDictionaryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;

- (void)setupTranslations:(NSArray<MZWord *> *)translations;

@end
