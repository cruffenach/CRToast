//
//  CRToastManagerTests.m
//  CRToastDemo
//
//  Created by Daniel on 12/27/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRToastManager.h"
#import "CRToast.h"

@interface CRToastManagerTests : XCTestCase
@end

@implementation CRToastManagerTests

- (void)testEmptyDefaultOptions
{
    [CRToastManager setDefaultOptions:@{}];
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

@end
