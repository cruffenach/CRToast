//
//  CRToastViewController.m
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
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
@interface CRToastViewController ()
@end

@implementation CRToastViewController

UIStatusBarStyle statusBarStyle;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _autorotate = YES;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return statusBarStyle;
}

- (void)statusBarStyle:(UIStatusBarStyle)newStatusBarStyle {
    statusBarStyle = newStatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)shouldAutorotate {
    return _autorotate;
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
