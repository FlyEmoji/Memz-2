//
//  MZPageControlTests.m
//  Memz
//
//  Created by Bastien Falcou on 5/21/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MZPageControl.h"
#import "MZTestControlsViewController.h"

@interface MZPageControl (PrivateTests)

@property (nonatomic, strong) NSMutableArray *dotsArray;

- (CGFloat)xOriginForDotAtIndex:(NSInteger)dotIndex;
- (void)didTapDot:(id)sender;

@end

@interface MZPageControlTests : XCTestCase

@property (nonatomic, strong) UIImage *inactiveLeftImage;
@property (nonatomic, strong) UIImage *inactiveMiddleImage;
@property (nonatomic, strong) UIImage *inactiveRightImage;

@property (nonatomic, strong) UIImage *activeLeftImage;
@property (nonatomic, strong) UIImage *activeMiddleImage;
@property (nonatomic, strong) UIImage *activeRightImage;

@end

@implementation MZPageControlTests

- (void)setUp {
  [super setUp];
  
  self.inactiveLeftImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.inactiveMiddleImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.inactiveRightImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  
  self.activeLeftImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.activeMiddleImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.activeRightImage = [UIImage imageNamed:@"Carousel-Middle-Active" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

#pragma mark - Test Load View

- (void)testLoadPageControlInView {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Views" bundle:[NSBundle bundleForClass:[self class]]];
  MZTestControlsViewController *testViewController = [storyboard instantiateViewControllerWithIdentifier:@"MZTestControlsViewControllerIdentifier"];
  [testViewController loadView];
  
  XCTAssertNotNil(testViewController.testPageControl);
  XCTAssertTrue([testViewController.testPageControl isKindOfClass:[MZPageControl class]]);
}

#pragma mark - Default Dots

- (void)testPageControlNumberOfPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  
  XCTAssertEqual(pageControl.dotsArray.count, 5);
}

- (void)testPageControlChangeNumberOfPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.numberOfPages = 10;
  pageControl.numberOfPages = 3;
  
  XCTAssertEqual(pageControl.dotsArray.count, 3);
}

- (void)testPageControlNegativeNumberOfPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = -1;
  
  XCTAssertEqual(pageControl.dotsArray.count, 0);
}

- (void)testPageControlNumberOfPagesInferiorToCurrentPage {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 4;
  pageControl.numberOfPages = 2;
  
  XCTAssertEqual(pageControl.currentPage, 1);
}

- (void)testPageControlDefaultCurrentPage {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  
  XCTAssertEqual(pageControl.currentPage, 0);
}

- (void)testPageControlChangeCurrentPageColor {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 3;
  
  XCTAssertEqualObjects([(UIView *)pageControl.dotsArray[3] backgroundColor], pageControl.currentPageIndicatorTintColor);
}

- (void)testPageControlNegativeCurrentPage {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = -1;
  
  XCTAssertEqual(pageControl.currentPage, 0);
}

- (void)testPageControlCurrentPageSuperiorToNumberOfPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 10;
  
  XCTAssertEqual(pageControl.currentPage, pageControl.numberOfPages - 1);
}

- (void)testPageControlChangeOtherPagesColor {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  for (UIView *dot in pageControl.dotsArray) {
    if (dot != pageControl.dotsArray[0]) {
      XCTAssertEqualObjects(dot.backgroundColor, pageControl.pageIndicatorTintColor);
    }
  }
}

- (void)testPageControlChangeFrameDefaultDots {
  MZPageControl *pageControl = [[MZPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 100.0f)];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  CGFloat previousOriginX = [pageControl.dotsArray[0] frame].origin.x;
  pageControl.frame = CGRectMake(0.0f, 0.0f, 400.0f, 100.0f);
  
  XCTAssert([pageControl.dotsArray[0] frame].origin.x > previousOriginX);
}

- (void)testXOriginForDotAtIndexPathValue {
  MZPageControl *pageControl = [[MZPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 100.0f)];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  XCTAssertEqual([pageControl xOriginForDotAtIndex:2], pageControl.frame.size.width / 2.0f - [pageControl.dotsArray[2] frame].size.width / 2.0f);
}

- (void)testXOriginForDotAtIndexPathNegativeValue {
  MZPageControl *pageControl = [[MZPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 100.0f)];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  XCTAssertEqual([pageControl xOriginForDotAtIndex:-1], INFINITY);
}

#pragma mark - View Changes And Sizes

- (void)testPageControlSizeToFit {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  [pageControl sizeToFit];
  
  for (UIView *dot in pageControl.dotsArray) {
    XCTAssertEqual(dot.frame.origin.y, 0.0f);
  }
}

