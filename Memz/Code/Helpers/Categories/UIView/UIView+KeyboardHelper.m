//
//  UIView+EthanolKeyboardHelper.m
//  Memz
//
//  Created by Bastien Falcou on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+KeyboardHelper.h"
#import "NSObject+ExecuteOnDealloc.h"

static char isKeyboardShownKey;

@interface UIView (KeyboardHelperProperties)

@end

@implementation UIView (KeyboardHelper)

+ (void)setKeyboardShown:(BOOL)keyboardShown {
	objc_setAssociatedObject(self, &isKeyboardShownKey, @(keyboardShown), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (BOOL)isKeyboardShown {
	return [objc_getAssociatedObject(self, &isKeyboardShownKey) boolValue];
}

- (void)handleKeyboardNotificationsWithBlock:(MZKeyboardNotificationBlock)handlerBlock {
	self.keyboardNotificationBlock = handlerBlock;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

	[self performBlockOnDealloc:^(id object) {
		[[NSNotificationCenter defaultCenter] removeObserver:object name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:object name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:object name:UIKeyboardDidHideNotification object:nil];
	}];
}

- (void)handleKeyboardWillShow:(NSNotification *)sender {
	CGRect endKeyboardRect = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self class].keyboardShown = YES;
	self.keyboardSize = endKeyboardRect.size;
	self.keyboardNotificationBlock(YES,
																	[[sender userInfo][UIKeyboardFrameBeginUserInfoKey] CGRectValue],
																 endKeyboardRect,
																 [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue],
																 [[self class] memzAnimationOptionsWithCurve:
																	[[sender userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue]]);
}

- (void)handleKeyboardWillHide:(NSNotification *)sender {
	self.keyboardNotificationBlock(NO,
																 [[sender userInfo][UIKeyboardFrameBeginUserInfoKey] CGRectValue],
																 [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue],
																 [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue],
																 [[self class] memzAnimationOptionsWithCurve:
																	[[sender userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue]]);
}

- (void)handleKeyboardDidHide:(NSNotification *)sender {
	self.keyboardSize = CGSizeZero;
	[self class].keyboardShown = NO;
}

//ETH_SYNTHESIZE_CATEGORY_PROPERTY_PRIMITIVEONLY(ETHKeyboardNotificationBlock, E, e, th_keyboardNotificationBlock, strong)
//ETH_SYNTHESIZE_CATEGORY_PROPERTY_PRIMITIVEONLY(CGSize, E, e, th_keyboardSize, assign)

- (MZKeyboardNotificationBlock)keyboardNotificationBlock {
	return [self keyboardNotificationBlockPrimitive];
}

- (void)setKeyboardNotificationBlock:(MZKeyboardNotificationBlock)keyboardNotificationBlock {
	[self setKeyboardNotificationBlockPrimitive:keyboardNotificationBlock];
}

- (CGSize)keyboardSize {
	return [self keyboardSizePrimitive];
}

- (void)setKeyboardSize:(CGSize)eth_keyboardSize {
	[self setEth_keyboardSizePrimitive:eth_keyboardSize];
}

+ (UIViewAnimationOptions)memzAnimationOptionsWithCurve:(UIViewAnimationCurve)curve {
	NSAssert((UIViewAnimationCurveEaseInOut << 16) == UIViewAnimationOptionCurveEaseInOut, @"This method relies on internal consistency - please rewrite this method accordingly");
	UIViewAnimationOptions options = (UIViewAnimationOptions)curve;
	return options << 16;
}

@end
