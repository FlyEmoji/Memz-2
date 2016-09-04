//
//  MZShareManager.h
//  Memz
//
//  Created by Bastien Falcou on 3/8/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MessageUI;

typedef NS_ENUM(NSUInteger, MZShareOption) {
	MZShareOptionShareSheet,
	MZShareOptionTwitter,
	MZShareOptionFacebook,
	MZShareOptionSinaWeibo,
	MZShareOptionTencentWeibo,
	MZShareOptionSMS,
	MZShareOptionEmail
};

@interface MZShareManager : NSObject

+ (UIViewController *)shareForType:(MZShareOption)shareOption
														 title:(NSString *)title
														images:(NSArray<UIImage *> *)images
															urls:(NSArray<NSURL *> *)urls
								 completionHandler:(void(^)(void))completionHandler;

+ (UIViewController *)sendSMSWithBody:(NSString *)body
													 recipients:(NSArray<NSString *> *)recipients
							 messageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)delegate
										completionHandler:(void(^)(void))completionHandler;

+ (UIViewController *)sendEmailWithSubject:(NSString *)subject
																			body:(NSString *)body
																		isHTML:(BOOL)isHTML
																recipients:(NSArray<NSString *> *)recipients
											 mailComposeDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
												 completionHandler:(void(^)(void))completionHandler;

@end
