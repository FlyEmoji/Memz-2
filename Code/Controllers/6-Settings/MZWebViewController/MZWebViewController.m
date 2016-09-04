//
//  MZWebViewController.m
//  Memz
//
//  Created by Bastien Falcou on 5/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZWebViewController.h"
#import "MZLoaderView.h"
#import "UIViewController+MemzAdditions.h"

@interface MZWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation MZWebViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self updateContent];
}

- (void)updateContent {
	NSString *htmlFile;

	switch (self.webViewType) {
		case MZWebViewTypeTermsAndConditions:
			htmlFile = [[NSBundle mainBundle] pathForResource:@"Settings-Terms-And-Conditions" ofType:@"htm"];
			break;
		case MZWebViewTypePrivacyPolicy:
			htmlFile = [[NSBundle mainBundle] pathForResource:@"Settings-Privacy-Policy" ofType:@"htm"];
			break;
		default:
			break;
	}
	NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Custom Setter

- (void)setWebViewType:(MZWebViewType)webViewType {
	_webViewType = webViewType;

	[self updateContent];
}

#pragma mark - Web View Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[MZLoaderView showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[MZLoaderView hideAllLoadersFromView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[MZLoaderView hideAllLoadersFromView:self.view];
	[self presentError:error];
}

@end
