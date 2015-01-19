#import "RotationTests.h"
#import <KIF/KIFSystemTestActor.h>
#import "CRToast.h"

@implementation RotationTests

- (void)beforeEach {
    [tester waitForTimeInterval:1.0f];
}

- (void)afterEach {
    // reset device orientation
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationPortrait];
    [tester waitForTimeInterval:1.0f];
}

#pragma mark - Tests

#pragma mark   Portrait to Landscape

- (void)testToastThenLandscape {
    __block BOOL completed = NO;
    
    [CRToastManager showNotificationWithMessage:NSStringFromSelector(_cmd) completionBlock:^{
        completed = YES;
    }];
    UIView *toastView = [tester waitForViewWithAccessibilityLabel:@"CRToastView"];
    [tester waitForTimeInterval:1.0f];
    [system waitForNotificationName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice] whileExecutingBlock:^{
        [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    }];
    
    [tester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(completed, error, @"completionBlock not called before timeout");
        return KIFTestStepResultSuccess;
    } complete:NULL timeout:10.0f];
}

#pragma mark   Landscape

- (void)testLandscapeThenToast {
    __block BOOL completed = NO;
    
    [system waitForNotificationName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice] whileExecutingBlock:^{
        [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    }];
    
    [tester waitForTimeInterval:0.1f];
    
    [CRToastManager showNotificationWithMessage:NSStringFromSelector(_cmd) completionBlock:^{
        completed = YES;
    }];
    UIView *toastView = [tester waitForViewWithAccessibilityLabel:@"CRToastView"];
    
    [tester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(completed, error, @"completionBlock not called before timeout");
        return KIFTestStepResultSuccess;
    } complete:NULL timeout:10.0f];
}

#pragma mark   Landscape to Portrait


- (void)testLandscapeToastThenPortrait {
    __block BOOL completed = NO;
    
    [system waitForNotificationName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice] whileExecutingBlock:^{
        [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    }];
    
    [tester waitForTimeInterval:0.1f];
    
    [CRToastManager showNotificationWithMessage:NSStringFromSelector(_cmd) completionBlock:^{
        completed = YES;
    }];
    UIView *toastView = [tester waitForViewWithAccessibilityLabel:@"CRToastView"];
    [tester waitForTimeInterval:1.0f];
    [system waitForNotificationName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice] whileExecutingBlock:^{
        [system simulateDeviceRotationToOrientation:UIDeviceOrientationPortrait];
    }];
    
    [tester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(completed, error, @"completionBlock not called before timeout");
        return KIFTestStepResultSuccess;
    } complete:NULL timeout:10.0f];
}

@end
