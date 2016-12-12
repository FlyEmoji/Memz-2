//
//  MZResponseComparatorTest.m
//  Memz
//
//  Created by Bastien Falcou on 6/20/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZResponseComparator.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZResponse.h"
#import "MZWord.h"

@interface MZResponseComparatorDelegateObjectTest: NSObject <MZResponseComparatorDelegate>

@property (nonatomic, strong, readonly) NSMutableDictionary *wordsDictionary;

@end

@implementation MZResponseComparatorDelegateObjectTest

- (void)responseComparator:(MZResponseComparator *)response
			 didCheckTranslation:(NSString *)translation
					 correctWithWord:(MZWord *)correction
			isTranslationCorrect:(BOOL)isCorrect {
	_wordsDictionary = [[NSMutableDictionary alloc] init];
	_wordsDictionary[translation] = @(isCorrect);
}

@end

@interface MZResponseComparatorTest: XCTestCase

@end

@implementation MZResponseComparatorTest

#pragma mark - One Word

- (void)testOneTranslationRightAnswer {
	MZWord *word = [MZWord addWord:@"test"
											inLanguage:MZLanguageEnglish
										translations:@[@"test"]
											toLanguage:MZLanguageFrench
												 forUser:nil
											 inContext:nil];

	MZResponse *response = [MZResponse newInstance];
	response.word = word;

	MZResponseComparator *responseComparator = [[MZResponseComparator alloc] initWithResponse:response];

	MZResponseComparatorDelegateObjectTest *delegateObject = [[MZResponseComparatorDelegateObjectTest alloc] init];
	responseComparator.delegate = delegateObject;

	[responseComparator checkTranslations:@[@"test"] inLanguage:MZLanguageFrench];

	XCTAssertEqual([delegateObject.wordsDictionary[@"test"] boolValue], YES);
}

- (void)testOneTranslationCloseAnswer {
	MZWord *word = [MZWord addWord:@"involved"
											inLanguage:MZLanguageEnglish
										translations:@[@"impliqué"]
											toLanguage:MZLanguageFrench
												 forUser:nil
											 inContext:nil];

	MZResponse *response = [MZResponse newInstance];
	response.word = word;

	MZResponseComparator *responseComparator = [[MZResponseComparator alloc] initWithResponse:response];

	MZResponseComparatorDelegateObjectTest *delegateObject = [[MZResponseComparatorDelegateObjectTest alloc] init];
	responseComparator.delegate = delegateObject;

	[responseComparator checkTranslations:@[@"implique"] inLanguage:MZLanguageFrench];

	XCTAssertEqual([delegateObject.wordsDictionary[@"implique"] boolValue], YES);
}

- (void)testOneTranslationWrongAnswer {
	MZWord *word = [MZWord addWord:@"involved"
											inLanguage:MZLanguageEnglish
										translations:@[@"impliqué"]
											toLanguage:MZLanguageFrench
												 forUser:nil
											 inContext:nil];

	MZResponse *response = [MZResponse newInstance];
	response.word = word;

	MZResponseComparator *responseComparator = [[MZResponseComparator alloc] initWithResponse:response];

	MZResponseComparatorDelegateObjectTest *delegateObject = [[MZResponseComparatorDelegateObjectTest alloc] init];
	responseComparator.delegate = delegateObject;

	[responseComparator checkTranslations:@[@"wrong answer"] inLanguage:MZLanguageFrench];

	XCTAssertEqual([delegateObject.wordsDictionary[@"wrong answer"] boolValue], YES);
}

#pragma mark - Several Words

// TODO: To write

@end