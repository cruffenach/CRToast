//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "CRToastConfig.h"
#import "CRToastView.h"
#import "CRToastLayoutHelpers.h"

NSString *NSStringFromCRToastInteractionType(CRToastInteractionType interactionType) {
    switch (interactionType) {
        case CRToastInteractionTypeSwipeUp:
            return @"Swipe Up";
        case CRToastInteractionTypeSwipeLeft:
            return @"Swipe Left";
        case CRToastInteractionTypeSwipeDown:
            return @"Swipe Down";
        case CRToastInteractionTypeSwipeRight:
            return @"Swipe Right";
        case CRToastInteractionTypeSwipe:
            return @"Swipe Any Direction";
        case CRToastInteractionTypeTapOnce:
            return @"Tap Once";
        case CRToastInteractionTypeTapTwice:
            return @"Tap Twice";
        case CRToastInteractionTypeTwoFingerTapOnce:
            return @"Two Fingers Tap Once";
        case CRToastInteractionTypeTwoFingerTapTwice:
            return @"Two Fingers Tap Twice";
        case CRToastInteractionTypeTap:
            return @"Any Tap";
        case CRToastInteractionTypeAll:
            return nil;
    }
    return nil;
}

typedef void (^CRToastInteractionResponderBlock) (CRToastInteractionType interactionType);

@interface CRToastSwipeGestureRecognizer : UISwipeGestureRecognizer
@property (nonatomic, assign) BOOL automaticallyDismiss;
@property (nonatomic, assign) CRToastInteractionType interactionType;
@property (nonatomic, copy) CRToastInteractionResponderBlock block;
@end

@implementation CRToastSwipeGestureRecognizer

@end

@interface CRToastTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, assign) BOOL automaticallyDismiss;
@property (nonatomic, assign) CRToastInteractionType interactionType;
@property (nonatomic, copy) CRToastInteractionResponderBlock block;
@end

@implementation CRToastTapGestureRecognizer

@end

@interface CRToastInteractionResponder ()
@property (nonatomic, assign) CRToastInteractionType interactionType;
@property (nonatomic, assign) BOOL automaticallyDismiss;
@property (nonatomic, copy) CRToastInteractionResponderBlock block;
@end

#pragma mark - Interaction Setup Helpers

BOOL CRToastInteractionResponderIsGenertic(CRToastInteractionType interactionType) {
    return (interactionType == CRToastInteractionTypeSwipe ||
            interactionType == CRToastInteractionTypeTap   ||
            interactionType == CRToastInteractionTypeAll);
}

BOOL CRToastInteractionResponderIsSwipe(CRToastInteractionType interactionType) {
    return CRToastInteractionTypeSwipe & interactionType;
}

BOOL CRToastInteractionResponderIsTap(interactionType) {
    return CRToastInteractionTypeTap & interactionType;
}

UIGestureRecognizer * CRToastSwipeGestureRecognizerMake(id target, SEL action, CRToastInteractionType interactionType, CRToastInteractionResponder *interactionResponder) {
    CRToastSwipeGestureRecognizer *swipeGestureRecognizer = [[CRToastSwipeGestureRecognizer alloc] initWithTarget:target action:action];
    if (interactionType == CRToastInteractionTypeSwipeUp) {
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    } else if (interactionType == CRToastInteractionTypeSwipeLeft) {
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    } else if (interactionType == CRToastInteractionTypeSwipeDown) {
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    } else if (interactionType == CRToastInteractionTypeSwipeRight) {
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
    swipeGestureRecognizer.automaticallyDismiss = interactionResponder.automaticallyDismiss;
    swipeGestureRecognizer.interactionType = interactionType;
    swipeGestureRecognizer.block = interactionResponder.block;
    return swipeGestureRecognizer;
}

UIGestureRecognizer * CRToastTapGestureRecognizerMake(id target, SEL action, CRToastInteractionType interactionType, CRToastInteractionResponder *interactionResponder) {
    CRToastTapGestureRecognizer *tapGestureRecognizer = [[CRToastTapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGestureRecognizer.numberOfTouchesRequired = (interactionType & (CRToastInteractionTypeTapOnce | CRToastInteractionTypeTapTwice)) ? 1 : 2;
    tapGestureRecognizer.numberOfTapsRequired = (interactionType & (CRToastInteractionTypeTapOnce | CRToastInteractionTypeTwoFingerTapOnce)) ? 1 : 2;
    tapGestureRecognizer.automaticallyDismiss = interactionResponder.automaticallyDismiss;
    tapGestureRecognizer.interactionType = interactionType;
    tapGestureRecognizer.block = interactionResponder.block;
    return tapGestureRecognizer;
}

UIGestureRecognizer * CRToastGestureRecognizerMake(id target, CRToastInteractionResponder *interactionResponder) {
    if (CRToastInteractionResponderIsSwipe(interactionResponder.interactionType)) {
        return CRToastSwipeGestureRecognizerMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder.interactionType, interactionResponder);
    } else if (CRToastInteractionResponderIsTap(interactionResponder.interactionType)) {
        return CRToastTapGestureRecognizerMake(target, @selector(tapGestureRecognizerTapped:), interactionResponder.interactionType, interactionResponder);
    }
    return nil;
}

NSArray * CRToastGenericSwipeRecognizersMake(id target, SEL action, CRToastInteractionResponder *interactionResponder) {
    NSMutableArray *gestureRecognizers = [@[] mutableCopy];
    [@[@(CRToastInteractionTypeSwipeUp),
       @(CRToastInteractionTypeSwipeLeft),
       @(CRToastInteractionTypeSwipeDown),
       @(CRToastInteractionTypeSwipeRight)] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           [gestureRecognizers addObject:CRToastSwipeGestureRecognizerMake(target, action, [obj integerValue], interactionResponder)];
       }];
    return gestureRecognizers;
}

NSArray * CRToastGenericTapRecognizersMake(id target, SEL action, CRToastInteractionResponder *interactionResponder) {
    NSMutableArray *gestureRecognizers = [@[] mutableCopy];
    [@[@(CRToastInteractionTypeTapOnce),
       @(CRToastInteractionTypeTapTwice),
       @(CRToastInteractionTypeTwoFingerTapOnce),
       @(CRToastInteractionTypeTwoFingerTapTwice)] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           [gestureRecognizers addObject:CRToastTapGestureRecognizerMake(target, action, [obj integerValue], interactionResponder)];
       }];
    return gestureRecognizers;
}

