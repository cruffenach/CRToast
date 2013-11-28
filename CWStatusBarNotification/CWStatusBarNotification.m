//
//  CWStatusBarNotification.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CWStatusBarNotification.h"

static CGFloat const CWStatusBarDefaultHeight = 44.0f;
static CGFloat const CWStatusBariPhoneLandscape = 30.0f;

static CGFloat const CWStatusBarAnimationLength = 0.25f;
static CGFloat const CWDefaultFontSize = 12.0f;

@interface CWStatusBarNotification ()
@property (strong, nonatomic) UILabel *notificationLabel;
@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIWindow *notificationWindow;
@end

static CGFloat CWGetStatusBarHeight() {
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    return statusBarHeight;
}

static CGFloat CWGetStatusBarWidth() {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return [UIScreen mainScreen].bounds.size.height;
}

static CGFloat CWGetNavigationBarHeight() {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ||
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CWStatusBarDefaultHeight;
    }
    return CWStatusBariPhoneLandscape;
}

static CGFloat CWGetNotificationLabelHeight(CWNotificationStyle notificationStyle) {
    switch (notificationStyle) {
        case CWNotificationStyleStatusBarNotification:
            return CWGetStatusBarHeight();
        case CWNotificationStyleNavigationBarNotification:
            return CWGetStatusBarHeight() + CWGetNavigationBarHeight();
        default:
            return CWGetStatusBarHeight();
    }
}

