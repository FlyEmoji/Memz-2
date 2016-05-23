//
//  MZTutorialView.h
//  Memz
//
//  Created by Bastien Falcou on 5/22/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"

typedef NS_ENUM(NSInteger, MZTutorialViewType) {
	MZTutorialViewTypeAddWord,
	MZTutorialViewTypeSettings
};

@protocol MZTutorialViewProtocol;

@interface MZTutorialView : MZNibView

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) id<MZTutorialViewProtocol> delegate;
@property (nonatomic, assign) MZTutorialViewType type;  // not animated

- (void)setType:(MZTutorialViewType)type animated:(BOOL)animated;

@end

@protocol MZTutorialViewProtocol <NSObject>

@optional

- (void)tutorialView:(MZTutorialView *)view didRequestDismissForType:(MZTutorialViewType)type;

@end