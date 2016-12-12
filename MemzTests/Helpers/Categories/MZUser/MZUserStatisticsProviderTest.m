//
//  MZUserStatisticsProviderTest.m
//  Memz
//
//  Created by Bastien Falcou on 12/9/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZUser+StatisticsProvider.h"
#import "NSManagedObject+MemzCoreData.h"

@interface MZUserStatisticsProviderTest : XCTestCase

@property (nonatomic, strong) MZUser *user;

@end

@implementation MZUserStatisticsProviderTest

- (void)setUp {
	[super setUp];
	
	self.user = [MZUser newInstance];
	self.user.knownLanguage = @(MZLanguageEnglish);
	self.user.newLanguage = @(MZLanguageFrench);
	
	MZWord *word1 = [MZWord addWord:@"bread" inLanguage:MZLanguageEnglish translations:@[@"pain"] toLanguage:MZLanguageFrench forUser:self.user inContext:nil];
	MZWord *word2 = [MZWord addWord:@"bottle" inLanguage:MZLanguageEnglish translations:@[@"bouteille", @"courage"] toLanguage:MZLanguageFrench forUser:self.user inContext:nil];
	
	MZQuiz *quiz = [MZQuiz newInstance];
	quiz.user = self.user;
	quiz.answerDate = [NSDate date];
	quiz.creationDate = [NSDate date];
	quiz.isAnswered = @(YES);
	quiz.knownLanguage = self.user.knownLanguage;
	quiz.newLanguage = self.user.newLanguage;
	
	MZResponse *response1 = [MZResponse newInstance];
	response1.word = word1;
	response1.result = @(8);
	response1.quiz = quiz;

	MZResponse *response2 = [MZResponse newInstance];
	response2.word = word2;
	response2.result = @(2);
	response2.quiz = quiz;
}

#pragma mark - Granular Accessors

- (void)testMonth {
	XCTAssertTrue(true);
}

@end