static CGRect CWGetNotificationLabelTopFrame(CWNotificationStyle notificationStyle) {
    return CGRectMake(0, -1*CWGetNotificationLabelHeight(notificationStyle), CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelLeftFrame(CWNotificationStyle notificationStyle) {
    return CGRectMake(-1*CWGetStatusBarWidth(), 0, CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelRightFrame(CWNotificationStyle notificationStyle) {
    return CGRectMake(CWGetStatusBarWidth(), 0, CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelBottomFrame(CWNotificationStyle notificationStyle) {
    return CGRectMake(0, CWGetNotificationLabelHeight(notificationStyle), CWGetStatusBarWidth(), 0);
}

static CGRect CWGetNotificationLabelFrame(CWNotificationStyle notificationStyle) {
    return CGRectMake(0, 0, CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

@implementation CWStatusBarNotification

- (CWStatusBarNotification *)init {
    self = [super init];
    if (self) {
        // set defaults
        self.notificationLabelBackgroundColor = [[UIApplication sharedApplication] delegate].window.tintColor;
        self.notificationLabelTextColor = [UIColor whiteColor];
        self.notificationStyle = CWNotificationStyleStatusBarNotification;
        self.notificationAnimationInStyle = CWNotificationAnimationStyleBottom;
        self.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
    }
    return self;
}

# pragma mark - screen orientation change

- (void)screenOrientationChanged {
    self.notificationLabel.frame = CWGetNotificationLabelFrame(self.notificationStyle);
    self.statusBarView.hidden = YES;
}

# pragma mark - display helpers

- (void)createNotificationLabelWithMessage:(NSString *)message
{
    self.notificationLabel = [UILabel new];
    self.notificationLabel.text = message;
    self.notificationLabel.textAlignment = NSTextAlignmentCenter;
    self.notificationLabel.adjustsFontSizeToFitWidth = YES;
    self.notificationLabel.font = [UIFont systemFontOfSize:CWDefaultFontSize];
    self.notificationLabel.backgroundColor = self.notificationLabelBackgroundColor;
    self.notificationLabel.textColor = self.notificationLabelTextColor;
    switch (self.notificationAnimationInStyle) {
        case CWNotificationAnimationStyleTop:
            self.notificationLabel.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleBottom:
            self.notificationLabel.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleLeft:
            self.notificationLabel.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleRight:
            self.notificationLabel.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
            break;
            
    }
}

- (void)createNotificationWindow
{
    self.notificationWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.notificationWindow.backgroundColor = [UIColor clearColor];
    self.notificationWindow.userInteractionEnabled = NO;
    self.notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.notificationWindow.windowLevel = UIWindowLevelStatusBar;
    self.notificationWindow.rootViewController = [UIViewController new];
    self.notificationWindow.rootViewController.view.bounds = CWGetNotificationLabelFrame(self.notificationStyle);
}

- (void)createStatusBarView
{
    self.statusBarView = [[UIView alloc] initWithFrame:CWGetNotificationLabelFrame(self.notificationStyle)];
    self.statusBarView.clipsToBounds = YES;
    UIView *statusBarImageView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    [self.statusBarView addSubview:statusBarImageView];
    [self.notificationWindow.rootViewController.view addSubview:self.statusBarView];
    [self.notificationWindow.rootViewController.view sendSubviewToBack:self.statusBarView];
}

# pragma mark - frame changing

- (void)firstFrameChange
{
    self.notificationLabel.frame = CWGetNotificationLabelFrame(self.notificationStyle);
    switch (self.notificationAnimationInStyle) {
        case CWNotificationAnimationStyleTop:
            self.statusBarView.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleBottom:
            self.statusBarView.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleLeft:
            self.statusBarView.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleRight:
            self.statusBarView.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
            break;
    }
}

- (void)secondFrameChange
{
    switch (self.notificationAnimationOutStyle) {
        case CWNotificationAnimationStyleTop:
            self.statusBarView.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleBottom:
            self.statusBarView.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
            self.notificationLabel.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
            self.notificationLabel.center = CGPointMake(self.notificationLabel.center.x, CWGetNotificationLabelHeight(self.notificationStyle));
            break;
        case CWNotificationAnimationStyleLeft:
            self.statusBarView.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleRight:
            self.statusBarView.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
            break;
    }
}

- (void)thirdFrameChange
{
    self.statusBarView.frame = CWGetNotificationLabelFrame(self.notificationStyle);
    switch (self.notificationAnimationOutStyle) {
        case CWNotificationAnimationStyleTop:
            self.notificationLabel.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleBottom:
            self.notificationLabel.transform = CGAffineTransformMakeScale(1.0f, 0.0f);
            break;
        case CWNotificationAnimationStyleLeft:
            self.notificationLabel.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
            break;
        case CWNotificationAnimationStyleRight:
            self.notificationLabel.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
            break;
    }
}

# pragma mark - display notification

- (void)displayNotificationWithMessage:(NSString *)message completion:(void (^)(void))completion
{
    if (!self.notificationIsShowing) {
        self.notificationIsShowing = YES;
        
        // create UIWindow
        [self createNotificationWindow];
        
        // create UILabel
        [self createNotificationLabelWithMessage:message];
        
        // create status bar view
        [self createStatusBarView];
        
        // add label to window
        [self.notificationWindow.rootViewController.view addSubview:self.notificationLabel];
        [self.notificationWindow.rootViewController.view bringSubviewToFront:self.notificationLabel];
        [self.notificationWindow setHidden:NO];
        
        // checking for screen orientation change
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenOrientationChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        // animate
        [UIView animateWithDuration:CWStatusBarAnimationLength animations:^{
            [self firstFrameChange];
        } completion:^(BOOL finished) {
            [completion invoke];
        }];
    }

}

- (void)dismissNotification
{
    if (self.notificationIsShowing) {
        [self secondFrameChange];
        [UIView animateWithDuration:CWStatusBarAnimationLength animations:^{
            [self thirdFrameChange];
        } completion:^(BOOL finished) {
            [self.notificationLabel removeFromSuperview];
            [self.statusBarView removeFromSuperview];
            self.notificationWindow = nil;
            self.notificationIsShowing = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }];
    }
}

- (void)displayNotificationWithMessage:(NSString *)message forDuration:(CGFloat)duration
{
    [self displayNotificationWithMessage:message completion:^{
        double delayInSeconds = duration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissNotification];
        });
    }];
}

@end
