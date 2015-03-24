//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CRToast/CRToast.h>
#import <CRToast/CRToastManager.h>

@interface CRToastManagerTests : XCTestCase
@end


NSMutableDictionary * __TestToastOptionsDictionary(void) {
    return [@{} mutableCopy];
}

@implementation CRToastManagerTests

- (void)testEmptyDefaultOptions
{
    [CRToastManager setDefaultOptions:@{}];
}

- (void)testNotificationIdentifiers {
    NSMutableDictionary *options = __TestToastOptionsDictionary();
    
    for (NSString *str in @[@"1", @"2", @"3", @"3", @"4"]) {
        options[kCRToastTimeIntervalKey] = @15;
        options[kCRToastIdentifierKey] = str;
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    }
    
    // Add another notification without identifier creating 6 items in queue
    [CRToastManager showNotificationWithOptions:__TestToastOptionsDictionary() completionBlock:nil];
    
    NSArray *identifiers = [CRToastManager notificationIdentifiersInQueue];
    
    XCTAssertTrue(identifiers.count == 5, @"identifiers should contain 5 items. Instead contains %lu", (long)identifiers.count);
    
    XCTAssertTrue([identifiers containsObject:@"2"], @"identifiers should contain an identifier '2'.");
    
    XCTAssertFalse([identifiers containsObject:@"test"], @"identifiers should not contain an identifier 'test'.");
}

- (void)testDismissByIdentifier {
    NSMutableDictionary *options = __TestToastOptionsDictionary();
    
    for (NSString *str in @[@"1", @"2", @"3", @"3", @"4"]) {
        options[kCRToastTimeIntervalKey] = @15;
        options[kCRToastIdentifierKey] = str;
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    }
    
    // Add another notification without identifier creating 6 items in queue
    [CRToastManager showNotificationWithOptions:__TestToastOptionsDictionary() completionBlock:nil];
    
    [CRToastManager dismissAllNotificationsWithIdentifier:@"3" animated:NO];
    
    NSArray *identifiers = [CRToastManager notificationIdentifiersInQueue];
    
    XCTAssertTrue(identifiers.count == 3, @"identifiers should contain 3 items. Instead contains %lu", (long)identifiers.count);
    
    XCTAssertTrue([identifiers containsObject:@"2"], @"identifiers should contain an identifier '2'.");
    
    XCTAssertFalse([identifiers containsObject:@"3"], @"identifiers should not contain an identifier '3'.");

}

#pragma mark - Setup
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [CRToastManager dismissAllNotifications:NO];
    
    [super tearDown];
}

@end
