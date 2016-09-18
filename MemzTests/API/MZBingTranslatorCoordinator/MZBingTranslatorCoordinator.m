//
//  MZBingTranslatorCoordinator.m
//  Memz
//
//  Created by Bastien Falcou on 9/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZBingTranslatorCoordinator.h"

@interface MZBingTranslatorCoordinatorTests : XCTestCase

@end

@implementation MZBingTranslatorCoordinatorTests

#pragma mark - Fetch Translations

- (void)testTranslateStringFrench {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Translate Word Asynchronous French"];
	
	[[MZBingTranslatorCoordinator sharedManager] translateString:@"Yes"
																									fromLanguage:MZLanguageEnglish
																										toLanguage:MZLanguageFrench
																						 completionHandler:
	 ^(NSArray<NSString *> *translations, NSError *error) {
		 XCTAssertTrue(translations.count > 0);
		 [completionExpectation fulfill];
	 }];
	
	[self waitForExpectationsWithTimeout:5.0 handler:nil];
}


- (void)testTranslateStringSpanish {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Translate Word Asynchronous Spanish"];
	
	[[MZBingTranslatorCoordinator sharedManager] translateString:@"Yes"
																									fromLanguage:MZLanguageEnglish
																										toLanguage:MZLanguageSpanish
																						 completionHandler:
	 ^(NSArray<NSString *> *translations, NSError *error) {
		 XCTAssertTrue(translations.count > 0);
		 [completionExpectation fulfill];
	 }];
	
	[self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTranslateStringItalian {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Translate Word Asynchronous Italian"];
	
	[[MZBingTranslatorCoordinator sharedManager] translateString:@"Yes"
																									fromLanguage:MZLanguageEnglish
																										toLanguage:MZLanguageItalian
																						 completionHandler:
	 ^(NSArray<NSString *> *translations, NSError *error) {
		 XCTAssertTrue(translations.count > 0);
		 [completionExpectation fulfill];
	 }];
	
	[self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTranslateStringPortuguese {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Translate Word Asynchronous Portuguese"];
	
	[[MZBingTranslatorCoordinator sharedManager] translateString:@"Yes"
																									fromLanguage:MZLanguageEnglish
																										toLanguage:MZLanguagePortuguese
																						 completionHandler:
	 ^(NSArray<NSString *> *translations, NSError *error) {
		 XCTAssertTrue(translations.count > 0);
		 [completionExpectation fulfill];
	 }];
	
	[self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
