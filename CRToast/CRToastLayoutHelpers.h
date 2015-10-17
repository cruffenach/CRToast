//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRToast.h" // For NS_ENUM values

/**
 `BOOL` to determine if the frame is automatically adjusted for orientation. iOS 8 automatically accounts for orientation when getting frame where as iOS 7 does not.
 If/when iOS 7 support is dropped this check will no longer be necessary
 */
static inline BOOL CRFrameAutoAdjustedForOrientation() {
#ifdef __IPHONE_8_0
    return [[UIScreen mainScreen] respondsToSelector:@selector(traitCollection)];
#else
    return NO;
#endif
}

/**
 `BOOL` to determine if we can use size classes for determining layout.
 Only available in iOS 8 so we don't want to attempt to use size classes if we're not running iOS 8
 */
static inline BOOL CRUseSizeClass() {
#ifdef __IPHONE_8_0
    return [[UIScreen mainScreen] respondsToSelector:@selector(traitCollection)];
#else
    return NO;
#endif
}

static BOOL CRHorizontalSizeClassRegular() {
    if (CRUseSizeClass()) {
#ifdef __IPHONE_8_0
        return [UIScreen mainScreen].traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular;
#endif
    }
    return NO;
}

#pragma mark - Variables
/// Default height of the status bar + 1 pixel
static CGFloat const CRNavigationBarDefaultHeight = 45.0f;
/// Height of the status bar in landscape orientation/compact size class + 1 pixel
static CGFloat const CRNavigationBarDefaultHeightiPhoneLandscape = 33.0f;

#pragma mark - Orientation Helper
/**
 Get the current device status bar orientation
 */
static UIInterfaceOrientation CRGetDeviceOrientation() {
    return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - Status Bar Frame
/// Get the height of the status bar for given orientation.
static CGFloat CRGetStatusBarHeightForOrientation(UIInterfaceOrientation orientation) {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];

    if (CRFrameAutoAdjustedForOrientation()) {
        return CGRectGetHeight(statusBarFrame);
    }

    return (UIInterfaceOrientationIsLandscape(orientation)) ?
    CGRectGetWidth(statusBarFrame) :
    CGRectGetHeight(statusBarFrame);
}

/// Get the width of the status bar for given orientation.
static CGFloat CRGetStatusBarWidthForOrientation(UIInterfaceOrientation orientation) {
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;

    if (CRFrameAutoAdjustedForOrientation()) {
        return CGRectGetWidth(mainScreenBounds);
    }

    return (UIInterfaceOrientationIsPortrait(orientation)) ?
    CGRectGetWidth(mainScreenBounds) :
    CGRectGetHeight(mainScreenBounds);
}

/// Get the width of the status bar for the current orientation
static CGFloat CRGetStatusBarWidth() {
    return CRGetStatusBarWidthForOrientation(CRGetDeviceOrientation());
}

#pragma mark - Navigation Bar Frame
/**
 Get the height of the status bar for given orientation.

 \note if size classes can be used this method will account for compact vs regular size class
 */
static CGFloat CRGetNavigationBarHeightForOrientation(UIInterfaceOrientation orientation) {
    BOOL regularHorizontalSizeClass = NO;
    if (CRUseSizeClass()) {
        regularHorizontalSizeClass = CRHorizontalSizeClassRegular();
    }
    return (UIInterfaceOrientationIsPortrait(orientation) ||
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || regularHorizontalSizeClass) ?
    CRNavigationBarDefaultHeight :
    CRNavigationBarDefaultHeightiPhoneLandscape;
}

#pragma mark - Notification Frame
/**
 Get the height of view needed to contain the notification given the specific orienation & notification type
 */
static CGFloat CRGetNotificationViewHeightForOrientation(CRToastType type, CGFloat preferredNotificationHeight, UIInterfaceOrientation orientation) {
    switch (type) {
        case CRToastTypeStatusBar:
            return CRGetStatusBarHeightForOrientation(orientation);
        case CRToastTypeNavigationBar:
            return CRGetStatusBarHeightForOrientation(orientation) + CRGetNavigationBarHeightForOrientation(orientation);
        case CRToastTypeCustom:
            return preferredNotificationHeight;
    }
}

/**
 Get the height of the view needed for specified notification type & preferred height.

 \note uses the devices current orientation for calculation
 */
