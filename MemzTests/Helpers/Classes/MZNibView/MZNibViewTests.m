//
//  MZNibViewTests.m
//  Memz
//
//  Created by Bastien Falcou on 5/21/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZNibViewTest.h"
#import "MZTestControlsViewController.h"

@interface MZNibViewTests : XCTestCase

@end

@implementation MZNibViewTests

- (void)testNibViewInit {
  MZNibViewTest *nibView = [[MZNibViewTest alloc] init];
  
  XCTAssertNotNil(nibView.contentView);
  XCTAssertNotNil(nibView.textView);
  XCTAssertTrue([nibView.textView isKindOfClass:[UITextView class]]);
}

- (void)testNibViewInitWithFrame {
  MZNibViewTest *nibView = [[MZNibViewTest alloc] initWithFrame:CGRectZero];
  
  XCTAssertNotNil(nibView.contentView);
  XCTAssertNotNil(nibView.textView);
  XCTAssertTrue([nibView.textView isKindOfClass:[UITextView class]]);
}

- (void)testNibViewInitWithCoder {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Views" bundle:[NSBundle bundleForClass:[self class]]];
  MZTestControlsViewController *testViewController = [storyboard instantiateViewControllerWithIdentifier:@"MZTestControlsViewControllerIdentifier"];
  [testViewController loadView];
  
  XCTAssertNotNil(testViewController.testNibView);
  XCTAssertTrue([testViewController.testNibView isKindOfClass:[MZNibView class]]);
  XCTAssertNotNil(testViewController.testNibView.contentView);
  XCTAssertNotNil(testViewController.testNibView.textView);
  XCTAssertTrue([testViewController.testNibView.textView isKindOfClass:[UITextView class]]);
}

@end
