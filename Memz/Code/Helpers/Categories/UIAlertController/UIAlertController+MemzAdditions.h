//
//  UIAlertController+MemzAdditions.h
//  Memz
//
//  Created by Bastien Falcou on 2/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

const NSUInteger MZButtonIndexRangeLength = 4;

#define MZ_GET_BIT_RANGE(var, position, length) (((var) >> ((position) * (length))) & ((1 << (length)) - 1))
#define MZ_BIT_RANGE(position, length, range) (((range) & ((1 << (length)) - 1)) << ((position) * (length)))

#define MZCancelButtonIndex(integer) MZ_GET_BIT_RANGE(integer, 2, MZButtonIndexRangeLength)
#define MZDestructiveButtonIndex(integer) MZ_GET_BIT_RANGE(integer, 1, MZButtonIndexRangeLength)
#define MZTappedButtonIndex(integer) MZ_GET_BIT_RANGE(integer, 0, MZButtonIndexRangeLength)

#define MZIsCancelButtonIndex(integer) (MZTappedButtonIndex(integer) == MZCancelButtonIndex(integer))
#define MZIsDestructiveButtonIndex(integer) (MZTappedButtonIndex(integer) == MZDestructiveButtonIndex(integer))
#define MZIsTappedButtonIndex(integer, indexToTest) (MZTappedButtonIndex(integer) == (indexToTest))

NSUInteger _MZCancelButtonIndex(NSUInteger indexes);
NSUInteger _MZDestructiveButtonIndex(NSUInteger indexes);
NSUInteger _MZTappedButtonIndex(NSUInteger indexes);

BOOL _MZIsTappedButtonIndex(NSUInteger indexes, NSUInteger indexToTest);
BOOL _MZIsDestructiveButtonIndex(NSUInteger indexes);
BOOL _MZIsCancelButtonIndex(NSUInteger indexes);

typedef void (^ UIAlertControllerButtonClickedBlock)(UIAlertController *alertController, NSUInteger indexes);

@interface UIAlertController (MemzAdditions)

/*
 * This category provides with convenience methods that show an alert controller view and handle the button tapped in its block.
 * Leave block nil and buttons will automatically dismiss the alert when tapped.
 */
+ (void)showWithStyle:(UIAlertControllerStyle)style
								title:(NSString *)title
							message:(NSString *)message
								block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
		cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showWithStyle:(UIAlertControllerStyle)style
								title:(NSString *)title
							message:(NSString *)message
								block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
		cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
		otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithStyle:(UIAlertControllerStyle)style
												title:(NSString *)title
											message:(NSString *)message
												block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
						cancelButtonTitle:(NSString *)cancelButtonTitle
						otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithStyle:(UIAlertControllerStyle)style
												title:(NSString *)title
											message:(NSString *)message
												block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
						cancelButtonTitle:(NSString *)cancelButtonTitle
			 destructiveButtonTitle:(NSString *)destructiveButtonTitle
						otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
