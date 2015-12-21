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
NSString * const kTranslateURL = @"http://api.microsofttranslator.com/V2/Http.svc/Translate";

NSString * const kClientID = @"d10975df-3695-4602-b2f7-1702ddd7323b";
NSString * const kClientSecretID = @"Xsb880QNq6Hfhf5kB+ujHPZlYSF4E3VILLATN0VS5NA=";

NSString * const kAccessTokenKey = @"MZBingAccessTokenKey";

const NSTimeInterval kTimeoutTimeInterval = 60.0;

@interface MZBingTranslatorCoordinator () <NSXMLParserDelegate>

@property (nonatomic, weak, readonly) NSString *accessToken;

@property (nonatomic, copy) MZBingTranslatorCompletionHandler translationCompletionHandler;
@property (nonatomic, strong) NSString *XMLElement;
@property (nonatomic, strong) NSMutableString *XMLTranslation;

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

#pragma mark - Access Token Management

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
	[self clearAccessToken];		// TODO: Should not do that like this


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

- (void)translateString:(NSString *)stringToTranslate
					 fromLanguage:(MZLanguage)fromLanguage
						 toLanguage:(MZLanguage)toLanguage
			completionHandler:(nonnull MZBingTranslatorCompletionHandler)completionHandler {
	[self getAccessTokenWithCompletionHandler:^(NSError *error) {

		NSMutableString *queryString = [NSMutableString string];
		[queryString appendFormat:@"?to=%@", [self APILanguageCodeForLanguage:toLanguage]];
		[queryString appendFormat:@"&from=%@", [self APILanguageCodeForLanguage:fromLanguage]];
		[queryString appendFormat:@"&text=%@", [NSString urlEncodedStringFromString:stringToTranslate]];
		[queryString appendString:@"&contentType=text/plain"];

		NSURL *requestURL = [NSURL URLWithString:queryString relativeToURL:[NSURL URLWithString:kTranslateURL]];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
		[request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];

		self.translationCompletionHandler = completionHandler;

		NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
																																		 completionHandler:
																			^(NSData *data, NSURLResponse *response, NSError *error) {
																				if (error) {
																					completionHandler(nil, error);
																					self.translationCompletionHandler = nil;
																				} else {
																					NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
																					parser.delegate = self;

																					if ([parser parse]) {
																						NSLog(@"Parsing Status is done");
																					} else {
																						completionHandler(nil, [[NSError alloc] init]);		// TODO: Create Error Manager
																						self.translationCompletionHandler = nil;
																					}
																				}
																			}];
		[dataTask resume];
	}];
}

#pragma mark - XMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	self.XMLElement = elementName;
	
	if ([self.XMLElement isEqualToString:@"string"]) {
		self.XMLTranslation = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([self.XMLElement isEqualToString:@"string"]) {
		[self.XMLTranslation appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([self.XMLElement isEqualToString:@"string"] && self.XMLTranslation && self.translationCompletionHandler) {
		NSLog(@">>>>>>  %@", self.XMLTranslation);
		self.translationCompletionHandler(@[self.XMLTranslation], nil);
		self.translationCompletionHandler = nil;
	}
}

#pragma mark - Language Parser

- (NSString *)APILanguageCodeForLanguage:(MZLanguage)language {
	switch (language) {
		case MZLanguageEnglish:
			return @"EN";
		case MZLanguageFrench:
			return @"FR";
	}
}

@end
