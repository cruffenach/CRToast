//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CRToast/CRToast.h>
#import "CRToastView.h"

@interface CRToastViewTests : XCTestCase
@property (strong, nonatomic) CRToastView *view;
@end

CRToast * __TestToast(void) {
    return [[CRToast alloc] init];
}

@implementation CRToastViewTests

#pragma mark Image Alignment
- (void)pending_testImageFrameLeftAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon"];
    options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    
    toast.options = options;
    self.view.toast = toast;
    
    CGRect assumedRect = CGRectMake(0, 0, 100, 100);
    
    [self.view layoutSubviews];
    
    BOOL rectsEqual = CGRectEqualToRect(assumedRect, self.view.imageView.frame);
    
    XCTAssertTrue(rectsEqual, @"left aligned rect should be equal to assumed rect. Intead was %@", NSStringFromCGRect(self.view.imageView.frame));
}

- (void)pending_testImageFrameCenterAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon"];
    options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentCenter);
    
    toast.options = options;
    self.view.toast = toast;
    
    [self.view layoutSubviews];
    
    BOOL centersEqual = CGPointEqualToPoint(self.view.center, self.view.imageView.center);
    
    XCTAssertTrue(centersEqual, @"center of image view should be center of self.view (%@). Intead was %@", NSStringFromCGPoint(self.view.center), NSStringFromCGPoint(self.view.imageView.center));
}

- (void)pending_testImageFrameRightAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon"];
    options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentRight);
    
    toast.options = options;
    self.view.toast = toast;
    
    CGRect assumedRect = CGRectMake(200, 0, 100, 100);
 
    [self.view layoutSubviews];
    
    BOOL rectsEqual = CGRectEqualToRect(assumedRect, self.view.imageView.frame);
    
    XCTAssertTrue(rectsEqual, @"right aligned rect should be equal to assumed rect. Intead was %@", NSStringFromCGRect(self.view.imageView.frame));
}

#pragma mark Activity Indicator Alignment
- (void)testActivityFrameLeftAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastShowActivityIndicatorKey] = @YES;
    options[kCRToastActivityIndicatorAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    
    toast.options = options;
    self.view.toast = toast;
    
    CGPoint assumedCenter = CGPointMake(50, 50);
    
    [self.view layoutSubviews];
    
    CGPointEqualToPoint(assumedCenter, self.view.activityIndicator.center);
    BOOL centersEqual = CGPointEqualToPoint(assumedCenter, self.view.activityIndicator.center);
    
    XCTAssertTrue(centersEqual, @"left aligned activity indicator center shold equal assumed center. Instead was %@", NSStringFromCGPoint(self.view.activityIndicator.center));
}

- (void)testActivityFrameCenterAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastShowActivityIndicatorKey] = @YES;
    options[kCRToastActivityIndicatorAlignmentKey] = @(CRToastAccessoryViewAlignmentCenter);
    
    toast.options = options;
    self.view.toast = toast;
    
    CGPoint assumedCenter = self.view.center;
    
    [self.view layoutSubviews];
    
    BOOL centersEqual = CGPointEqualToPoint(assumedCenter, self.view.activityIndicator.center);
    
    XCTAssertTrue(centersEqual, @"center aligned activity indicator center shold equal assumed center (%@). Instead was %@", NSStringFromCGPoint(self.view.center), NSStringFromCGPoint(self.view.activityIndicator.center));
}

- (void)testActivityFrameRightAlignment {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastShowActivityIndicatorKey] = @YES;
    options[kCRToastActivityIndicatorAlignmentKey] = @(CRToastAccessoryViewAlignmentRight);
    
    toast.options = options;
    self.view.toast = toast;
    
    CGPoint assumedCenter = CGPointMake(250, 50);
    
    [self.view layoutSubviews];
    
    CGPointEqualToPoint(assumedCenter, self.view.activityIndicator.center);
    BOOL centersEqual = CGPointEqualToPoint(assumedCenter, self.view.activityIndicator.center);
    
    XCTAssertTrue(centersEqual, @"right aligned activity indicator center shold equal assumed center. Instead was %@", NSStringFromCGPoint(self.view.activityIndicator.center));
}

