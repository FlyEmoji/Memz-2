//
//  UINavigationItem+MemzAdditions.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationItem+MemzAdditions.h"
#import "UIImage+MemzAdditions.h"

#define kBackButtonLeftOffset -8.0f

// Prevent the back button text to be too close to the title
#define kBackButtonTextOffset 5.0f

// Any images with a height greater than this will be resized
#define kMaxImageHeight 36.0f

static const char kBackButtonKey;
static const char kBackButtonCustomActionBlockKey;
static const char kActionInProgressKey;

@implementation UINavigationItem (MemzAdditions)

- (NSString *)nextBackButtonTitle {
	return self.backBarButtonItem.title;
}

- (void)setNextBackButtonTitle:(NSString *)backButtonTitle {
	self.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (MZCustomBackButtonActionBlock)customBackButtonActionBlock {
	return objc_getAssociatedObject(self, &kBackButtonCustomActionBlockKey);
}

- (UIButton *)customBackButton {
	return objc_getAssociatedObject(self, &kBackButtonKey);
}

- (UIButton *)setCustomBackButtonTitle:(NSString *)title {
	UIButton *backButton = [self customBackButton];
	if (backButton == nil) {
		[self setCustomBackButtonActionBlock:nil
																			 title:title];
	} else {
		[backButton setTitle:title forState:UIControlStateNormal];
	}
	return backButton;
}

- (UIButton *)setCustomBackButtonActionBlock:(MZCustomBackButtonActionBlock)actionBlock {
	if ([self customBackButtonActionBlock] != nil) {
		objc_setAssociatedObject(self, &kBackButtonCustomActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
		return [self customBackButton];
	} else {
		return [self setCustomBackButtonActionBlock:actionBlock title:nil];
	}
}

- (UIButton *)setCustomBackButtonActionBlock:(MZCustomBackButtonActionBlock)actionBlock title:(NSString *)title {
	if ([self customBackButtonActionBlock] != nil) {
		objc_setAssociatedObject(self, &kBackButtonCustomActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
		return [self setCustomBackButtonTitle:title];
	} else {
		UIButton *button = [self setCustomBackButtonWithImage:[UIImage imageWithAssetIdentifier:MZAssetIdentifierNavigationBack]
																										title:title
																							actionBlock:actionBlock];
		return button;
	}
}

- (UIButton *)setCustomBackButtonWithImage:(UIImage *)image actionBlock:(MZCustomBackButtonActionBlock)actionBlock {
	return [self setCustomBackButtonWithImage:image title:nil actionBlock:actionBlock];
}

- (UIButton *)setCustomBackButtonWithImage:(UIImage *)image title:(NSString *)title actionBlock:(MZCustomBackButtonActionBlock)actionBlock {
	return [self setCustomBackButtonWithType:UIButtonTypeSystem image:image title:title actionBlock:actionBlock];
}

- (UIButton *)setCustomBackButtonWithType:(UIButtonType)buttonType image:(UIImage *)image title:(NSString *)title actionBlock:(MZCustomBackButtonActionBlock)actionBlock {
	UIButton * button = [UIButton buttonWithType:buttonType];
	button.exclusiveTouch = YES;
	[button addTarget:self action:@selector(customAction_backButtonCustomActionTapped:) forControlEvents:UIControlEventTouchUpInside];

	if (image != nil) {
		if (image.size.height > kMaxImageHeight) {
			CGFloat imageHeight = fmin(kMaxImageHeight, image.size.height);
			CGFloat imageRatio = image.size.width / image.size.height;
			CGFloat imageWidth = imageHeight * imageRatio;

			image = [image resizedImage:CGSizeMake(imageWidth, imageHeight) interpolationQuality:kCGInterpolationDefault];
		}

		[button setImage:image forState:UIControlStateNormal];

		button.imageEdgeInsets = UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f);
	}

	// Give it a slightly larger frame so that user can tap it easily, in case the image's width is not enough
	CGFloat titleWidth = 0.0f;
	if (self.title != nil) {
		NSDictionary * attributes = [[UINavigationBar appearance] titleTextAttributes];
		if (attributes == nil) {
			attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]};
		}
		CGSize textSize = [self.title sizeWithAttributes:attributes];
		titleWidth = textSize.width;
	}

	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

	button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	if (title != nil) {
		button.titleLabel.font = [button.titleLabel.font fontWithSize:17.0f];
		button.titleEdgeInsets = UIEdgeInsetsMake(2.0f, image ? 6.5f : 0.0f, 0.0f, 0.0f);

		CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];

		if (textSize.width + titleWidth > screenWidth) {
			title = [NSLocalizedString(@"CommonBack", nil) uppercaseString];
			textSize = [title sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
		}

		if (textSize.width + titleWidth <= screenWidth) {
			button.frame = CGRectIntegral(CGRectMake(button.frame.origin.x,
																							 button.frame.origin.y,
																							 fmax(image.size.width + button.titleEdgeInsets.left + textSize.width + kBackButtonTextOffset - kBackButtonLeftOffset, button.frame.size.width),
																							 fmax(textSize.height, button.frame.size.height)));

			[button setTitle:title forState:UIControlStateNormal];
		}
	}

	UIBarButtonItem * leftOffsetSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
	leftOffsetSpacer.width = kBackButtonLeftOffset;

	UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.leftBarButtonItems = @[leftOffsetSpacer, barButtonItem];

	UIPanGestureRecognizer * popGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(customAction_customTransitionPopGestureRecognizerMethod:)];
	popGestureRecognizer.maximumNumberOfTouches = 1;
	popGestureRecognizer.minimumNumberOfTouches = 1;
	[button addGestureRecognizer:popGestureRecognizer];

	objc_setAssociatedObject(self, &kBackButtonKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, &kBackButtonCustomActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

	return button;
}

- (void)removeCustomBackButton {
	self.leftBarButtonItem = nil;

	objc_setAssociatedObject(self, &kBackButtonKey, nil, OBJC_ASSOCIATION_ASSIGN);
	objc_setAssociatedObject(self, &kActionInProgressKey, nil, OBJC_ASSOCIATION_ASSIGN);
	objc_setAssociatedObject(self, &kBackButtonCustomActionBlockKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)customAction_backButtonCustomActionTapped:(id)sender {
	MZCustomBackButtonActionBlock actionBlock = objc_getAssociatedObject(self, &kBackButtonCustomActionBlockKey);
	NSNumber * inProgress = objc_getAssociatedObject(self, &kActionInProgressKey);
	if (![inProgress boolValue] && actionBlock != nil) {
		objc_setAssociatedObject(self, &kActionInProgressKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

		MZCustomBackButtonActionCompletedBlock completedBlock = ^(BOOL completed) {
			objc_setAssociatedObject(self, &kActionInProgressKey, nil, OBJC_ASSOCIATION_ASSIGN);

			if (completed) {
				objc_setAssociatedObject(self, &kBackButtonKey, nil, OBJC_ASSOCIATION_ASSIGN);
				objc_setAssociatedObject(self, &kBackButtonCustomActionBlockKey, nil, OBJC_ASSOCIATION_ASSIGN);
			}
		};

		actionBlock(sender, completedBlock);
	}
}

- (void)customAction_customTransitionPopGestureRecognizerMethod:(id)sender {
	UIPanGestureRecognizer * panGestureRecognizer = (UIPanGestureRecognizer *)sender;
	CGPoint translatedPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view.window];
	if (translatedPoint.x > 0.0f) {
		[self customAction_backButtonCustomActionTapped:self];

		[panGestureRecognizer.view removeGestureRecognizer:panGestureRecognizer];
	}
}

@end