NSArray * CRToastGenericRecognizersMake(id target, CRToastInteractionResponder *interactionResponder) {
    if (interactionResponder.interactionType == CRToastInteractionTypeSwipe) {
        return CRToastGenericSwipeRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder);
    } else if (interactionResponder.interactionType == CRToastInteractionTypeTap) {
        return CRToastGenericTapRecognizersMake(target, @selector(tapGestureRecognizerTapped:), interactionResponder);
    } else if (interactionResponder.interactionType == CRToastInteractionTypeAll) {
        return [CRToastGenericTapRecognizersMake(target, @selector(tapGestureRecognizerTapped:), interactionResponder) arrayByAddingObjectsFromArray:CRToastGenericSwipeRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder)];
    }
    return nil;
}


@implementation CRToastInteractionResponder

+ (instancetype)interactionResponderWithInteractionType:(CRToastInteractionType)interactionType
                                   automaticallyDismiss:(BOOL)automaticallyDismiss
                                                  block:(CRToastInteractionResponderBlock)block {
    CRToastInteractionResponder *responder = [[self alloc] init];
    responder.interactionType = interactionType;
    responder.automaticallyDismiss = automaticallyDismiss;
    responder.block = block;
    return responder;
}
@end


// Manually define the foundation version number for iOS 7.1, used to check if
// device is running iOS 8 or later, in order to pass Travis CI. Can be removed
// once Travis CI is updated to support Xcode 6 and iOS 8 SDK.
#ifndef NSFoundationVersionNumber_iOS_7_1
	#define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif

#pragma mark - CRToast

#pragma mark - Option Constant Definitions

NSString *const kCRToastNotificationTypeKey                 = @"kCRToastNotificationTypeKey";
NSString *const kCRToastNotificationPreferredHeightKey      = @"kCRToastNotificationPreferredHeightKey";
NSString *const kCRToastNotificationPreferredPaddingKey     = @"kCRToastNotificationPreferredPaddingKey";
NSString *const kCRToastNotificationPresentationTypeKey     = @"kCRToastNotificationPresentationTypeKey";

NSString *const kCRToastUnderStatusBarKey                   = @"kCRToastUnderStatusBarKey";
NSString *const kCRToastKeepNavigationBarBorderKey          = @"kCRToastKeepNavigationBarBorderKey";

NSString *const kCRToastAnimationInTypeKey                  = @"kCRToastAnimationInTypeKey";
NSString *const kCRToastAnimationOutTypeKey                 = @"kCRToastAnimationOutTypeKey";
NSString *const kCRToastAnimationInDirectionKey             = @"kCRToastAnimationInDirectionKey";
NSString *const kCRToastAnimationOutDirectionKey            = @"kCRToastAnimationOutDirectionKey";

NSString *const kCRToastAnimationInTimeIntervalKey          = @"kCRToastAnimateInTimeInterval";
NSString *const kCRToastTimeIntervalKey                     = @"kCRToastTimeIntervalKey";
NSString *const kCRToastAnimationOutTimeIntervalKey         = @"kCRToastAnimateOutTimeInterval";

NSString *const kCRToastAnimationSpringDampingKey           = @"kCRToastAnimationSpringDampingKey";
NSString *const kCRToastAnimationSpringInitialVelocityKey   = @"kCRToastAnimateSpringVelocityKey";
NSString *const kCRToastAnimationGravityMagnitudeKey        = @"kCRToastAnimationGravityMagnitudeKey";

NSString *const kCRToastTextKey                             = @"kCRToastTextKey";
NSString *const kCRToastFontKey                             = @"kCRToastFontKey";
NSString *const kCRToastTextColorKey                        = @"kCRToastTextColorKey";
NSString *const kCRToastTextAlignmentKey                    = @"kCRToastTextAlignmentKey";
NSString *const kCRToastTextShadowColorKey                  = @"kCRToastTextShadowColorKey";
NSString *const kCRToastTextShadowOffsetKey                 = @"kCRToastTextShadowOffsetKey";
NSString *const kCRToastTextMaxNumberOfLinesKey             = @"kCRToastTextMaxNumberOfLinesKey";

NSString *const kCRToastSubtitleTextKey                     = @"kCRToastSubtitleTextKey";
NSString *const kCRToastSubtitleFontKey                     = @"kCRToastSubtitleFontKey";
NSString *const kCRToastSubtitleTextColorKey                = @"kCRToastSubtitleTextColorKey";
NSString *const kCRToastSubtitleTextAlignmentKey            = @"kCRToastSubtitleTextAlignmentKey";
NSString *const kCRToastSubtitleTextShadowColorKey          = @"kCRToastSubtitleTextShadowColorKey";
NSString *const kCRToastSubtitleTextShadowOffsetKey         = @"kCRToastSubtitleTextShadowOffsetKey";
NSString *const kCRToastSubtitleTextMaxNumberOfLinesKey     = @"kCRToastSubtitleTextMaxNumberOfLinesKey";
NSString *const kCRToastStatusBarStyleKey                   = @"kCRToastStatusBarStyleKey";

NSString *const kCRToastBackgroundColorKey                  = @"kCRToastBackgroundColorKey";
NSString *const kCRToastBackgroundViewKey                   = @"kCRToastBackgroundViewKey";
NSString *const kCRToastImageKey                            = @"kCRToastImageKey";
NSString *const kCRToastImageContentModeKey                 = @"kCRToastImageContentModeKey";
NSString *const kCRToastImageAlignmentKey                   = @"kCRToastImageAlignmentKey";
NSString *const kCRToastImageTintKey                        = @"kCRToastImageTintKey";
NSString *const kCRToastShowActivityIndicatorKey            = @"kCRToastShowActivityIndicatorKey";
NSString *const kCRToastActivityIndicatorViewStyleKey       = @"kCRToastActivityIndicatorViewStyleKey";
NSString *const kCRToastActivityIndicatorAlignmentKey       = @"kCRToastActivityIndicatorAlignmentKey";

NSString *const kCRToastInteractionRespondersKey            = @"kCRToastInteractionRespondersKey";
NSString *const kCRToastForceUserInteractionKey             = @"kCRToastForceUserInteractionKey";

NSString *const kCRToastAutorotateKey                       = @"kCRToastAutorotateKey";

NSString *const kCRToastIdentifierKey                       = @"kCRToastIdentifierKey";
NSString *const kCRToastCaptureDefaultWindowKey             = @"kCRToastCaptureDefaultWindowKey";

#pragma mark - Option Defaults

static CRToastType                   kCRNotificationTypeDefault             = CRToastTypeStatusBar;
static CGFloat                       kCRNotificationPreferredHeightDefault  = 0;
static CGFloat                       kCRNotificationPreferredPaddingDefault  = 0;
static CRToastPresentationType       kCRNotificationPresentationTypeDefault = CRToastPresentationTypePush;
static BOOL                          kCRDisplayUnderStatusBarDefault        = NO;
static BOOL                          kCRToastKeepNavigationBarBorderDefault = YES;
static NSString *                    kCRToastIdentifer                      = nil;

