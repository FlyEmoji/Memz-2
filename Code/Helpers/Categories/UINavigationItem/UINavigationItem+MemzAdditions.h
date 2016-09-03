//
//  UINavigationItem+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ MZCustomBackButtonActionCompletedBlock)(BOOL completed);
typedef void (^ MZCustomBackButtonActionBlock)(UIButton * backButton, MZCustomBackButtonActionCompletedBlock completedBlock);

@interface UINavigationItem (MemzAdditions)

- (NSString *)nextBackButtonTitle;

- (void)setNextBackButtonTitle:(NSString *)backButtonTitle;

/**
 *  Change or retrieve the next custom back button title.
 *  This returns nil if the back button title is set by the OS.
 *
 *  @note This method won't retrieve or set the back button title that is currently displayed. See currentBackButtonTitle in UINavigationController+MemzTransitions for that purpose.
 */
@property (nonatomic, copy, setter=setNextBackButtonTitle:) NSString *nextBackButtonTitle;

/**
 *  Returns the current back button action block.
 *
 *  @discussion This function assign a custom leftBarButtonItem to the navigation item, containing a button aligned that mimics iOS 7 behavior.
 *
 *  @return The current back button action block, or nil if none is set.
 */
- (MZCustomBackButtonActionBlock)customBackButtonActionBlock;

/**
 *  Returns the current custom back button.
 *
 *  @return The custom back button, or nil if none has been created yet.
 */
- (UIButton *)customBackButton;

/**
 *  Set the back button title. If no custom back button already exists, it is created with an empty action block.

 *  @discussion An empty action block means that tapping on the button won't do anything.
 *              If an action block is needed later, use setCustomBackButtonAction:.
 *  @param title The back button title. If nil, no title is displayed.
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonTitle:(NSString *)title;

/**
 *  Set the back button action block with no title.
 *
 *  @param actionBlock The back button action block, called whenever the user taps on the back button.
 *
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonActionBlock:(MZCustomBackButtonActionBlock)actionBlock;

/**
 *  Set the back button action block.
 *
 *  @discussion This function calls setCustomBackButtonWithImage, creating a button that mimics the iOS 7 built-in back button and calls the block when tapped.
 *
 *  @param actionBlock The back button action block, called whenever the user taps on the back button.
 *  @param title       The back button title. If nil, no title is displayed.
 *
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonActionBlock:(MZCustomBackButtonActionBlock)actionBlock title:(NSString *)title;

/**
 *  Create a custom back buttom using the specified image, and no title.
 *
 *  @param image       The image to use for the custom back button.
 *  @param actionBlock The back button action block, called whenever the user taps on the back button. Whenever the action done in actionBlock is finished,
 *                     completedBlock must be called, with a value of YES if the button is not going to be displayed anymore, and NO otherwise.
 *
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonWithImage:(UIImage *)image actionBlock:(MZCustomBackButtonActionBlock)actionBlock;

/**
 *  Create a custom back buttom using the specified image and title.
 *
 *  @param image       The image to use for the custom back button.
 *  @param title       The title to use for the custom back button.
 *  @param actionBlock The back button action block, called whenever the user taps on the back button. Whenever the action done in actionBlock is finished,
 *                     completedBlock must be called, with a value of YES if the button is not going to be displayed anymore, and NO otherwise.
 *
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonWithImage:(UIImage *)image
																		 title:(NSString *)title
															 actionBlock:(MZCustomBackButtonActionBlock)actionBlock;

/**
 *  Create a custom back buttom using the specified button type, image and title.
 *
 *  @param buttonType  The button type to use.
 *  @param image       The image to use for the custom back button.
 *  @param title       The title to use for the custom back button.
 *  @param actionBlock The back button action block, called whenever the user taps on the back button. Whenever the action done in actionBlock is finished,
 *                     completedBlock must be called, with a value of YES if the button is not going to be displayed anymore, and NO otherwise.
 *
 *  @return Returns the created button, allowing for further customization. Can later be retrieved using customBackButton.
 */
- (UIButton *)setCustomBackButtonWithType:(UIButtonType)buttonType
																		image:(UIImage *)image
																		title:(NSString *)title
															actionBlock:(MZCustomBackButtonActionBlock)actionBlock;

/**
 *  Remove the custom back button, if one is set.
 */
- (void)removeCustomBackButton;

@end
