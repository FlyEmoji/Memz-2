//
//  MZRemoteServerCoordinatorTests.m
//  Memz
//
//  Created by Bastien Falcou on 9/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZRemoteServerCoordinator.h"

@interface MZRemoteServerCoordinatorTests : XCTestCase

@end

@implementation MZRemoteServerCoordinatorTests

#pragma mark - Fetch Articles 

- (void)testPerformanceFetchFeedWithCompletionHandler {
	[self measureBlock:^{
		[MZRemoteServerCoordinator fetchFeedWithCompletionHandler:nil];
	}];
}

- (void)testFetchFeedWithCompletionHandler {
	XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Fetch Feed Asynchronous"];
	
	[MZRemoteServerCoordinator fetchFeedWithCompletionHandler:^(NSArray<MZArticle *> *articles, NSError *error) {
		XCTAssertTrue(articles.count > 0 || error != nil);
		[completionExpectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end