static CRToastAnimationType          kCRAnimationTypeDefaultIn              = CRToastAnimationTypeLinear;
static CRToastAnimationType          kCRAnimationTypeDefaultOut             = CRToastAnimationTypeLinear;
static CRToastAnimationDirection     kCRInAnimationDirectionDefault         = CRToastAnimationDirectionTop;
static CRToastAnimationDirection     kCROutAnimationDirectionDefault        = CRToastAnimationDirectionBottom;
static NSTimeInterval                kCRAnimateInTimeIntervalDefault        = 0.4;
static NSTimeInterval                kCRTimeIntervalDefault                 = 2.0f;
static NSTimeInterval                kCRAnimateOutTimeIntervalDefault       = 0.4;

static CGFloat                       kCRSpringDampingDefault                = 0.6;
static CGFloat                  	 kCRSpringInitialVelocityDefault        = 1.0;
static CGFloat                       kCRGravityMagnitudeDefault             = 1.0;

static NSString *                    kCRTextDefault                         = @"";
static UIFont   *                    kCRFontDefault                         = nil;
static UIColor  *               	 kCRTextColorDefault                    = nil;
static NSTextAlignment          	 kCRTextAlignmentDefault                = NSTextAlignmentCenter;
static UIColor  *               	 kCRTextShadowColorDefault              = nil;
static CGSize                   	 kCRTextShadowOffsetDefault;
static NSInteger                     kCRTextMaxNumberOfLinesDefault         = 0;

static NSString *                    kCRSubtitleTextDefault                 = nil;
static UIFont   *                    kCRSubtitleFontDefault                 = nil;
static UIColor  *               	 kCRSubtitleTextColorDefault            = nil;
static NSTextAlignment          	 kCRSubtitleTextAlignmentDefault        = NSTextAlignmentCenter;
static UIColor  *               	 kCRSubtitleTextShadowColorDefault      = nil;
static CGSize                   	 kCRSubtitleTextShadowOffsetDefault;
static NSInteger                     kCRSubtitleTextMaxNumberOfLinesDefault = 0;
static UIStatusBarStyle              kCRStatusBarStyleDefault               = UIStatusBarStyleDefault;

static UIColor  *                    kCRBackgroundColorDefault              = nil;
static UIView   *                    kCRBackgroundView                      = nil;
static UIImage  *                    kCRImageDefault                        = nil;
static UIViewContentMode             kCRImageContentModeDefault             = UIViewContentModeCenter;
static CRToastAccessoryViewAlignment kCRImageAlignmentDefault               = CRToastAccessoryViewAlignmentLeft;
static UIColor  *                    kCRImageTintDefault                    = nil;
static BOOL                          kCRShowActivityIndicatorDefault        = NO;
static UIActivityIndicatorViewStyle  kCRActivityIndicatorViewStyleDefault   = UIActivityIndicatorViewStyleWhite;
static CRToastAccessoryViewAlignment kCRActivityIndicatorAlignmentDefault   = CRToastAccessoryViewAlignmentLeft;

static NSArray  *                    kCRInteractionResponders               = nil;
static BOOL                          kCRForceUserInteractionDefault         = NO;

static BOOL                          kCRAutoRotateDefault                   = YES;

static BOOL                          kCRCaptureDefaultWindowDefault         = YES;

static NSDictionary *                kCRToastKeyClassMap                    = nil;

@interface CRToast ()
@property (nonatomic, readonly) BOOL snapshotWindow;
@property (strong, nonatomic) CRToastView *privateNotificationView;
@property (strong, nonatomic) UIView *privateStatusBarView;
@end

@implementation CRToast

