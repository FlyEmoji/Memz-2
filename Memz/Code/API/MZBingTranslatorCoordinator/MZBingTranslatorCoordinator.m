//
//  MZBingTranslatorCoordinator.m
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZBingTranslatorCoordinator.h"
#import "NSString+MemzAdditions.h"

NSString * const kBaseURL = @"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13";
NSString * const kClientID = @"d10975df-3695-4602-b2f7-1702ddd7323b";
NSString * const kClientSecretID = @"Xsb880QNq6Hfhf5kB+ujHPZlYSF4E3VILLATN0VS5NA=";

NSString * const kAccessTokenKey = @"MZBingAccessTokenKey";

const NSTimeInterval kTimeoutTimeInterval = 60.0;

@interface MZBingTranslatorCoordinator ()

@property (nonatomic, weak, readonly) NSString *accessToken;

@end

@implementation MZBingTranslatorCoordinator

+ (MZBingTranslatorCoordinator *)sharedManager {
	static MZBingTranslatorCoordinator *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

#pragma mark - Access Token

- (NSString *)accessToken {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenKey];
}

- (void)setAccessToken:(NSString * _Nullable)accessToken {
	[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearAccessToken {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getAccessTokenWithCompletionHandler:(nonnull void (^)(NSError *error))completionHandler {
	if (self.accessToken.length > 0) {
		completionHandler(nil);
		return;
	}

	NSMutableString *queryString = [NSMutableString string];
	[queryString appendFormat:@"client_id=%@", kClientID];
	[queryString appendFormat:@"&client_secret=%@", [NSString urlEncodedStringFromString:kClientSecretID]];
	[queryString appendString:@"&scope=http://api.microsofttranslator.com"];
	[queryString appendString:@"&grant_type=client_credentials"];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kBaseURL]];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];

	NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
																																	 completionHandler:
																		^(NSData *data, NSURLResponse *response, NSError *error) {
																			if (error) {
																				completionHandler(error);
																			} else {
																				NSError *jsonError;
																				NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

																				if (!jsonError) {
																					self.accessToken = jsonResponse[@"access_token"];
																				}
																				completionHandler(jsonError);
																			}
																		}];
	[dataTask resume];
}

#pragma mark - Translation

/*
- (void)translateText:(NSString *)text fromLan:(NSString *)txtLan toLan:(NSString *)localLan{
	if (text.length < 1) return;

	if (![self checkAndGetAccessToken]) {
		return;
	}

	if (receivedData != nil) {
		[receivedData release];
	}

	receivedData = [[NSMutableData alloc] init];

	NSString *encodedString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *string_prefix = bingAPI_translate @"&text=";

	NSString *string_suffix = @"";

	if (txtLan.length > 1)
		string_suffix = [NSString stringWithFormat:@"&from=%@&to=%@",txtLan, localLan];
	else
		string_suffix = [NSString stringWithFormat:@"&to=%@", localLan];

	NSString *finalString = [NSString stringWithFormat:@"%@%@%@", string_prefix, encodedString, string_suffix];
	NSURL *queryURL = [NSURL URLWithString:finalString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:queryURL];
	[request addValue:[NSString stringWithFormat:@"Bearer %@", [self getValueAccessToken]] forHTTPHeaderField:@"Authorization"];
	if (translate_connection != nil) {
		[translate_connection release];
	}
	translate_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}*/

@end