static CGFloat CRGetNotificationViewHeight(CRToastType type, CGFloat preferredNotificationHeight) {
    return CRGetNotificationViewHeightForOrientation(type, preferredNotificationHeight, CRGetDeviceOrientation());
}

#pragma mark - -- clang diagnostic warning supression --
// Lumped all functions that warn as unused
// together so they can be ignored together
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

#pragma mark - Status Bar
/// Get the height of the status bar for the current orientation
static CGFloat CRGetStatusBarHeight() {
    return CRGetStatusBarHeightForOrientation(CRGetDeviceOrientation());
}

#pragma mark - Notification View Frame
/// Get the size for the notification view based on type & orientation.
static CGSize CRNotificationViewSizeForOrientation(CRToastType notificationType, CGFloat preferredNotificationHeight, UIInterfaceOrientation orientation) {
    return CGSizeMake(CRGetStatusBarWidthForOrientation(orientation), CRGetNotificationViewHeightForOrientation(notificationType, preferredNotificationHeight, orientation));
}

/// Get the size for the notification view using the current orienation
static CGSize CRNotificationViewSize(CRToastType notificationType, CGFloat preferredNotificationHeight) {
    return CGSizeMake(CRGetStatusBarWidth(), CRGetNotificationViewHeight(notificationType, preferredNotificationHeight));
}

/// Get the frame for the notification view based on type, animation direction & preferred height if specified.
static CGRect CRNotificationViewFrame(CRToastType type, CRToastAnimationDirection direction, CGFloat preferredNotificationHeight) {
    return CGRectMake(direction == CRToastAnimationDirectionLeft ? -CRGetStatusBarWidth() : direction == CRToastAnimationDirectionRight ? CRGetStatusBarWidth() : 0,
                      direction == CRToastAnimationDirectionTop ? -CRGetNotificationViewHeight(type, preferredNotificationHeight) : direction == CRToastAnimationDirectionBottom ? CRGetNotificationViewHeight(type, preferredNotificationHeight) : 0,
                      CRGetStatusBarWidth(),
                      CRGetNotificationViewHeight(type, preferredNotificationHeight));
}

/// Get the status bar view frame based on notification type, animation direction & preferred height if specified.
static CGRect CRStatusBarViewFrame(CRToastType type, CRToastAnimationDirection direction, CGFloat preferredNotificationHeight) {
    CRToastAnimationDirection _direction;
    switch (direction) {
        case CRToastAnimationDirectionTop:
            _direction = CRToastAnimationDirectionBottom; break;
        case CRToastAnimationDirectionBottom:
            _direction = CRToastAnimationDirectionTop; break;
        case CRToastAnimationDirectionLeft:
            _direction = CRToastAnimationDirectionRight; break;
        case CRToastAnimationDirectionRight:
            _direction = CRToastAnimationDirectionLeft; break;
        default:
            break;
    }
    return CRNotificationViewFrame(type, _direction, preferredNotificationHeight);
}

#pragma mark - Notification Container Frame
/// Get the notifications container frame based on orientation & notification size
static CGRect CRGetNotificationContainerFrame(UIInterfaceOrientation statusBarOrientation, CGSize notificationSize) {
    CGRect containerFrame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);

    if (!CRFrameAutoAdjustedForOrientation()) {
        switch (statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft: {
                containerFrame = CGRectMake(0, 0, notificationSize.height, notificationSize.width);
                break;
            }
            case UIInterfaceOrientationLandscapeRight: {
                containerFrame = CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-notificationSize.height, 0, notificationSize.height, notificationSize.width);
                break;
            }
            case UIInterfaceOrientationPortraitUpsideDown: {
                containerFrame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds])-notificationSize.height, notificationSize.width, notificationSize.height);
                break;
            }
            default: {
                break;
            }
        }

    }
    return containerFrame;
}

/// Get view snapshot. If `underStatusBar` it will get key windows root view controller. Otherwise it'll get the mainscreens snapshot
static UIView *CRStatusBarSnapShotView(BOOL underStatusBar) {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return underStatusBar ?
        [[UIApplication sharedApplication].keyWindow.rootViewController.view snapshotViewAfterScreenUpdates:YES] :
        [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    } else {
        return underStatusBar ?
        [[UIApplication sharedApplication].keyWindow.rootViewController.view snapshotViewAfterScreenUpdates:NO] :
        [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    }
}