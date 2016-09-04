//
//  MZWordAdditionTableViewHeader.h
//  Memz
//
//  Created by Bastien Falcou on 12/17/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MZWordAdditionSectionType) {
	MZWordAdditionSectionTypeWord,
	MZWordAdditionSectionTypeSuggestions,
	MZWordAdditionSectionTypeManual,
	MZWordAdditionSectionTypeTranslations
};

@protocol MZWordAdditionTableViewHeaderDelegate;

@interface MZWordAdditionTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, assign) MZWordAdditionSectionType sectionType;
@property (nonatomic, weak) id<MZWordAdditionTableViewHeaderDelegate> delegate;

@end

@protocol MZWordAdditionTableViewHeaderDelegate <NSObject>

@optional

- (void)wordAdditionTableViewHeaderDidTapClearButton:(MZWordAdditionTableViewHeader *)tableViewHeader;

@end