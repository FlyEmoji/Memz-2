//
//  MZShareManager.m
//  Memz
//
//  Created by Bastien Falcou on 3/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZShareManager.h"
#import "UIViewController+MemzAdditions.h"

@import Social;

@implementation MZShareManager

#pragma mark - Public

+ (UIViewController *)shareForType:(MZShareOption)shareOption
														 title:(NSString *)title
														images:(NSArray<UIImage *> *)images
															urls:(NSArray<NSURL *> *)urls
								 completionHandler:(void(^)(void))completionHandler {
	// (1) Presents generic share sheet if needed
	if (shareOption == MZShareOptionShareSheet) {
		NSMutableArray *activityItems = [[NSMutableArray alloc] init];

		for (UIImage *image in images) {
			[activityItems addObject:image];
		}
		for (NSURL *url in urls) {
			[activityItems addObject:url];
		}

		UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
																		applicationActivities:nil];

		[[UIViewController topMostViewController] presentViewController:activityViewController
																													 animated:YES
																												 completion:completionHandler];
		return activityViewController;
	}

	// (2) If direct share chosen
	NSString *serviceType = [MZShareManager serviceTypeForShareOption:shareOption];
	SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
	[composeViewController setInitialText:title];

	for (UIImage *image in images) {
		[composeViewController addImage:image];
	}
	for (NSURL *url in urls) {
		[composeViewController addURL:url];
	}

	[[UIViewController topMostViewController] presentViewController:composeViewController
																												 animated:YES
																											 completion:completionHandler];
	return composeViewController;
}

+ (UIViewController *)sendSMSWithBody:(NSString *)body
													 recipients:(NSArray<NSString *> *)recipients
							 messageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)delegate
										completionHandler:(void(^)(void))completionHandler {
	MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];

	messageComposeViewController.messageComposeDelegate = delegate;
	messageComposeViewController.recipients = recipients;
	messageComposeViewController.body = body;

	[[UIViewController topMostViewController] presentViewController:messageComposeViewController
																												 animated:YES
																											 completion:completionHandler];
	return messageComposeViewController;
}

+ (UIViewController *)sendEmailWithSubject:(NSString *)subject
																			body:(NSString *)body
																		isHTML:(BOOL)isHTML
																recipients:(NSArray<NSString *> *)recipients
											 mailComposeDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
												 completionHandler:(void(^)(void))completionHandler {
	MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];

	mailComposeViewController.mailComposeDelegate = delegate;
	[mailComposeViewController setToRecipients:recipients];
	[mailComposeViewController setSubject:subject];
	[mailComposeViewController setMessageBody:body
																		 isHTML:isHTML];
	
	[[UIViewController topMostViewController] presentViewController:mailComposeViewController
																												 animated:YES
																											 completion:completionHandler];
	return mailComposeViewController;
}

#pragma mark - Private

+ (NSString *)serviceTypeForShareOption:(MZShareOption)shareOption {
	switch (shareOption) {
		case MZShareOptionTwitter:
		return SLServiceTypeTwitter;
		case MZShareOptionFacebook:
		return SLServiceTypeFacebook;
		case MZShareOptionSinaWeibo:
		return SLServiceTypeSinaWeibo;
		case MZShareOptionTencentWeibo:
		return SLServiceTypeTencentWeibo;
		default:
		return nil;
	}
}

@end
