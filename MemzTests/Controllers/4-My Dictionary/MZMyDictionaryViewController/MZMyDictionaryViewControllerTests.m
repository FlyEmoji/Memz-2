//
//  MZMyDictionaryViewControllerTests.m
//  Memz
//
//  Created by Bastien Falcou on 9/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZMyDictionaryViewController.h"

@interface MZMyDictionaryViewController (PrivateTests)

@property (nonatomic, retain, readwrite) UITableView* tableView;

@end

@interface MZMyDictionaryViewControllerTest : XCTestCase

@property (nonatomic, strong) MZMyDictionaryViewController *viewController;

@end

@implementation MZMyDictionaryViewControllerTest

- (void)setUp {
	[super setUp];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dictionary" bundle:nil];
	self.viewController = [storyboard instantiateInitialViewController];
	[self.viewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
	[super tearDown];
	
	self.viewController = nil;
}

#pragma mark - View loading tests

- (void)testMyDictionaryViewControllerViewLoads {
	XCTAssertNotNil(self.viewController.view, @"View not initiated properly");
}

- (void)testMyDictionaryViewControllerParentViewHasTableViewSubview {
	NSArray *subviews = self.viewController.view.subviews;
	XCTAssertTrue([subviews containsObject:self.viewController.tableView], @"View does not have a table subview");
}

- (void)testMyDictionaryViewControllerTableViewLoads {
	XCTAssertNotNil(self.viewController.tableView, @"TableView not initiated");
}

#pragma mark - UITableView tests

- (void)testMyDictionaryViewControllerConformsToTableViewDataSource {
	XCTAssertTrue([self.viewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testMyDictionaryViewControllerTableViewHasDataSource {
	XCTAssertNotNil(self.viewController.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testMyDictionaryViewControllerConformsToTableViewDelegate {
	XCTAssertTrue([self.viewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testMyDictionaryViewControllerTableViewIsConnectedToDelegate {
	XCTAssertNotNil(self.viewController.tableView.delegate, @"Table delegate cannot be nil");
}

@end