+ (void)initialize {
    if (self == [CRToast class]) {
        kCRFontDefault = [UIFont systemFontOfSize:12];
        kCRTextColorDefault = [UIColor whiteColor];
        kCRTextShadowOffsetDefault = CGSizeZero;
        kCRSubtitleFontDefault = [UIFont systemFontOfSize:12];
        kCRSubtitleTextColorDefault = [UIColor whiteColor];
        kCRSubtitleTextShadowOffsetDefault = CGSizeZero;
        kCRBackgroundColorDefault = [[UIApplication sharedApplication] delegate].window.tintColor ?: [UIColor redColor];
        kCRInteractionResponders = @[];
        
        kCRToastKeyClassMap = @{kCRToastNotificationTypeKey                 : NSStringFromClass([@(kCRNotificationTypeDefault) class]),
                                kCRToastNotificationPreferredHeightKey      : NSStringFromClass([@(kCRNotificationPreferredHeightDefault) class]),
                                kCRToastNotificationPreferredPaddingKey      : NSStringFromClass([@(kCRNotificationPreferredPaddingDefault) class]),
                                kCRToastNotificationPresentationTypeKey     : NSStringFromClass([@(kCRNotificationPresentationTypeDefault) class]),
                                kCRToastUnderStatusBarKey                   : NSStringFromClass([@(kCRDisplayUnderStatusBarDefault) class]),
                                kCRToastKeepNavigationBarBorderKey          : NSStringFromClass([@(kCRToastKeepNavigationBarBorderDefault) class]),
                                
                                kCRToastIdentifierKey                       : NSStringFromClass([NSString class]),
                                
                                kCRToastAnimationInTypeKey                  : NSStringFromClass([@(kCRAnimationTypeDefaultIn) class]),
                                kCRToastAnimationOutTypeKey                 : NSStringFromClass([@(kCRAnimationTypeDefaultOut) class]),
                                kCRToastAnimationInDirectionKey             : NSStringFromClass([@(kCRInAnimationDirectionDefault) class]),
                                kCRToastAnimationOutDirectionKey            : NSStringFromClass([@(kCROutAnimationDirectionDefault) class]),
                                kCRToastAnimationInTimeIntervalKey          : NSStringFromClass([@(kCRAnimateInTimeIntervalDefault) class]),
                                kCRToastTimeIntervalKey                     : NSStringFromClass([@(kCRTimeIntervalDefault) class]),
                                kCRToastAnimationOutTimeIntervalKey         : NSStringFromClass([@(kCRAnimateOutTimeIntervalDefault) class]),
                                
                                kCRToastAnimationSpringDampingKey           : NSStringFromClass([@(kCRSpringDampingDefault) class]),
                                kCRToastAnimationSpringInitialVelocityKey   : NSStringFromClass([@(kCRSpringInitialVelocityDefault) class]),
                                kCRToastAnimationGravityMagnitudeKey        : NSStringFromClass([@(kCRGravityMagnitudeDefault) class]),
                                
                                kCRToastTextKey                             : NSStringFromClass([NSString class]),
                                kCRToastFontKey                             : NSStringFromClass([UIFont class]),
                                kCRToastTextColorKey                        : NSStringFromClass([UIColor class]),
                                kCRToastTextAlignmentKey                    : NSStringFromClass([@(kCRTextAlignmentDefault) class]),
                                kCRToastTextShadowColorKey                  : NSStringFromClass([UIColor class]),
                                kCRToastTextShadowOffsetKey                 : NSStringFromClass([[NSValue valueWithCGSize:kCRTextShadowOffsetDefault] class]),
                                kCRToastTextMaxNumberOfLinesKey             : NSStringFromClass([@(kCRTextMaxNumberOfLinesDefault) class]),
                                kCRToastSubtitleTextKey                     : NSStringFromClass([NSString class]),
                                kCRToastSubtitleFontKey                     : NSStringFromClass([UIFont class]),
                                kCRToastSubtitleTextColorKey                : NSStringFromClass([UIColor class]),
                                kCRToastSubtitleTextAlignmentKey            : NSStringFromClass([@(kCRSubtitleTextAlignmentDefault) class]),
                                kCRToastSubtitleTextShadowColorKey          : NSStringFromClass([UIColor class]),
                                kCRToastSubtitleTextShadowOffsetKey         : NSStringFromClass([[NSValue valueWithCGSize:kCRSubtitleTextShadowOffsetDefault] class]),
                                kCRToastSubtitleTextMaxNumberOfLinesKey     : NSStringFromClass([@(kCRSubtitleTextMaxNumberOfLinesDefault) class]),
                                kCRToastStatusBarStyleKey                   : NSStringFromClass([@(kCRStatusBarStyleDefault) class]),
                                
                                kCRToastBackgroundColorKey                  : NSStringFromClass([UIColor class]),
                                kCRToastBackgroundViewKey                   : NSStringFromClass([UIView class]),
                                kCRToastImageKey                            : NSStringFromClass([UIImage class]),
                                kCRToastImageContentModeKey                 : NSStringFromClass([@(kCRImageContentModeDefault) class]),
                                kCRToastImageAlignmentKey                   : NSStringFromClass([@(kCRImageAlignmentDefault) class]),
                                kCRToastImageTintKey                        : NSStringFromClass([UIColor class]),
                                kCRToastShowActivityIndicatorKey            : NSStringFromClass([@(kCRShowActivityIndicatorDefault) class]),
                                kCRToastActivityIndicatorViewStyleKey       : NSStringFromClass([@(kCRActivityIndicatorViewStyleDefault) class]),
                                kCRToastActivityIndicatorAlignmentKey       : NSStringFromClass([@(kCRActivityIndicatorAlignmentDefault) class]),
                                
                                kCRToastInteractionRespondersKey            : NSStringFromClass([NSArray class]),
                                kCRToastForceUserInteractionKey             : NSStringFromClass([@(kCRForceUserInteractionDefault) class]),
                                
                                kCRToastAutorotateKey                       : NSStringFromClass([@(kCRAutoRotateDefault) class]),
                                
                                kCRToastAutorotateKey                       : NSStringFromClass([@(kCRAutoRotateDefault) class]),
                                
                                kCRToastCaptureDefaultWindowKey             : NSStringFromClass([@(kCRCaptureDefaultWindowDefault) class])
                                };
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary*)options appearanceBlock:(void (^)(void))appearance completionBlock:(void (^)(void))completion {
    CRToast *notification = [[self alloc] init];
    notification.options = options;
    notification.completion = completion;
    notification.state = CRToastStateWaiting;
    notification.uuid = [NSUUID UUID];
    notification.appearance = appearance;
	
    return notification;
}

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    //TODO Validate Types of Default Options
    if (defaultOptions[kCRToastNotificationTypeKey])                kCRNotificationTypeDefault              = [defaultOptions[kCRToastNotificationTypeKey] integerValue];
    if (defaultOptions[kCRToastNotificationPreferredHeightKey])     kCRNotificationPreferredHeightDefault   = [defaultOptions[kCRToastNotificationPreferredHeightKey] floatValue];
    if (defaultOptions[kCRToastNotificationPreferredPaddingKey])    kCRNotificationPreferredPaddingDefault  = [defaultOptions[kCRToastNotificationPreferredPaddingKey] floatValue];
    if (defaultOptions[kCRToastNotificationPresentationTypeKey])    kCRNotificationPresentationTypeDefault  = [defaultOptions[kCRToastNotificationPresentationTypeKey] integerValue];
    if (defaultOptions[kCRToastIdentifierKey])                      kCRToastIdentifer                       = defaultOptions[kCRToastIdentifierKey];
    
    if (defaultOptions[kCRToastUnderStatusBarKey])                  kCRDisplayUnderStatusBarDefault         = [defaultOptions[kCRToastUnderStatusBarKey] boolValue];
    
    if (defaultOptions[kCRToastAnimationInTypeKey])                 kCRAnimationTypeDefaultIn               = [defaultOptions[kCRToastAnimationInTypeKey] integerValue];
    if (defaultOptions[kCRToastAnimationOutTypeKey])                kCRAnimationTypeDefaultOut              = [defaultOptions[kCRToastAnimationOutTypeKey] integerValue];
    if (defaultOptions[kCRToastAnimationInDirectionKey])            kCRInAnimationDirectionDefault          = [defaultOptions[kCRToastAnimationInDirectionKey] integerValue];
    if (defaultOptions[kCRToastAnimationOutDirectionKey])           kCROutAnimationDirectionDefault         = [defaultOptions[kCRToastAnimationOutDirectionKey] integerValue];
    
    if (defaultOptions[kCRToastAnimationInTimeIntervalKey])         kCRAnimateInTimeIntervalDefault         = [defaultOptions[kCRToastAnimationInTimeIntervalKey] doubleValue];
    if (defaultOptions[kCRToastTimeIntervalKey])                    kCRTimeIntervalDefault                  = [defaultOptions[kCRToastTimeIntervalKey] doubleValue];
    if (defaultOptions[kCRToastAnimationOutTimeIntervalKey])        kCRAnimateOutTimeIntervalDefault        = [defaultOptions[kCRToastAnimationOutTimeIntervalKey] doubleValue];
    
    if (defaultOptions[kCRToastAnimationSpringDampingKey])          kCRSpringDampingDefault                 = [defaultOptions[kCRToastAnimationSpringDampingKey] floatValue];
    if (defaultOptions[kCRToastAnimationSpringInitialVelocityKey])  kCRSpringInitialVelocityDefault         = [defaultOptions[kCRToastAnimationSpringInitialVelocityKey] floatValue];
    if (defaultOptions[kCRToastAnimationGravityMagnitudeKey])       kCRGravityMagnitudeDefault              = [defaultOptions[kCRToastAnimationGravityMagnitudeKey] floatValue];
    
    if (defaultOptions[kCRToastTextKey])                            kCRTextDefault                          = defaultOptions[kCRToastTextKey];
    if (defaultOptions[kCRToastFontKey])                            kCRFontDefault                          = defaultOptions[kCRToastFontKey];
    if (defaultOptions[kCRToastTextColorKey])                       kCRTextColorDefault                     = defaultOptions[kCRToastTextColorKey];
    if (defaultOptions[kCRToastTextAlignmentKey])                   kCRTextAlignmentDefault                 = [defaultOptions[kCRToastTextAlignmentKey] integerValue];
    if (defaultOptions[kCRToastTextShadowColorKey])                 kCRTextShadowColorDefault               = defaultOptions[kCRToastTextShadowColorKey];
    if (defaultOptions[kCRToastTextShadowOffsetKey])                kCRTextShadowOffsetDefault              = [defaultOptions[kCRToastTextShadowOffsetKey] CGSizeValue];
    if (defaultOptions[kCRToastTextMaxNumberOfLinesKey])            kCRTextMaxNumberOfLinesDefault          = [defaultOptions[kCRToastTextMaxNumberOfLinesKey] integerValue];
    
    if (defaultOptions[kCRToastStatusBarStyleKey])                  kCRStatusBarStyleDefault                = [defaultOptions[kCRToastStatusBarStyleKey] integerValue];
    
    if (defaultOptions[kCRToastSubtitleTextKey])                    kCRSubtitleTextDefault                  = defaultOptions[kCRToastSubtitleTextKey];
    if (defaultOptions[kCRToastSubtitleFontKey])                    kCRSubtitleFontDefault                  = defaultOptions[kCRToastSubtitleFontKey];
    if (defaultOptions[kCRToastSubtitleTextColorKey])               kCRSubtitleTextColorDefault             = defaultOptions[kCRToastSubtitleTextColorKey];
    if (defaultOptions[kCRToastSubtitleTextAlignmentKey])           kCRSubtitleTextAlignmentDefault         = [defaultOptions[kCRToastSubtitleTextAlignmentKey] integerValue];
    if (defaultOptions[kCRToastSubtitleTextShadowColorKey])         kCRSubtitleTextShadowColorDefault       = defaultOptions[kCRToastSubtitleTextShadowColorKey];
    if (defaultOptions[kCRToastSubtitleTextShadowOffsetKey])        kCRSubtitleTextShadowOffsetDefault      = [defaultOptions[kCRToastSubtitleTextShadowOffsetKey] CGSizeValue];
    if (defaultOptions[kCRToastSubtitleTextMaxNumberOfLinesKey])    kCRSubtitleTextMaxNumberOfLinesDefault  = [defaultOptions[kCRToastSubtitleTextMaxNumberOfLinesKey] integerValue];
    
    if (defaultOptions[kCRToastBackgroundColorKey])                 kCRBackgroundColorDefault               = defaultOptions[kCRToastBackgroundColorKey];
    if (defaultOptions[kCRToastBackgroundViewKey])                  kCRBackgroundView                       = defaultOptions[kCRToastBackgroundViewKey];
    if (defaultOptions[kCRToastImageKey])                           kCRImageDefault                         = defaultOptions[kCRToastImageKey];
    if (defaultOptions[kCRToastImageContentModeKey])                kCRImageContentModeDefault              = [defaultOptions[kCRToastImageContentModeKey] integerValue];
    if (defaultOptions[kCRToastImageAlignmentKey])                  kCRImageAlignmentDefault                = [defaultOptions[kCRToastImageAlignmentKey] integerValue];
    if (defaultOptions[kCRToastImageTintKey])                       kCRImageTintDefault                     = defaultOptions[kCRToastImageTintKey];
    if (defaultOptions[kCRToastShowActivityIndicatorKey])           kCRShowActivityIndicatorDefault         = [defaultOptions[kCRToastShowActivityIndicatorKey] boolValue];
    if (defaultOptions[kCRToastActivityIndicatorViewStyleKey])      kCRActivityIndicatorViewStyleDefault    = [defaultOptions[kCRToastActivityIndicatorViewStyleKey] integerValue];
    if (defaultOptions[kCRToastActivityIndicatorAlignmentKey])      kCRActivityIndicatorAlignmentDefault    = [defaultOptions[kCRToastActivityIndicatorAlignmentKey] integerValue];
    
    if (defaultOptions[kCRToastInteractionRespondersKey])           kCRInteractionResponders                = defaultOptions[kCRToastInteractionRespondersKey];
    if (defaultOptions[kCRToastForceUserInteractionKey])            kCRForceUserInteractionDefault          = [defaultOptions[kCRToastForceUserInteractionKey] boolValue];
        
    if (defaultOptions[kCRToastAutorotateKey])                      kCRAutoRotateDefault                    = [defaultOptions[kCRToastAutorotateKey] boolValue];

    if (defaultOptions[kCRToastCaptureDefaultWindowKey])            kCRCaptureDefaultWindowDefault          = [defaultOptions[kCRToastCaptureDefaultWindowKey] boolValue];
}