- (void)testPageControlIntrinsicContentSize {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  pageControl.frame = CGRectMake(0.0f, 0.0f, [pageControl intrinsicContentSize].width, [pageControl intrinsicContentSize].height);
  
  for (UIView *dot in pageControl.dotsArray) {
    XCTAssertEqual(dot.frame.origin.y, 0.0f);
  }
}

- (void)testPageControlLayoutSubviews {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  CGFloat previousOriginX = [pageControl.dotsArray[0] frame].origin.x;
  pageControl.frame = CGRectMake(0.0f, 0.0f, 400.0f, 100.0f);
  
  [pageControl setNeedsLayout];
  [pageControl layoutIfNeeded];
  
  XCTAssert([pageControl.dotsArray[0] frame].origin.x > previousOriginX);
}

- (void)testPageControlSizeForNumberOfPagesNoPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 0;
  [pageControl sizeToFit];
  
  XCTAssertEqual(pageControl.frame.size.width, 0.0f);
  XCTAssertEqual(pageControl.frame.size.height, 0.0f);
}

- (void)testPageControlSizeForNumberOfPagesOnePage {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 1;
  [pageControl sizeToFit];
  
  XCTAssertEqual(pageControl.frame.size.width, [pageControl.dotsArray[0] frame].size.width);
  XCTAssertEqual(pageControl.frame.size.height, [pageControl.dotsArray[0] frame].size.height);
}

- (void)testPageControlSizeForNumberOfPagesTwoPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 2;
  [pageControl sizeToFit];
  
  XCTAssertEqual(pageControl.frame.size.width, [pageControl.dotsArray[0] frame].size.width * 2.0f + pageControl.dotsSpace);
  XCTAssertEqual(pageControl.frame.size.height, [pageControl.dotsArray[0] frame].size.height);
}

- (void)testPageControlSizeForNumberOfPagesTenPages {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 10;
  [pageControl sizeToFit];
  
  XCTAssertEqual(pageControl.frame.size.width, [pageControl sizeForNumberOfPages:10].width);
  XCTAssertEqual(pageControl.frame.size.height, [pageControl sizeForNumberOfPages:10].height);
}

- (void)testDistanceBetweenDotsChange {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 2;
  pageControl.dotsSpace = 10.0f;
  [pageControl sizeToFit];
  
  XCTAssertEqual(pageControl.frame.size.width, [pageControl.dotsArray[0] frame].size.width + 10.0f + [pageControl.dotsArray[1] frame].size.width);
}

#pragma mark - Custom Dot Images

- (void)testPageControlCustomImagesInactiveAllTheSame {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  pageControl.leftDotImageInactive = self.activeMiddleImage;
  pageControl.middleDotImageInactive = self.activeMiddleImage;
  pageControl.rightDotImageInactive = self.activeMiddleImage;
  
  for (UIImageView *dot in pageControl.dotsArray) {
    if ([dot isKindOfClass:[UIImageView class]]) {
      XCTAssertEqualObjects(dot.image, self.activeMiddleImage);
    }
  }
}

- (void)testPageControlCustomImagesActiveAllTheSameCurrent {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  pageControl.leftDotImageActive = self.inactiveMiddleImage;
  pageControl.middleDotImageActive = self.inactiveMiddleImage;
  pageControl.rightDotImageActive = self.inactiveMiddleImage;
  
  XCTAssertEqualObjects([pageControl.dotsArray[0] image], self.inactiveMiddleImage);
}

- (void)testPageControlCustomImagesActiveAllTheSameOthers {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  pageControl.leftDotImageActive = self.activeMiddleImage;
  pageControl.middleDotImageActive = self.activeMiddleImage;
  pageControl.rightDotImageActive = self.activeMiddleImage;
  
  for (UIImageView *dot in pageControl.dotsArray) {
    if ([dot isKindOfClass:[UIImageView class]] && dot != pageControl.dotsArray[0]) {
      XCTAssertNotEqualObjects(dot.image, self.activeMiddleImage);
    }
  }
}

- (void)testPageControlCustomImagesActiveLeft {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  pageControl.leftDotImageActive = self.inactiveLeftImage;
  pageControl.middleDotImageActive = self.inactiveMiddleImage;
  pageControl.rightDotImageActive = self.inactiveRightImage;
  
  XCTAssertEqualObjects([pageControl.dotsArray[0] image], self.inactiveLeftImage);
}

- (void)testPageControlCustomImagesActiveLeftOthersDifferent {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 4;
  
  pageControl.leftDotImageActive = self.inactiveLeftImage;
  pageControl.middleDotImageActive = self.inactiveMiddleImage;
  pageControl.rightDotImageActive = self.inactiveRightImage;
  
  for (UIImageView *dot in pageControl.dotsArray) {
    if ([dot isKindOfClass:[UIImageView class]] && dot != pageControl.dotsArray[4]) {
      XCTAssertNotEqualObjects(dot.image, self.inactiveLeftImage);
    }
  }
}

