//
//  MZWebViewController.h
//  Memz
//
//  Created by Bastien Falcou on 5/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MZWebViewType) {
	MZWebViewTypeTermsAndConditions,
	MZWebViewTypePrivacyPolicy
};

@interface MZWebViewController : UIViewController

@property (nonatomic, assign) MZWebViewType webViewType;

@end
