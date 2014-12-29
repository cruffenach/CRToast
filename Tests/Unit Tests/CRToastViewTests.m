//
//  CRToastViewTests.m
//  CRToastDemo
//
//  Created by Daniel on 12/27/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRToastView.h"
#import "CRToast.h"

@interface CRToastViewTests : XCTestCase

@end

@implementation CRToastViewTests

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

#pragma mark Image Alignment
- (void)testImageFrameLeftAlignment {
    
}

- (void)testImageFrameCenterAlignment {
    
}

- (void)testImageFrameRightAlignment {
    
}

#pragma mark Activity Indicator Alignment
- (void)testActivityFrameLeftAlignment {
    
}

- (void)testActivityFrameCenterAlignment {
    
}

- (void)testActivityFrameRightAlignment {
    
}

#pragma mark Width Calculations
- (void)testWidthWithOnlyLeftItem {
    
}

- (void)testWidthWithOnlyCenterItem {
    
}

- (void)testWidthWithOnlyRightItem {
    
}

- (void)testWidthWithLeftAndCenter {
    
}

- (void)testWidthWithLeftAndRight {
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - Setup
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (CRToast *)testToast {
    return [[CRToast alloc] init];
}

@end
