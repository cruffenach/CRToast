//
//  CWStatusBarNotification.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CWStatusBarNotification.h"

#define STATUS_BAR_ANIMATION_LENGTH 0.25f
#define FONT_SIZE 12.0f

@implementation CWStatusBarNotification

@synthesize notificationLabel, notificationLabelBackgroundColor, notificationLabelTextColor, notificationWindow;

@synthesize statusBarView;

@synthesize notificationStyle, notificationIsShowing;

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

# pragma mark - dimensions

- (CGFloat)getStatusBarHeight {
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    return statusBarHeight;
}

- (CGFloat)getStatusBarWidth {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGRect)getNotificationLabelTopFrame {
    return CGRectMake(0, -1*[self getNotificationLabelHeight], [self getStatusBarWidth], [self getNotificationLabelHeight]);
}

- (CGRect)getNotificationLabelLeftFrame {
    return CGRectMake(-1*[self getStatusBarWidth], 0, [self getStatusBarWidth], [self getNotificationLabelHeight]);
}

- (CGRect)getNotificationLabelRightFrame {
    return CGRectMake([self getStatusBarWidth], 0, [self getStatusBarWidth], [self getNotificationLabelHeight]);
}

- (CGRect)getNotificationLabelBottomFrame {
    return CGRectMake(0, [self getNotificationLabelHeight], [self getStatusBarWidth], 0);
}

- (CGRect)getNotificationLabelFrame {
    return CGRectMake(0, 0, [self getStatusBarWidth], [self getNotificationLabelHeight]);
}

- (CGFloat)getNavigationBarHeight {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ||
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 44.0f;
    }
    return 30.0f;
}

- (CGFloat)getNotificationLabelHeight {
    switch (self.notificationStyle) {
        case CWNotificationStyleStatusBarNotification:
            return [self getStatusBarHeight];
        case CWNotificationStyleNavigationBarNotification:
            return [self getStatusBarHeight] + [self getNavigationBarHeight];
        default:
            return [self getStatusBarHeight];
    }
}

# pragma mark - screen orientation change

- (void)screenOrientationChanged {
    self.notificationLabel.frame = [self getNotificationLabelFrame];
    self.statusBarView.hidden = YES;
}

# pragma mark - display helpers

- (void)createNotificationLabelWithMessage:(NSString *)message
{
    self.notificationLabel = [UILabel new];
    self.notificationLabel.text = message;
    self.notificationLabel.textAlignment = NSTextAlignmentCenter;
    self.notificationLabel.adjustsFontSizeToFitWidth = YES;
    self.notificationLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.notificationLabel.backgroundColor = self.notificationLabelBackgroundColor;
    self.notificationLabel.textColor = self.notificationLabelTextColor;
    switch (self.notificationAnimationInStyle) {
        case CWNotificationAnimationStyleTop:
            self.notificationLabel.frame = [self getNotificationLabelTopFrame];
            break;
        case CWNotificationAnimationStyleBottom:
            self.notificationLabel.frame = [self getNotificationLabelBottomFrame];
            break;
        case CWNotificationAnimationStyleLeft:
            self.notificationLabel.frame = [self getNotificationLabelLeftFrame];
            break;
        case CWNotificationAnimationStyleRight:
            self.notificationLabel.frame = [self getNotificationLabelRightFrame];
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
    self.notificationWindow.rootViewController.view.bounds = [self getNotificationLabelFrame];
}

- (void)createStatusBarView
{
    self.statusBarView = [[UIView alloc] initWithFrame:[self getNotificationLabelFrame]];
    self.statusBarView.clipsToBounds = YES;
    UIView *statusBarImageView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    [self.statusBarView addSubview:statusBarImageView];
    [self.notificationWindow.rootViewController.view addSubview:self.statusBarView];
    [self.notificationWindow.rootViewController.view sendSubviewToBack:self.statusBarView];
}

# pragma mark - frame changing

- (void)firstFrameChange
{
    self.notificationLabel.frame = [self getNotificationLabelFrame];
    switch (self.notificationAnimationInStyle) {
        case CWNotificationAnimationStyleTop:
            self.statusBarView.frame = [self getNotificationLabelBottomFrame];
            break;
        case CWNotificationAnimationStyleBottom:
            self.statusBarView.frame = [self getNotificationLabelTopFrame];
            break;
        case CWNotificationAnimationStyleLeft:
            self.statusBarView.frame = [self getNotificationLabelRightFrame];
            break;
        case CWNotificationAnimationStyleRight:
            self.statusBarView.frame = [self getNotificationLabelLeftFrame];
            break;
    }
}

- (void)secondFrameChange
{
    switch (self.notificationAnimationOutStyle) {
        case CWNotificationAnimationStyleTop:
            self.statusBarView.frame = [self getNotificationLabelBottomFrame];
            break;
        case CWNotificationAnimationStyleBottom:
            self.statusBarView.frame = [self getNotificationLabelTopFrame];
            self.notificationLabel.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
            self.notificationLabel.center = CGPointMake(self.notificationLabel.center.x, [self getNotificationLabelHeight]);
            break;
        case CWNotificationAnimationStyleLeft:
            self.statusBarView.frame = [self getNotificationLabelRightFrame];
            break;
        case CWNotificationAnimationStyleRight:
            self.statusBarView.frame = [self getNotificationLabelLeftFrame];
            break;
    }
}

- (void)thirdFrameChange
{
    self.statusBarView.frame = [self getNotificationLabelFrame];
    switch (self.notificationAnimationOutStyle) {
        case CWNotificationAnimationStyleTop:
            self.notificationLabel.frame = [self getNotificationLabelTopFrame];
            break;
        case CWNotificationAnimationStyleBottom:
            self.notificationLabel.transform = CGAffineTransformMakeScale(1.0f, 0.0f);
            break;
        case CWNotificationAnimationStyleLeft:
            self.notificationLabel.frame = [self getNotificationLabelLeftFrame];
            break;
        case CWNotificationAnimationStyleRight:
            self.notificationLabel.frame = [self getNotificationLabelRightFrame];
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
        [UIView animateWithDuration:STATUS_BAR_ANIMATION_LENGTH animations:^{
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
        [UIView animateWithDuration:STATUS_BAR_ANIMATION_LENGTH animations:^{
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