- (void)testPageControlCustomImagesInactiveMiddle {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  
  pageControl.leftDotImageActive = self.inactiveLeftImage;
  pageControl.middleDotImageActive = self.inactiveMiddleImage;
  pageControl.rightDotImageActive = self.inactiveRightImage;
  
  pageControl.leftDotImageInactive = self.inactiveLeftImage;
  pageControl.middleDotImageInactive = self.inactiveMiddleImage;
  pageControl.rightDotImageInactive = self.inactiveRightImage;
  
  for (UIImageView *dot in pageControl.dotsArray) {
    if (dot != [pageControl.dotsArray firstObject] && dot != [pageControl.dotsArray lastObject]) {
      XCTAssertEqualObjects(dot.image, self.inactiveMiddleImage);
    }
  }
}

- (void)testPageControlCustomImagesInactiveMiddleOthersDifferent {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 4; // Arbitrary value
  
  pageControl.leftDotImageActive = self.inactiveLeftImage;
  pageControl.middleDotImageActive = self.inactiveMiddleImage;
  pageControl.rightDotImageActive = self.inactiveRightImage;
  
  pageControl.leftDotImageInactive = self.inactiveLeftImage;
  pageControl.middleDotImageInactive = self.inactiveMiddleImage;
  pageControl.rightDotImageInactive = self.inactiveRightImage;
  
  UIImage *imageLeft = (UIImage *)[pageControl.dotsArray[0] image];
  UIImage *imageRight = (UIImage *)[pageControl.dotsArray[4] image];
  
  XCTAssert(imageLeft != self.inactiveMiddleImage);
  XCTAssert(imageRight != self.inactiveMiddleImage);
}

- (void)testPageControlMiddleDotImageActiveOnePage {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 1;
  pageControl.currentPage = 0;
  
  pageControl.middleDotImageActive = self.activeMiddleImage;
  
  UIImage *imageDot = (UIImage *)[pageControl.dotsArray[0] image];
  
  XCTAssertEqualObjects(imageDot, self.activeMiddleImage);
}

- (void)testPageControlMiddleImageActive {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 2;
  
  pageControl.middleDotImageActive = self.activeMiddleImage;
  
  UIImage *imageDot = (UIImage *)[pageControl.dotsArray[2] image];
  
  XCTAssertEqualObjects(imageDot, self.activeMiddleImage);
}

#pragma mark - Properties

- (void)testPageControlHidesForSinglePageFirst {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.hidesForSinglePage = YES;
  pageControl.numberOfPages = 1;
  
  XCTAssertEqual(pageControl.dotsArray.count, 0);
}

- (void)testPageControlHidesForSinglePageAfterward {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 1;
  pageControl.hidesForSinglePage = YES;
  pageControl.numberOfPages = 1;
  
  XCTAssertEqual(pageControl.dotsArray.count, 0);
}

- (void)testPageControlDefersCurrentPageDisplayBeforeUpdate {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  pageControl.defersCurrentPageDisplay = YES;
  pageControl.currentPage = 4;
  
  XCTAssertEqualObjects([pageControl.dotsArray[4] backgroundColor], pageControl.pageIndicatorTintColor);
}

- (void)testPageControlDefersCurrentPageDisplayAfterUpdate {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  pageControl.defersCurrentPageDisplay = YES;
  pageControl.currentPage = 4;
  [pageControl updateCurrentPageDisplay];
  
  XCTAssertEqualObjects([pageControl.dotsArray[4] backgroundColor], pageControl.currentPageIndicatorTintColor);
}

- (void)testPageControlResetDotsTintColor {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 4;
  pageControl.pageIndicatorTintColor = [UIColor redColor];
  pageControl.pageIndicatorTintColor = nil;
  
  XCTAssertEqualObjects([pageControl.dotsArray[0] backgroundColor], [[UIColor whiteColor] colorWithAlphaComponent:0.5f]);
}

- (void)testPageControlResetCurrentDotTintColor {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  pageControl.currentPageIndicatorTintColor = [UIColor redColor];
  pageControl.currentPageIndicatorTintColor = nil;
  
  XCTAssertEqualObjects([pageControl.dotsArray[0] backgroundColor], [UIColor whiteColor]);
}

#pragma mark - Actions

- (void)testPageControlTapDot {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  UIView *dotView = pageControl.dotsArray[2];
  [pageControl didTapDot:dotView.gestureRecognizers[0]];
  
  XCTAssertEqual(pageControl.currentPage, 2);
}

- (void)testPageControlTapDotInvalidType {
  MZPageControl *pageControl = [[MZPageControl alloc] init];
  pageControl.numberOfPages = 5;
  pageControl.currentPage = 0;
  
  UIView *dotView = pageControl.dotsArray[2];
  [pageControl didTapDot:dotView];
  
  XCTAssertNotEqual(pageControl.currentPage, 2);
}

@end
