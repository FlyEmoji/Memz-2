//
//  MZBingTranslatorCoordinator.m
//  Memz
//
//  Created by Bastien Falcou on 12/20/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZBingTranslatorCoordinator.h"
#import "MZBingTranslatorToken.h"
#import "NSString+MemzAdditions.h"

NSString * const kBaseURL = @"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13";
NSString * const kTranslateURL = @"http://api.microsofttranslator.com/V2/Http.svc/Translate";

NSString * const kClientID = @"d10975df-3695-4602-b2f7-1702ddd7323b";
NSString * const kClientSecretID = @"Xsb880QNq6Hfhf5kB+ujHPZlYSF4E3VILLATN0VS5NA=";

NSString * const kAccessTokenKey = @"MZBingAccessTokenKey";
NSString * const kAccessTokenExpiryKey = @"MZBingAccessTokenExpiryKey";

const NSTimeInterval kTimeoutTimeInterval = 60.0;
const NSInteger kMaximumNumberConcurrentTasks = 5;

@interface MZBingTranslatorCoordinator () <NSXMLParserDelegate>

@property (nonatomic, strong, readonly) MZBingTranslatorToken *token;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSMutableSet<MZBingTranslationWrapper *> *currentTranslations;

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

- (instancetype)init {
	if (self = [super init]) {
		_session = [self setupTranslatiorCoordinatorSession];
		_currentTranslations = [[NSMutableSet alloc] init];
	}
	return self;
}

#pragma mark - Public Methods

- (void)translateString:(NSString *)stringToTranslate
					 fromLanguage:(MZLanguage)fromLanguage
						 toLanguage:(MZLanguage)toLanguage
			completionHandler:(MZBingTranslationCompletionHandler)completionHandler {
	if (self.token.isValid) {
		[self doTranslateString:stringToTranslate fromLanguage:fromLanguage toLanguage:toLanguage completionHandler:completionHandler];
	} else {
		[self clearToken];
		[self getAccessTokenWithCompletionHandler:^(NSError *error) {
			if (!error) {
				[self doTranslateString:stringToTranslate fromLanguage:fromLanguage toLanguage:toLanguage completionHandler:completionHandler];
			} else {
				completionHandler(nil, error);
			}
		}];
	}
}

#pragma mark - Private Access Token Management

- (MZBingTranslatorToken *)token {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenKey];
	NSDate *expiry = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenExpiryKey];
	return [[MZBingTranslatorToken alloc] initWithToken:accessToken expiry:expiry];
}

- (void)setToken:(MZBingTranslatorToken * _Nullable)token {
	[[NSUserDefaults standardUserDefaults] setObject:token.token forKey:kAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] setObject:token.expiry forKey:kAccessTokenExpiryKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearToken {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenExpiryKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getAccessTokenWithCompletionHandler:(nonnull void (^)(NSError *error))completionHandler {
	NSMutableString *queryString = [NSMutableString string];
	[queryString appendFormat:@"client_id=%@", kClientID];
	[queryString appendFormat:@"&client_secret=%@", [NSString urlEncodedStringFromString:kClientSecretID]];
	[queryString appendString:@"&scope=http://api.microsofttranslator.com"];
	[queryString appendString:@"&grant_type=client_credentials"];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kBaseURL]];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];

	NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
																									 completionHandler:
																		^(NSData *data, NSURLResponse *response, NSError *error) {
																			if (error) {
																				completionHandler(error);
																			} else {
																				NSError *jsonError;
																				NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

																				if (!jsonError) {
																					NSString *accessToken = jsonResponse[@"access_token"];
																					NSTimeInterval expiry =  [jsonResponse[@"expires_in"] doubleValue];
																					NSDate *expiration = [NSDate dateWithTimeIntervalSinceNow:expiry];

																					self.token = [[MZBingTranslatorToken alloc] initWithToken:accessToken expiry:expiration];
																				}
																				completionHandler(jsonError);
																			}
																		}];
	[dataTask resume];
}

