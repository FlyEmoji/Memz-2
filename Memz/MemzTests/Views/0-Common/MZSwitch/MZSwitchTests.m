//
//  MZSwitchTest.m
//  Memz
//
//  Created by Bastien Falcou on 5/21/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZSwitch.h"
#import "MZTestControlsViewController.h"

@interface MZSwitch (PrivateTests)

@property (nonatomic, retain, readwrite) UIImageView* backgroundImage;

- (void)switchValueChanged:(id)sender;

@end

@interface MZSwitchTests : XCTestCase

@property (nonatomic, strong) UIImage *image;

@end

@implementation MZSwitchTests

- (void)setUp {
  [super setUp];
  
  self.image = [UIImage imageNamed:@"Common-Test-Switch-Dot" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (void)testLoadSwitchInView {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Views" bundle:[NSBundle bundleForClass:[self class]]];
  MZTestControlsViewController *testViewController = [storyboard instantiateViewControllerWithIdentifier:@"MZTestControlsViewControllerIdentifier"];
  [testViewController loadView];
  
  XCTAssertNotNil(testViewController.testSwitch);
  XCTAssertTrue([testViewController.testSwitch isKindOfClass:[MZSwitch class]]);
}

- (void)testTurnSwitchOnColorOnSwitch {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.onTintColor = [UIColor redColor];
  theSwitch.on = YES;

	// native superclass onTintColor if on, custom switch sets transparent background
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor clearColor]);
}

- (void)testTurnSwitchOffColorOffSwitch {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.offTintColor = [UIColor redColor];
  theSwitch.on = NO;
  
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor redColor]);
}

- (void)testTurnSwitchOnColorOffSwitch {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.onTintColor = [UIColor redColor];
  theSwitch.on = NO;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundColor, [UIColor redColor]);
}

- (void)testTurnSwitchOffColorOnSwitch {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.offTintColor = [UIColor redColor];
  theSwitch.on = YES;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundColor, [UIColor redColor]);
}

- (void)testOnBackgroundPicture {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.onImage = self.image;
  theSwitch.on = YES;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testOffBackgroundPicture {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.offImage = self.image;
  theSwitch.on = NO;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testOnBackgroundPictureOffStatus {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.onImage = self.image;
  theSwitch.on = NO;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testOffBackgroundPictureOnStatus {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.offImage = self.image;
  theSwitch.on = YES;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testResetOnColor {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  UIColor *color = [UIColor redColor];
  theSwitch.onTintColor = color;
  theSwitch.on = YES;
  theSwitch.onTintColor = nil;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundColor, color);
}

- (void)testResetOffColor {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  UIColor *color = [UIColor redColor];
  theSwitch.offTintColor = color;
  theSwitch.on = NO;
  theSwitch.offTintColor = nil;
  
  XCTAssertNotEqualObjects(theSwitch.backgroundColor, color);
}

- (void)testResetOnBackgroundPicture {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.onImage = self.image;
  theSwitch.on = YES;
  theSwitch.onImage = nil;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, nil);
}

- (void)testResetOffBackgroundPicture {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.offImage = self.image;
  theSwitch.on = NO;
  theSwitch.offImage = nil;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, nil);
}

- (void)testSwitchOnImage {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.offImage = self.image;
  theSwitch.onImage = self.image;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testSwitchChangeImage {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onImage = self.image;
  theSwitch.onImage = self.image;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, self.image);
}

- (void)testSwitchRemoveImage {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onImage = self.image;
  theSwitch.onImage = nil;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, nil);
}

- (void)testSwitchRemoveImageWithColors {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onTintColor = [UIColor greenColor];
  theSwitch.offTintColor = [UIColor redColor];
  theSwitch.onImage = self.image;
  theSwitch.onImage = nil;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, nil);
}

- (void)testSwitchSetOffImageWhenOn {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.offImage = self.image;
  
  XCTAssertEqualObjects(theSwitch.backgroundImage.image, nil);
}

- (void)testSwitchOffTintColorOffSwitch {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = NO;
  theSwitch.offTintColor = [UIColor blueColor];
  
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor blueColor]);
}

- (void)testChangeSwitchValue {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = NO;
  theSwitch.offTintColor = [UIColor redColor];
  [theSwitch switchValueChanged:nil];
  
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor redColor]);
}

- (void)testSwitchExtensiveProcess1 {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onTintColor = [UIColor greenColor];
  theSwitch.offTintColor = [UIColor redColor];
  theSwitch.onImage = self.image;
  theSwitch.offImage = self.image;
  theSwitch.on = NO;
  theSwitch.onTintColor = nil;
  theSwitch.offTintColor = nil;
  theSwitch.onImage = nil;
  theSwitch.offImage = nil;
  theSwitch.on = YES;
  theSwitch.onTintColor = [UIColor blueColor];

	// native superclass onTintColor if on, custom switch sets transparent background
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor clearColor]);
}

- (void)testSwitchExtensiveProcess2 {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onTintColor = [UIColor greenColor];
  theSwitch.offImage = self.image;
  theSwitch.offImage = nil;
  theSwitch.on = YES;
  theSwitch.onImage = self.image;
  theSwitch.on = NO;
  theSwitch.onTintColor = nil;
  theSwitch.offTintColor = nil;
  theSwitch.offTintColor = [UIColor redColor];
  theSwitch.onImage = nil;
  theSwitch.offImage = nil;
  theSwitch.on = YES;
  theSwitch.onImage = self.image;
  theSwitch.onTintColor = [UIColor blueColor];
  theSwitch.onImage = nil;
	theSwitch.on = NO;
  
  XCTAssertEqualObjects(theSwitch.backgroundColor, [UIColor redColor]);
}

- (void)testSwitchExtensiveProcess3 {
  MZSwitch *theSwitch = [[MZSwitch alloc] init];
  theSwitch.on = YES;
  theSwitch.onTintColor = [UIColor greenColor];
  theSwitch.onImage = self.image;
  theSwitch.on = NO;
  theSwitch.onTintColor = nil;
  theSwitch.onImage = nil;
  theSwitch.on = YES;

  XCTAssertNotEqualObjects(theSwitch.backgroundColor, nil); // Default ON color
}

@end