//
//  CRToastLayoutHelpers.h
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRToast.h" // For NS_ENUM values

static BOOL kCRFrameAutoAdjustedForOrientation = NO;
static BOOL kCRUseSizeClass = NO;

static CGFloat const CRNavigationBarDefaultHeight = 45.0f;
static CGFloat const CRNavigationBarDefaultHeightiPhoneLandscape = 33.0f;

static UIInterfaceOrientation CRGetDeviceOrientation() {
    return [UIApplication sharedApplication].statusBarOrientation;
}

static CGFloat CRGetStatusBarHeightForOrientation(UIInterfaceOrientation orientation) {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    if (kCRFrameAutoAdjustedForOrientation) {
        return CGRectGetHeight(statusBarFrame);
    }
    
    return (UIDeviceOrientationIsLandscape(orientation)) ?
    CGRectGetWidth(statusBarFrame) :
    CGRectGetHeight(statusBarFrame);
}

static CGFloat CRGetStatusBarWidthForOrientation(UIInterfaceOrientation orientation) {
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    
    if (kCRFrameAutoAdjustedForOrientation) {
        return CGRectGetWidth(mainScreenBounds);
    }
    
    return (UIDeviceOrientationIsPortrait(orientation)) ?
    CGRectGetWidth(mainScreenBounds) :
    CGRectGetHeight(mainScreenBounds);
}

static CGFloat CRGetStatusBarWidth() {
    return CRGetStatusBarWidthForOrientation(CRGetDeviceOrientation());
}

static CGFloat CRGetNavigationBarHeightForOrientation(UIInterfaceOrientation orientation) {
    BOOL regularHorizontalSizeClass = NO;
    if (kCRUseSizeClass) {
        UITraitCollection *traitCollection = [[UIScreen mainScreen] traitCollection];
        regularHorizontalSizeClass = traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular;
    }
    return (UIDeviceOrientationIsPortrait(orientation) ||
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || regularHorizontalSizeClass) ?
    CRNavigationBarDefaultHeight :
    CRNavigationBarDefaultHeightiPhoneLandscape;
}

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

static CGFloat CRGetNotificationViewHeight(CRToastType type, CGFloat preferredNotificationHeight) {
    return CRGetNotificationViewHeightForOrientation(type, preferredNotificationHeight, CRGetDeviceOrientation());
}

// Lumped all functions that warn as unused
// together so they can be ignored together 
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static CGFloat CRGetStatusBarHeight() {
    return CRGetStatusBarHeightForOrientation(CRGetDeviceOrientation());
}

static CGSize CRNotificationViewSizeForOrientation(CRToastType notificationType, CGFloat preferredNotificationHeight, UIInterfaceOrientation orientation) {
    return CGSizeMake(CRGetStatusBarWidthForOrientation(orientation), CRGetNotificationViewHeightForOrientation(notificationType, preferredNotificationHeight, orientation));
}

static CGSize CRNotificationViewSize(CRToastType notificationType, CGFloat preferredNotificationHeight) {
    return CGSizeMake(CRGetStatusBarWidth(), CRGetNotificationViewHeight(notificationType, preferredNotificationHeight));
}

static CGRect CRNotificationViewFrame(CRToastType type, CRToastAnimationDirection direction, CGFloat preferredNotificationHeight) {
    return CGRectMake(direction == CRToastAnimationDirectionLeft ? -CRGetStatusBarWidth() : direction == CRToastAnimationDirectionRight ? CRGetStatusBarWidth() : 0,
                      direction == CRToastAnimationDirectionTop ? -CRGetNotificationViewHeight(type, preferredNotificationHeight) : direction == CRToastAnimationDirectionBottom ? CRGetNotificationViewHeight(type, preferredNotificationHeight) : 0,
                      CRGetStatusBarWidth(),
                      CRGetNotificationViewHeight(type, preferredNotificationHeight));
}

static CGRect CRStatusBarViewFrame(CRToastType type, CRToastAnimationDirection direction, CGFloat preferredNotificationHeight) {
    return CRNotificationViewFrame(type,
                                   direction == CRToastAnimationDirectionTop ? CRToastAnimationDirectionBottom :
                                   direction == CRToastAnimationDirectionBottom ? CRToastAnimationDirectionTop :
                                   direction == CRToastAnimationDirectionLeft ? CRToastAnimationDirectionRight :
                                   CRToastAnimationDirectionLeft,
                                   preferredNotificationHeight);
}

static UIView *CRStatusBarSnapShotView(BOOL underStatusBar) {
    return underStatusBar ?
    [[UIApplication sharedApplication].keyWindow.rootViewController.view snapshotViewAfterScreenUpdates:YES] :
    [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
}
#pragma clang diagnostic pop

@interface CRToastLayoutHelpers : NSObject
@end
