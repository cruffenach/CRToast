//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import "CRToastViewController.h"
#import "CRToast.h"
#import "CRToastLayoutHelpers.h"

#pragma mark - CRToastContainerView
@interface CRToastContainerView : UIView
@end

@implementation CRToastContainerView
@end

#pragma mark - CRToastViewController

@implementation CRToastViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _autorotate = YES;
    }
    return self;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark UIViewController

- (BOOL)shouldAutorotate {
    return _autorotate;
}

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)loadView {
    self.view = [[CRToastContainerView alloc] init];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.toastView) {
        CGSize notificationSize = CRNotificationViewSizeForOrientation(self.notification.notificationType, self.notification.preferredHeight, toInterfaceOrientation);
        self.toastView.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    }
}

@end
