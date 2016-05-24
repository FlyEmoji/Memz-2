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
	MZTutorialViewTypeSettings,
	MZTutorialViewTypePresentableView
};

@protocol MZTutorialViewProtocol;

@interface MZTutorialView : MZNibView

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) id<MZTutorialViewProtocol> delegate;
@property (nonatomic, assign) MZTutorialViewType type;  // not animated

+ (instancetype)showInView:(UIView *)view
									withType:(MZTutorialViewType)type
									delegate:(id<MZTutorialViewProtocol>)delegate;  // animated

- (void)dismiss;  // animated

- (void)setType:(MZTutorialViewType)type animated:(BOOL)animated;

@end

@protocol MZTutorialViewProtocol <NSObject>

@optional

- (void)tutorialView:(MZTutorialView *)view didRequestDismissForType:(MZTutorialViewType)type;

@end