#pragma mark Padding

- (void)testPreferredPaddingSetToZero {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon"];
    options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    options[kCRToastTextKey] = @"Test";
    options[kCRToastTextAlignmentKey] = @(NSTextAlignmentLeft);
    options[kCRToastNotificationPreferredPaddingKey] = @0;
    
    toast.options = options;
    self.view.toast = toast;
    
    [self.view layoutSubviews];
    
    CGFloat imageViewX = CGRectGetMinX(self.view.imageView.frame);
    
    XCTAssertTrue(imageViewX == 0.0, @"With no padding minX should be 0.0. Instead was %f", imageViewX);
}

- (void)testPrefferedPaddingIsRespectedWhenHigher {
    CRToast *toast = __TestToast();
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    options[kCRToastShowActivityIndicatorKey] = @YES;
    options[kCRToastActivityIndicatorAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    options[kCRToastTextKey] = @"Test";
    options[kCRToastTextAlignmentKey] = @(NSTextAlignmentLeft);
    options[kCRToastNotificationPreferredPaddingKey] = @20;
    
    toast.options = options;
    self.view.toast = toast;
    
    [self.view layoutSubviews];
    
    CGFloat imageViewX = CGRectGetMinX(self.view.imageView.frame);
    
    XCTAssertTrue(imageViewX == 20.0, @"With no padding minX should be 20.0. Instead was %f", imageViewX);
}

#pragma mark Width Calculations
- (void)testWidthWithOnlyLeftItem {
    
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(300, 100, 0.0f, YES, CRToastAccessoryViewAlignmentLeft, NO, CRToastAccessoryViewAlignmentLeft);
    
    XCTAssertTrue(width == 200, @"Width with only left item should be 200 (full width - (height x 1)). Instead was %f", width);
}

- (void)testWidthWithOnlyCenterItem {
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(300, 100, 0.0f, YES, CRToastAccessoryViewAlignmentCenter, NO, CRToastAccessoryViewAlignmentLeft);
    
    XCTAssertTrue(width == 300, @"Width with only center item should be 300 (full width). Instead was %f", width);
}

- (void)testWidthWithOnlyRightItem {
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(300, 100, 0.0f, YES, CRToastAccessoryViewAlignmentRight, NO, CRToastAccessoryViewAlignmentLeft);
    
    XCTAssertTrue(width == 200, @"Width with only center item should be 300 (full width - (height x 1)). Instead was %f", width);
}

- (void)testWidthWithLeftAndCenter {
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(300, 100, 0.0f, YES, CRToastAccessoryViewAlignmentLeft, YES, CRToastAccessoryViewAlignmentCenter);
    
    XCTAssertTrue(width == 200, @"Width with left & center item should be 200 (full width - (height x 1)). Instead was %f", width);
}

- (void)testWidthWithLeftAndRight {
    CGFloat width = CRContentWidthForAccessoryViewsWithAlignments(300, 100, 0.0f, YES, CRToastAccessoryViewAlignmentLeft, YES, CRToastAccessoryViewAlignmentRight);
    
    XCTAssertTrue(width == 100, @"Width with left & right item should be 200 (full width - (height x 2)). Instead was %f", width);
}

/*
// Causes travis to fail against iOS 7/7.1 SDK
- (void)testPerformanceExample {
    [self measureBlock:^{
        CRContentWidthForAccessoryViewsWithAlignments(300, 100, YES, CRToastAccessoryViewAlignmentLeft, YES, CRToastAccessoryViewAlignmentRight);
    }];
}
*/

#pragma mark - Setup
- (void)setUp {
    [super setUp];
    self.view = [[CRToastView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
}

- (void)tearDown {
    self.view = nil;
    [super tearDown];
}

@end
