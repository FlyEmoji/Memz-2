//
//  UIAlertController+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 2/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "UIAlertController+MemzAdditions.h"
#import "UIViewController+MemzAdditions.h"

#define CANCEL_BUTTON_INDEX(index) MZ_BIT_RANGE(2, MZButtonIndexRangeLength, index)
#define DESTRUCTIVE_BUTTON_INDEX(index) MZ_BIT_RANGE(1, MZButtonIndexRangeLength, index)
#define TAPPED_BUTTON_INDEX(index) MZ_BIT_RANGE(0, MZButtonIndexRangeLength, index)

#define GET_BUTTON_INDEXES(cancelButtonIndex, destructiveButtonIndex, tappedButtonIndex) ((CANCEL_BUTTON_INDEX(cancelButtonIndex)) | (DESTRUCTIVE_BUTTON_INDEX(destructiveButtonIndex)) | (TAPPED_BUTTON_INDEX(tappedButtonIndex)))

NSUInteger _MZCancelButtonIndex(NSUInteger indexes) {
	return MZCancelButtonIndex(indexes);
}

NSUInteger _MZDestructiveButtonIndex(NSUInteger indexes) {
	return MZCancelButtonIndex(indexes);
}

NSUInteger _MZTappedButtonIndex(NSUInteger indexes) {
	return MZTappedButtonIndex(indexes);
}

BOOL _MZIsTappedButtonIndex(NSUInteger indexes, NSUInteger indexToTest) {
	return MZIsTappedButtonIndex(indexes, indexToTest);
}

BOOL _MZIsDestructiveButtonIndex(NSUInteger indexes) {
	return MZIsDestructiveButtonIndex(indexes);
}

BOOL _MZIsCancelButtonIndex(NSUInteger indexes) {
	return MZIsCancelButtonIndex(indexes);
}

@implementation UIAlertController (MemzAdditions)

#pragma mark - Show

+ (void)showWithStyle:(UIAlertControllerStyle)style
								title:(NSString *)title
							message:(NSString *)message
								block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
		cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitles:(NSString *)otherButtonTitles, ... {
	va_list args;
	va_start(args, otherButtonTitles);

	UIAlertController *alertController = [[UIAlertController alloc] initWithTitle:title
																																				message:message
																																 preferredStyle:style
																																					block:buttonClickedBlock
																															cancelButtonTitle:cancelButtonTitle
																												 destructiveButtonTitle:nil
																															otherButtonTitles:otherButtonTitles
																																					 args:args];

	va_end(args);
	[[UIViewController topMostViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showWithStyle:(UIAlertControllerStyle)style
								title:(NSString *)title
							message:(NSString *)message
								block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
		cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
		otherButtonTitles:(NSString *)otherButtonTitles, ... {
	va_list args;
	va_start(args, otherButtonTitles);

	UIAlertController *alertController = [[UIAlertController alloc] initWithTitle:title
																																				message:message
																																 preferredStyle:style
																																					block:buttonClickedBlock
																															cancelButtonTitle:cancelButtonTitle
																												 destructiveButtonTitle:destructiveButtonTitle
																															otherButtonTitles:otherButtonTitles
																																					 args:args];

	va_end(args);
	[[UIViewController topMostViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Init

- (id)initWithStyle:(UIAlertControllerStyle)style
							title:(NSString *)title
						message:(NSString *)message
							block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
	cancelButtonTitle:(NSString *)cancelButtonTitle
	otherButtonTitles:(NSString *)otherButtonTitles, ... {
	va_list args;
	va_start(args, otherButtonTitles);

	UIAlertController *alertController = [self initWithTitle:title
																									 message:message
																						preferredStyle:style
																										 block:buttonClickedBlock
																				 cancelButtonTitle:cancelButtonTitle
																		destructiveButtonTitle:nil
																				 otherButtonTitles:otherButtonTitles
																											args:args];
	va_end(args);
	return alertController;}

- (id)initWithStyle:(UIAlertControllerStyle)style
							title:(NSString *)title
						message:(NSString *)message
							block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
	cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
	otherButtonTitles:(NSString *)otherButtonTitles, ... {
	va_list args;
	va_start(args, otherButtonTitles);

	UIAlertController *alertController = [self initWithTitle:title
																									 message:message
																						preferredStyle:style
																										 block:buttonClickedBlock
																				 cancelButtonTitle:cancelButtonTitle
																		destructiveButtonTitle:destructiveButtonTitle
																				 otherButtonTitles:otherButtonTitles
																											args:args];
	va_end(args);
	return alertController;
}

- (id)initWithTitle:(NSString *)title
						message:(NSString *)message
		 preferredStyle:(UIAlertControllerStyle)preferredStyle
							block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
	cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
	otherButtonTitles:(NSString *)otherButtonTitles
							 args:(va_list)arguments {
	NSMutableArray * arrayOfButtonTitles = [NSMutableArray array];
	for (NSString * currentArgument = otherButtonTitles; currentArgument != nil; currentArgument = va_arg(arguments, NSString *)) {
		[arrayOfButtonTitles addObject:currentArgument];
	}
	return [self initWithTitle:title
										 message:message
							preferredStyle:preferredStyle
											 block:buttonClickedBlock
					 cancelButtonTitle:cancelButtonTitle
			destructiveButtonTitle:destructiveButtonTitle
					 otherButtonTitles:arrayOfButtonTitles];
}

- (id)initWithTitle:(NSString *)title
						message:(NSString *)message
		 preferredStyle:(UIAlertControllerStyle)preferredStyle
							block:(UIAlertControllerButtonClickedBlock)buttonClickedBlock
	cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
	otherButtonTitles:(NSArray *)otherButtonTitles {
	self = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
	if(self != nil) {
		NSInteger buttonIndex = 0;
		__block NSInteger cancelButtonIndex = 0;

		if (destructiveButtonTitle != nil) {
			UIAlertAction *action = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
				if (buttonClickedBlock) {
					buttonClickedBlock(self, GET_BUTTON_INDEXES(cancelButtonIndex, 0, buttonIndex));
				}
			}];
			[self addAction:action];

			++buttonIndex;
		}

		for (NSString * currentArgument in otherButtonTitles) {
			UIAlertAction *action = [UIAlertAction actionWithTitle:currentArgument style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				if (buttonClickedBlock) {
					buttonClickedBlock(self, GET_BUTTON_INDEXES(cancelButtonIndex, 0, buttonIndex));
				}
			}];
			[self addAction:action];

			++buttonIndex;
		}

		if (cancelButtonTitle != nil) {
			cancelButtonIndex = buttonIndex;
			UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				if (buttonClickedBlock) {
					buttonClickedBlock(self, GET_BUTTON_INDEXES(cancelButtonIndex, 0, buttonIndex));
				}
			}];
			[self addAction:action];
		}
	}
	return self;
}

@end