#pragma mark - Notification View Helpers

- (UIView *)notificationView {
    return self.privateNotificationView;
}

- (UIView *)privateNotificationView {
    if (!_privateNotificationView) {
        CGSize size = CRNotificationViewSize(self.notificationType, self.preferredHeight);
        _privateNotificationView = [[CRToastView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _privateNotificationView.toast = self;
    }
    return _privateNotificationView;
}

- (CGRect)notificationViewAnimationFrame1 {
    return CRNotificationViewFrame(self.notificationType, self.inAnimationDirection, self.preferredHeight);
}

- (CGRect)notificationViewAnimationFrame2 {
    return CRNotificationViewFrame(self.notificationType, self.outAnimationDirection, self.preferredHeight);
}

- (UIView *)statusBarView {
    return self.privateStatusBarView;
}

- (UIView *)privateStatusBarView {
    if (!_privateStatusBarView) {
        _privateStatusBarView = [[UIView alloc] initWithFrame:self.statusBarViewAnimationFrame1];
        if (self.snapshotWindow) {
            [_privateStatusBarView addSubview:CRStatusBarSnapShotView(self.displayUnderStatusBar)];
        }
        _privateStatusBarView.clipsToBounds = YES;
    }
    return _privateStatusBarView;
}

- (CGRect)statusBarViewAnimationFrame1 {
    return CRStatusBarViewFrame(self.notificationType, self.inAnimationDirection, self.preferredHeight);
}

- (CGRect)statusBarViewAnimationFrame2 {
    return CRStatusBarViewFrame(self.notificationType, self.outAnimationDirection, self.preferredHeight);
}

#pragma mark - Gesture Recognizer Actions

- (void)swipeGestureRecognizerSwiped:(CRToastSwipeGestureRecognizer*)swipeGestureRecognizer {
    if (swipeGestureRecognizer.automaticallyDismiss) {
        [CRToastManager dismissNotification:YES];
    }
    
    if (swipeGestureRecognizer.block) {
        swipeGestureRecognizer.block(swipeGestureRecognizer.interactionType);
    }
}

- (void)tapGestureRecognizerTapped:(CRToastTapGestureRecognizer*)tapGestureRecognizer {
    if (tapGestureRecognizer.automaticallyDismiss) {
        [CRToastManager dismissNotification:YES];
    }
    
    if (tapGestureRecognizer.block) {
        tapGestureRecognizer.block(tapGestureRecognizer.interactionType);
    }
}

#pragma mark - Overrides

- (NSArray *)gestureRecognizersForInteractionResponder:(NSArray*)interactionResponders {
    NSMutableArray *gestureRecognizers = [@[] mutableCopy];
    for (CRToastInteractionResponder *interactionResponder in [kCRInteractionResponders arrayByAddingObjectsFromArray:interactionResponders]) {
        if (CRToastInteractionResponderIsGenertic(interactionResponder.interactionType)) {
            [gestureRecognizers addObjectsFromArray:CRToastGenericRecognizersMake(self, interactionResponder)];
        } else {
            UIGestureRecognizer *gestureRecognizer = CRToastGestureRecognizerMake(self, interactionResponder);
            gestureRecognizer.delegate = self;
            [gestureRecognizers addObject:gestureRecognizer];
        }
    }
    return [NSArray arrayWithArray:gestureRecognizers];
}

- (NSArray *)gestureRecognizers {
    return _options[kCRToastInteractionRespondersKey] ?
    _gestureRecognizers ?: [self gestureRecognizersForInteractionResponder:_options[kCRToastInteractionRespondersKey]] :
    [self gestureRecognizersForInteractionResponder:kCRInteractionResponders];
}

- (CRToastType)notificationType {
    return _options[kCRToastNotificationTypeKey] ?
    [self.options[kCRToastNotificationTypeKey] integerValue] :
    kCRNotificationTypeDefault;
}

- (CGFloat)preferredHeight {
    return _options[kCRToastNotificationPreferredHeightKey] ?
    [_options[kCRToastNotificationPreferredHeightKey] floatValue] :
    kCRNotificationPreferredHeightDefault;
}

- (CGFloat)preferredPadding {
    return _options[kCRToastNotificationPreferredPaddingKey] ?
    [_options[kCRToastNotificationPreferredPaddingKey] floatValue] :
    kCRNotificationPreferredPaddingDefault;
}

- (CRToastPresentationType)presentationType {
    return _options[kCRToastNotificationPresentationTypeKey] ?
    [self.options[kCRToastNotificationPresentationTypeKey] integerValue] :
    kCRNotificationPresentationTypeDefault;
}

- (BOOL)displayUnderStatusBar {
    return _options[kCRToastUnderStatusBarKey] ?
    [self.options[kCRToastUnderStatusBarKey] boolValue] :
    kCRDisplayUnderStatusBarDefault;
}

- (BOOL)shouldKeepNavigationBarBorder {
    return _options[kCRToastKeepNavigationBarBorderKey] ?
    [_options[kCRToastKeepNavigationBarBorderKey] boolValue] :
    kCRToastKeepNavigationBarBorderDefault;
}

- (CRToastAnimationType)inAnimationType {
    return _options[kCRToastAnimationInTypeKey] ?
    [_options[kCRToastAnimationInTypeKey] integerValue] :
    kCRAnimationTypeDefaultIn;
}

- (CRToastAnimationType)outAnimationType {
    return _options[kCRToastAnimationOutTypeKey] ?
    [_options[kCRToastAnimationOutTypeKey] integerValue] :
    kCRAnimationTypeDefaultOut;
}

- (CRToastAnimationDirection)inAnimationDirection {
    return _options[kCRToastAnimationInDirectionKey] ?
    [_options[kCRToastAnimationInDirectionKey] integerValue] :
    kCRInAnimationDirectionDefault;
}

- (CRToastAnimationDirection)outAnimationDirection {
    return _options[kCRToastAnimationInDirectionKey] ?
    [_options[kCRToastAnimationOutDirectionKey] integerValue] :
    kCROutAnimationDirectionDefault;
}

- (NSTimeInterval)animateInTimeInterval {
    return _options[kCRToastAnimationInTimeIntervalKey] ?
    [_options[kCRToastAnimationInTimeIntervalKey] doubleValue] :
    kCRAnimateInTimeIntervalDefault;
}

- (NSTimeInterval)timeInterval {
    return _options[kCRToastTimeIntervalKey] ?
    [_options[kCRToastTimeIntervalKey] doubleValue] :
    kCRTimeIntervalDefault;
}

- (NSTimeInterval)animateOutTimeInterval {
    return _options[kCRToastAnimationOutTimeIntervalKey] ?
    [_options[kCRToastAnimationOutTimeIntervalKey] doubleValue] :
    kCRAnimateOutTimeIntervalDefault;
}

- (CGFloat)animationSpringInitialVelocity {
    return _options[kCRToastAnimationSpringInitialVelocityKey] ?
    [_options[kCRToastAnimationSpringInitialVelocityKey] floatValue] :
    kCRSpringInitialVelocityDefault;
}

- (CGFloat)animationSpringDamping {
    return _options[kCRToastAnimationSpringDampingKey] ?
    [_options[kCRToastAnimationSpringDampingKey] floatValue] :
    kCRSpringDampingDefault;
}

- (CGFloat)animationGravityMagnitude {
    return _options[kCRToastAnimationGravityMagnitudeKey] ?
    [_options[kCRToastAnimationGravityMagnitudeKey] floatValue] :
    kCRGravityMagnitudeDefault;
}

- (NSString*)text {
    return _options[kCRToastTextKey] ?: kCRTextDefault;
}

- (UIFont*)font {
    return _options[kCRToastFontKey] ?: kCRFontDefault;
}

- (UIColor*)textColor {
    return _options[kCRToastTextColorKey] ?: kCRTextColorDefault;
}

- (NSTextAlignment)textAlignment {
    return _options[kCRToastTextAlignmentKey] ? [_options[kCRToastTextAlignmentKey] integerValue] : kCRTextAlignmentDefault;
}

- (UIColor*)textShadowColor {
    return _options[kCRToastTextShadowColorKey] ?: kCRTextShadowColorDefault;
}

- (CGSize)textShadowOffset {
    return _options[kCRToastTextShadowOffsetKey] ?
    [_options[kCRToastTextShadowOffsetKey] CGSizeValue]:
    kCRTextShadowOffsetDefault;
}

- (NSString*)subtitleText {
    return _options[kCRToastSubtitleTextKey] ?: kCRSubtitleTextDefault;
}

- (UIFont*)subtitleFont {
    return _options[kCRToastSubtitleFontKey] ?: kCRSubtitleFontDefault;
}

- (UIColor*)subtitleTextColor {
    return _options[kCRToastSubtitleTextColorKey] ?: kCRSubtitleTextColorDefault;
}

- (NSTextAlignment)subtitleTextAlignment {
    return _options[kCRToastSubtitleTextAlignmentKey] ? [_options[kCRToastSubtitleTextAlignmentKey] integerValue] : kCRSubtitleTextAlignmentDefault;
}

- (UIColor*)subtitleTextShadowColor {
    return _options[kCRToastSubtitleTextShadowColorKey] ?: kCRSubtitleTextShadowColorDefault;
}

- (CGSize)subtitleTextShadowOffset {
    return _options[kCRToastSubtitleTextShadowOffsetKey] ?
    [_options[kCRToastSubtitleTextShadowOffsetKey] CGSizeValue]:
    kCRSubtitleTextShadowOffsetDefault;
}

- (UIColor*)backgroundColor {
    return _options[kCRToastBackgroundColorKey] ?: kCRBackgroundColorDefault;
}

- (UIView *)backgroundView {
    return _options[kCRToastBackgroundViewKey];
}

- (UIImage *)image {
    return _options[kCRToastImageKey] ?: kCRImageDefault;
}

- (UIViewContentMode)imageContentMode {
    return _options[kCRToastImageContentModeKey] ? [_options[kCRToastImageContentModeKey] integerValue] : kCRImageContentModeDefault;
}

- (CRToastAccessoryViewAlignment)imageAlignment {
    return _options[kCRToastImageAlignmentKey] ? [_options[kCRToastImageAlignmentKey] integerValue] : kCRImageAlignmentDefault;
}

- (UIColor *)imageTint {
    return _options[kCRToastImageTintKey] ?: kCRImageTintDefault;
}

- (BOOL)showActivityIndicator {
    return _options[kCRToastShowActivityIndicatorKey] ? [_options[kCRToastShowActivityIndicatorKey] boolValue] : kCRShowActivityIndicatorDefault;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return _options[kCRToastActivityIndicatorViewStyleKey] ? [_options[kCRToastActivityIndicatorViewStyleKey] integerValue] : kCRActivityIndicatorViewStyleDefault;
}

- (CRToastAccessoryViewAlignment)activityViewAlignment {
    return _options[kCRToastActivityIndicatorAlignmentKey] ? [_options[kCRToastActivityIndicatorAlignmentKey] integerValue] : kCRActivityIndicatorAlignmentDefault;
}

- (NSInteger)textMaxNumberOfLines {
    return _options[kCRToastTextMaxNumberOfLinesKey] ?
    [_options[kCRToastTextMaxNumberOfLinesKey] integerValue] :
    kCRTextMaxNumberOfLinesDefault;
}

- (NSInteger)subtitleTextMaxNumberOfLines {
    return _options[kCRToastSubtitleTextMaxNumberOfLinesKey] ?
    [_options[kCRToastSubtitleTextMaxNumberOfLinesKey] integerValue] :
    kCRSubtitleTextMaxNumberOfLinesDefault;
}

- (UIStatusBarStyle)statusBarStyle {
    return _options[kCRToastStatusBarStyleKey] ? [_options[kCRToastStatusBarStyleKey] integerValue] : kCRStatusBarStyleDefault;
}

- (BOOL)forceUserInteraction {
    return _options[kCRToastForceUserInteractionKey] ? [_options[kCRToastForceUserInteractionKey] boolValue] : kCRForceUserInteractionDefault;
}

- (BOOL)autorotate {
    return (_options[kCRToastAutorotateKey] ? [_options[kCRToastAutorotateKey] boolValue] : kCRAutoRotateDefault);
}

- (BOOL)snapshotWindow {
    return (_options[kCRToastCaptureDefaultWindowKey] ? [_options[kCRToastCaptureDefaultWindowKey] boolValue] : kCRCaptureDefaultWindowDefault);
}

BOOL CRToastAnimationDirectionIsVertical(CRToastAnimationDirection animationDirection) {
    return (animationDirection == CRToastAnimationDirectionTop || animationDirection == CRToastAnimationDirectionBottom);
}

BOOL CRToastAnimationDirectionIsHorizontal(CRToastAnimationDirection animationDirection) {
    return !CRToastAnimationDirectionIsVertical(animationDirection);
}

static CGFloat kCRCollisionTweak = 0.5;

- (CGVector)inGravityDirection {
    CGFloat xVector = CRToastAnimationDirectionIsVertical(self.inAnimationDirection) ? 0.0 :
    1.0 * (self.inAnimationDirection == CRToastAnimationDirectionLeft ?: -1.0);
    CGFloat yVector = xVector != 0 ? 0.0 :
    1.0 * (self.inAnimationDirection == CRToastAnimationDirectionTop ?: -1.0);
    return CGVectorMake(xVector, yVector);
}

- (CGVector)outGravityDirection {
    CGFloat xVector = CRToastAnimationDirectionIsVertical(self.outAnimationDirection) ? 0.0 :
    1.0 * (self.outAnimationDirection != CRToastAnimationDirectionLeft ?: -1.0);
    CGFloat yVector = xVector != 0 ? 0.0 :
    1.0 * (self.outAnimationDirection != CRToastAnimationDirectionTop ?: -1.0);
    return CGVectorMake(xVector, yVector);
}

- (CGPoint)inCollisionPoint1 {
    CGFloat x;
    CGFloat y;
    CGFloat factor = self.presentationType == CRToastPresentationTypeCover ?: 2;
    BOOL push = self.presentationType == CRToastPresentationTypePush;
    switch (self.inAnimationDirection) {
        case CRToastAnimationDirectionTop:
            x = 0;
            y = factor*(CGRectGetHeight(self.notificationViewAnimationFrame1)+(push ? -4*kCRCollisionTweak : kCRCollisionTweak));
            break;
        case CRToastAnimationDirectionLeft:
            x = (factor*CGRectGetWidth(self.notificationViewAnimationFrame1))+(push ? -5*kCRCollisionTweak : 2*kCRCollisionTweak);
            y = CGRectGetHeight(self.notificationViewAnimationFrame1);
            break;
        case CRToastAnimationDirectionBottom:
            x = CGRectGetWidth(self.notificationViewAnimationFrame1);
            y = -((factor-1)*CGRectGetHeight(self.notificationViewAnimationFrame1))-(push ? -5*kCRCollisionTweak : kCRCollisionTweak);;
            break;
        case CRToastAnimationDirectionRight:
            x = -((factor-1)*CGRectGetWidth(self.notificationViewAnimationFrame1))-(push ? -5*kCRCollisionTweak : 2*kCRCollisionTweak);;
            y = 0;
            break;
    }
    return CGPointMake(x, y);
}

- (CGPoint)inCollisionPoint2 {
    CGFloat x;
    CGFloat y;
    CGFloat factor = self.presentationType == CRToastPresentationTypeCover ?: 2;
    BOOL push = self.presentationType == CRToastPresentationTypePush;
    switch (self.inAnimationDirection) {
        case CRToastAnimationDirectionTop:
            x = CGRectGetWidth(self.notificationViewAnimationFrame1);
            y = factor*(CGRectGetHeight(self.notificationViewAnimationFrame1)+(push ? -4*kCRCollisionTweak : kCRCollisionTweak));
            break;
        case CRToastAnimationDirectionLeft:
            x = (factor*CGRectGetWidth(self.notificationViewAnimationFrame1))+(push ? -5*kCRCollisionTweak : 2*kCRCollisionTweak);
            y = 0;
            break;
        case CRToastAnimationDirectionBottom:
            x = 0;
            y = -((factor-1)*CGRectGetHeight(self.notificationViewAnimationFrame1))-(push ? -5*kCRCollisionTweak : kCRCollisionTweak);
            break;
        case CRToastAnimationDirectionRight:
            x = -((factor-1)*CGRectGetWidth(self.notificationViewAnimationFrame1))-(push ? -5*kCRCollisionTweak : 2*kCRCollisionTweak);
            y = CGRectGetHeight(self.notificationViewAnimationFrame1);
            break;
    }
    return CGPointMake(x, y);
}

- (CGPoint)outCollisionPoint1 {
    CGFloat x;
    CGFloat y;
    switch (self.outAnimationDirection) {
        case CRToastAnimationDirectionTop:
            x = CGRectGetWidth(self.notificationViewAnimationFrame1);
            y = -CGRectGetHeight(self.notificationViewAnimationFrame1)-kCRCollisionTweak;
            break;
        case CRToastAnimationDirectionLeft:
            x = -CGRectGetWidth(self.notificationViewAnimationFrame1)-kCRCollisionTweak;
            y = 0;
            break;
        case CRToastAnimationDirectionBottom:
            x = 0;
            y = 2*CGRectGetHeight(self.notificationViewAnimationFrame1)+kCRCollisionTweak;
            break;
        case CRToastAnimationDirectionRight:
            x = 2*CGRectGetWidth(self.notificationViewAnimationFrame1)+2*kCRCollisionTweak;
            y = CGRectGetHeight(self.notificationViewAnimationFrame1);
            break;
    }
    return CGPointMake(x, y);
}

- (CGPoint)outCollisionPoint2 {
    CGFloat x;
    CGFloat y;
    switch (self.outAnimationDirection) {
        case CRToastAnimationDirectionTop:
            x = 0;
            y = -CGRectGetHeight(self.notificationViewAnimationFrame1)-kCRCollisionTweak;
            break;
        case CRToastAnimationDirectionLeft:
            x = -CGRectGetWidth(self.notificationViewAnimationFrame1)-kCRCollisionTweak;
            y = CGRectGetHeight(self.notificationViewAnimationFrame1);
            break;
        case CRToastAnimationDirectionBottom:
            x = CGRectGetWidth(self.notificationViewAnimationFrame1);
            y = 2*CGRectGetHeight(self.notificationViewAnimationFrame1)+kCRCollisionTweak;
            break;
        case CRToastAnimationDirectionRight:
            x = 2*CGRectGetWidth(self.notificationViewAnimationFrame1)+2*kCRCollisionTweak;
            y = 0;
            break;
    }
    return CGPointMake(x, y);
}

- (void)warnAboutSensibility {
    if (self.notificationType == CRToastTypeStatusBar) {
        if (self.displayUnderStatusBar) {
            NSLog(@"[CRToast] : WARNING - It is not sensible to have set kCRToastNotificationTypeKey to @(CRToastTypeStatusBar) while setting kCRToastUnderStatusBarKey to @(YES). I'll do what you ask, but it'll probably work weird");
        }
        
        if (self.subtitleText) {
            NSLog(@"[CRToast] : WARNING - It is not sensible to have set kCRToastNotificationTypeKey to @(CRToastTypeStatusBar) and configuring subtitle text to show. I'll do what you ask, but it'll probably work weird");
        }
    }
    
    if (self.inAnimationType == CRToastAnimationTypeGravity) {
        if (self.animateInTimeInterval != kCRAnimateInTimeIntervalDefault) {
            NSLog(@"[CRToast] : WARNING - It is not sensible to have set kCRToastAnimationInTypeKey to @(CRToastAnimationTypeGravity) and configure a kCRToastAnimationInTimeIntervalKey. Gravity and distance will be driving the in animation duration here. kCRToastAnimationGravityMagnitudeKey can be modified to change the in animation duration.");
        }
    }
    
    if (self.outAnimationType == CRToastAnimationTypeGravity) {
        if (self.animateOutTimeInterval != kCRAnimateOutTimeIntervalDefault) {
            NSLog(@"[CRToast] : WARNING - It is not sensible to have set kCRToastAnimationOutTypeKey to @(CRToastAnimationTypeGravity) and configure a kCRToastAnimationOutTimeIntervalKey. Gravity and distance will be driving the in animation duration here. kCRToastAnimationGravityMagnitudeKey can be modified to change the in animation duration.");
        }
    }
    
    if (self.forceUserInteraction) {
        if (self.gestureRecognizers.count == 0) {
            NSLog(@"[CRToast] : WARNING - It is not sensible to have set kCRToastForceUserInteractionKey to @(YES) and not set any interaction responders. This notification can only be dismissed programmatically.");
        }
    }
}

- (void)setOptions:(NSDictionary *)options {
    NSMutableDictionary *cleanOptions = [options mutableCopy];
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //Check keys validity followed by checking objects type validity
        if ([kCRToastKeyClassMap.allKeys indexOfObject:key] == NSNotFound) {
            NSLog(@"[CRToast] : ERROR given unrecognized key %@ in options with object %@",
                  key,
                  obj);
            [cleanOptions removeObjectForKey:key];
        } else if (![obj isKindOfClass:NSClassFromString(kCRToastKeyClassMap[key])]) {
            NSLog(@"[CRToast] : ERROR given %@ for key %@ was expecting Class %@ but got Class %@, passing default on instead",
                  obj,
                  key,
                  kCRToastKeyClassMap[key],
                  NSStringFromClass([obj class]));
            [cleanOptions removeObjectForKey:key];
        }
    }];
    _options = [NSDictionary dictionaryWithDictionary:cleanOptions];
    [self warnAboutSensibility];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)initiateAnimator:(UIView*)view {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
}

@end