#pragma mark - Private Translation

- (void)doTranslateString:(NSString *)stringToTranslate
						 fromLanguage:(MZLanguage)fromLanguage
							 toLanguage:(MZLanguage)toLanguage
				completionHandler:(nonnull MZBingTranslationCompletionHandler)completionHandler {
	NSMutableString *queryString = [NSMutableString string];
	[queryString appendFormat:@"?to=%@", [self APILanguageCodeForLanguage:toLanguage]];
	[queryString appendFormat:@"&from=%@", [self APILanguageCodeForLanguage:fromLanguage]];
	[queryString appendFormat:@"&text=%@", [NSString urlEncodedStringFromString:stringToTranslate]];
	[queryString appendString:@"&contentType=text/plain"];

	NSURL *requestURL = [NSURL URLWithString:queryString relativeToURL:[NSURL URLWithString:kTranslateURL]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
	[request addValue:[NSString stringWithFormat:@"Bearer %@", self.token.token] forHTTPHeaderField:@"Authorization"];

	MZBingTranslationWrapper *translationWrapper = [[MZBingTranslationWrapper alloc] init];
	translationWrapper.translationCompletionHandler = completionHandler;
	translationWrapper.dataTask = [self.session dataTaskWithRequest:request
																								completionHandler:
																 ^(NSData *data, NSURLResponse *response, NSError *error) {
																	 if (error) {
																		 completionHandler(nil, error);
																		 translationWrapper.dataTask = nil;
																		 [self.currentTranslations removeObject:translationWrapper];
																	 } else {
																		 translationWrapper.parser = [[NSXMLParser alloc] initWithData:data];
																		 translationWrapper.parser.delegate = self;

																		 if (![translationWrapper.parser parse]) {
																			 completionHandler(nil, [MZErrorCreator errorWithType:MZErrorTypeAPIParseResponse]);
																			 translationWrapper.dataTask = nil;
																			 [self.currentTranslations removeObject:translationWrapper];
																		 }
																	 }
																 }];

	[translationWrapper.dataTask resume];
	[self.currentTranslations addObject:translationWrapper];
}

#pragma mark - XMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	MZBingTranslationWrapper *translationWrapper = [self translationWrapperForParser:parser];

	translationWrapper.XMLElement = elementName;

	if ([translationWrapper.XMLElement isEqualToString:@"string"]) {
		translationWrapper.XMLTranslation = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	MZBingTranslationWrapper *translationWrapper = [self translationWrapperForParser:parser];

	if ([translationWrapper.XMLElement isEqualToString:@"string"]) {
		[translationWrapper.XMLTranslation appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	MZBingTranslationWrapper *translationWrapper = [self translationWrapperForParser:parser];

	if ([translationWrapper.XMLElement isEqualToString:@"string"] && translationWrapper.XMLTranslation) {
		NSLog(@"Suggested word: %@", translationWrapper.XMLTranslation);
		translationWrapper.translationCompletionHandler(@[translationWrapper.XMLTranslation], nil);
		[self.currentTranslations removeObject:translationWrapper];
	}
}

#pragma mark - Helpers

- (NSURLSession *)setupTranslatiorCoordinatorSession {
	NSURLSessionConfiguration *configuration = [[NSURLSession sharedSession].configuration copy];
	configuration.HTTPMaximumConnectionsPerHost = kMaximumNumberConcurrentTasks;
	configuration.timeoutIntervalForRequest = kTimeoutTimeInterval;
	return [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
}

- (MZBingTranslationWrapper *)translationWrapperForParser:(NSXMLParser *)parser {
	for (MZBingTranslationWrapper *translationWrapper in [self.currentTranslations allObjects]) {
		if (translationWrapper.parser == parser) {
			return translationWrapper;
		}
	}
	return nil;
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
