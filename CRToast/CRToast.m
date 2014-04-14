//
//  CRToast.m
//  CRNotificationDemo
//
//

#import <QuartzCore/QuartzCore.h>
#import "CRToast.h"

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

typedef NS_ENUM(NSInteger, CRToastState) {
    CRToastStateWaiting,
    CRToastStateEntering,
    CRToastStateDisplaying,
    CRToastStateExiting,
    CRToastStateCompleted
};

#pragma mark - CRToast

@interface CRToast : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, assign) CRToastState state;

//Top Level Properties

@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, copy) void(^completion)(void);

//Interactions

@property (nonatomic, strong) NSArray *gestureRecognizers;

//Views and Layout Data

@property (nonatomic, readonly) UIView *notificationView;
@property (nonatomic, readonly) CGRect notificationViewAnimationFrame1;
@property (nonatomic, readonly) CGRect notificationViewAnimationFrame2;
@property (nonatomic, retain) UIDynamicAnimator *animator;

//Read Only Convinence Properties Providing Default Values or Values from Options

@property (nonatomic, readonly) CRToastType notificationType;
@property (nonatomic, readonly) CRToastPresentationType presentationType;
@property (nonatomic, readonly) BOOL displayUnderStatusBar;

@property (nonatomic, readonly) CRToastAnimationType inAnimationType;
@property (nonatomic, readonly) CRToastAnimationType outAnimationType;
@property (nonatomic, readonly) CRToastAnimationDirection inAnimationDirection;
@property (nonatomic, readonly) CRToastAnimationDirection outAnimationDirection;
@property (nonatomic, readonly) NSTimeInterval animateInTimeInterval;
@property (nonatomic, readonly) NSTimeInterval timeInterval;
@property (nonatomic, readonly) NSTimeInterval animateOutTimeInterval;

@property (nonatomic, readonly) CGFloat animationSpringDamping;
@property (nonatomic, readonly) CGFloat animationSpringInitialVelocity;
@property (nonatomic, readonly) CGFloat animationGravityMagnitude;

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) NSTextAlignment textAlignment;
@property (nonatomic, readonly) UIColor *textShadowColor;
@property (nonatomic, readonly) CGSize textShadowOffset;
@property (nonatomic, readonly) NSInteger textMaxNumberOfLines;

@property (nonatomic, readonly) NSString *subtitleText;
@property (nonatomic, readonly) UIFont *subtitleFont;
@property (nonatomic, readonly) UIColor *subtitleTextColor;
@property (nonatomic, readonly) NSTextAlignment subtitleTextAlignment;
@property (nonatomic, readonly) UIColor *subtitleTextShadowColor;
@property (nonatomic, readonly) CGSize subtitleTextShadowOffset;
@property (nonatomic, readonly) NSInteger subtitleTextMaxNumberOfLines;
@property (nonatomic, readonly) UIStatusBarStyle statusBarStyle;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) CGVector inGravityDirection;
@property (nonatomic, readonly) CGVector outGravityDirection;

@property (nonatomic, readonly) CGPoint inCollisionPoint1;
@property (nonatomic, readonly) CGPoint inCollisionPoint2;
@property (nonatomic, readonly) CGPoint outCollisionPoint1;
@property (nonatomic, readonly) CGPoint outCollisionPoint2;

- (void)swipeGestureRecognizerSwiped:(CRToastSwipeGestureRecognizer*)swipeGestureRecognizer;
- (void)tapGestureRecognizerTapped:(CRToastTapGestureRecognizer*)tapGestureRecognizer;
- (void)initiateAnimator:(UIView *)view;
@end

@interface CRToastNotificationView : UIView
@property (nonatomic, strong) CRToast *toast;
@end

#pragma mark - Option Constant Definitions

NSString *const kCRToastNotificationTypeKey                 = @"kCRToastNotificationTypeKey";
NSString *const kCRToastNotificationPresentationTypeKey     = @"kCRToastNotificationPresentationTypeKey";

NSString *const kCRToastUnderStatusBarKey                   = @"kCRToastUnderStatusBarKey";

NSString *const kCRToastAnimationInTypeKey                  = @"kCRToastAnimationInTypeKey";
NSString *const kCRToastAnimationOutTypeKey                 = @"kCRToastAnimationOutTypeKey";
NSString *const kCRToastAnimationInDirectionKey                 = @"kCRToastAnimationInDirectionKey";
NSString *const kCRToastAnimationOutDirectionKey                = @"kCRToastAnimationOutDirectionKey";

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
NSString *const kCRToastImageKey                            = @"kCRToastImageKey";

NSString *const kCRToastInteractionRespondersKey            = @"kCRToastInteractionRespondersKey";

#pragma mark - Option Defaults

static CRToastType                  kCRNotificationTypeDefault              = CRToastTypeStatusBar;
static CRToastPresentationType      kCRNotificationPresentationTypeDefault  = CRToastPresentationTypePush;
static BOOL                         kCRDisplayUnderStatusBarDefault         = NO;

static CRToastAnimationType         kCRAnimationTypeDefaultIn               = CRToastAnimationTypeLinear;
static CRToastAnimationType         kCRAnimationTypeDefaultOut              = CRToastAnimationTypeLinear;
static CRToastAnimationDirection    kCRInAnimationDirectionDefault          = CRToastAnimationDirectionTop;
static CRToastAnimationDirection    kCROutAnimationDirectionDefault         = CRToastAnimationDirectionBottom;
static NSTimeInterval               kCRAnimateInTimeIntervalDefault         = 0.4;
static NSTimeInterval               kCRTimeIntervalDefault                  = 2.0f;
static NSTimeInterval               kCRAnimateOutTimeIntervalDefault        = 0.4;

static CGFloat                      kCRSpringDampingDefault                 = 0.6;
static CGFloat                  	kCRSpringInitialVelocityDefault         = 1.0;
static CGFloat                      kCRGravityMagnitudeDefault              = 1.0;

static NSString *                   kCRTextDefault                          = @"";
static UIFont   *                   kCRFontDefault                          = nil;
static UIColor  *               	kCRTextColorDefault                     = nil;
static NSTextAlignment          	kCRTextAlignmentDefault                 = NSTextAlignmentCenter;
static UIColor  *               	kCRTextShadowColorDefault               = nil;
static CGSize                   	kCRTextShadowOffsetDefault;
static NSInteger                    kCRTextMaxNumberOfLinesDefault          = 0;

static NSString *                   kCRSubtitleTextDefault                  = nil;
static UIFont   *                   kCRSubtitleFontDefault                  = nil;
static UIColor  *               	kCRSubtitleTextColorDefault             = nil;
static NSTextAlignment          	kCRSubtitleTextAlignmentDefault         = NSTextAlignmentCenter;
static UIColor  *               	kCRSubtitleTextShadowColorDefault       = nil;
static CGSize                   	kCRSubtitleTextShadowOffsetDefault;
static NSInteger                    kCRSubtitleTextMaxNumberOfLinesDefault  = 0;
static UIStatusBarStyle             kCRStatusBarStyleDefault                = UIStatusBarStyleDefault;

static UIColor  *                   kCRBackgroundColorDefault               = nil;
static UIImage  *                   kCRImageDefault                         = nil;

static NSArray  *                   kCRInteractionResponders                = nil;

static NSDictionary *               kCRToastKeyClassMap                     = nil;

#pragma mark - Layout Helper Functions

static CGFloat const CRStatusBarDefaultHeight = 44.0f;
static CGFloat const CRStatusBariPhoneLandscape = 33.0f;

static CGFloat CRGetStatusBarHeight() {
    return (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ?
    [[UIApplication sharedApplication] statusBarFrame].size.width :
    [[UIApplication sharedApplication] statusBarFrame].size.height;
}

static CGFloat CRGetStatusBarWidth() {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return [UIScreen mainScreen].bounds.size.height;
}

static CGFloat CRGetNavigationBarHeight() {
    return (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ||
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
    CRStatusBarDefaultHeight :
    CRStatusBariPhoneLandscape;
}

static CGFloat CRGetNotificationViewHeight(CRToastType type) {
    switch (type) {
        case CRToastTypeStatusBar:
            return CRGetStatusBarHeight();
        case CRToastTypeNavigationBar:
            return CRGetStatusBarHeight() + CRGetNavigationBarHeight();
    }
}

static CGSize CRNotificationViewSize(CRToastType notificationType) {
    return CGSizeMake(CRGetStatusBarWidth(), CRGetNotificationViewHeight(notificationType));
}

static CGRect CRNotificationViewFrame(CRToastType type, CRToastAnimationDirection direction) {
    return CGRectMake(direction == CRToastAnimationDirectionLeft ? -CRGetStatusBarWidth() : direction == CRToastAnimationDirectionRight ? CRGetStatusBarWidth() : 0,
                      direction == CRToastAnimationDirectionTop ? -CRGetNotificationViewHeight(type) : direction == CRToastAnimationDirectionBottom ? CRGetNotificationViewHeight(type) : 0,
                      CRGetStatusBarWidth(),
                      CRGetNotificationViewHeight(type));
}

#pragma mark - Interaction Setup Helpers

BOOL CRToastInteractionResponderIsGenertic(CRToastInteractionResponder *interactionResponder) {
    return (interactionResponder.interactionType == CRToastInteractionTypeSwipe ||
            interactionResponder.interactionType == CRToastInteractionTypeTap   ||
            interactionResponder.interactionType == CRToastInteractionTypeAll);
}

BOOL CRToastInteractionResponderIsSwipe(CRToastInteractionResponder *interactionResponder) {
    return CRToastInteractionTypeSwipe & interactionResponder.interactionType;
}

BOOL CRToastInteractionResponderIsTap(CRToastInteractionResponder *interactionResponder) {
    return CRToastInteractionTypeTap & interactionResponder.interactionType;
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
    if (CRToastInteractionResponderIsSwipe(interactionResponder)) {
        return CRToastSwipeGestureRecognizerMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder.interactionType, interactionResponder);
    } else if (CRToastInteractionResponderIsTap(interactionResponder)) {
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
    if (interactionResponder.interactionType == CRToastInteractionTypeAll) {
        return [CRToastGenericTapRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder) arrayByAddingObjectsFromArray:CRToastGenericSwipeRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder)];
    } else if (interactionResponder.interactionType == CRToastInteractionTypeSwipe) {
        return CRToastGenericSwipeRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder);
    } else if (interactionResponder.interactionType == CRToastInteractionTypeTap) {
        return CRToastGenericTapRecognizersMake(target, @selector(swipeGestureRecognizerSwiped:), interactionResponder);
    }
    return nil;
}

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
                                kCRToastNotificationPresentationTypeKey     : NSStringFromClass([@(kCRNotificationPresentationTypeDefault) class]),
                                kCRToastUnderStatusBarKey                   : NSStringFromClass([@(kCRDisplayUnderStatusBarDefault) class]),
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
                                kCRToastImageKey                            : NSStringFromClass([UIImage class]),
                                kCRToastInteractionRespondersKey            : NSStringFromClass([NSArray class])};
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    CRToast *notification = [[self alloc] init];
    notification.options = options;
    notification.completion = completion;
    notification.state = CRToastStateWaiting;
    notification.uuid = [NSUUID UUID];
    return notification;
}

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    //TODO Validate Types of Default Options
    if (defaultOptions[kCRToastNotificationTypeKey])                kCRNotificationTypeDefault              = [defaultOptions[kCRToastNotificationTypeKey] integerValue];
    if (defaultOptions[kCRToastNotificationPresentationTypeKey])    kCRNotificationPresentationTypeDefault  = [defaultOptions[kCRToastNotificationPresentationTypeKey] integerValue];
    
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
    if (defaultOptions[kCRToastImageKey])                           kCRImageDefault                         = defaultOptions[kCRToastImageKey];
    
    if (defaultOptions[kCRToastInteractionRespondersKey])           kCRInteractionResponders                   = defaultOptions[kCRToastInteractionRespondersKey];
}

#pragma mark - Notification View Helpers

- (UIView*)notificationView {
    CGSize size = CRNotificationViewSize(self.notificationType);
    CRToastNotificationView *notificationView = [[CRToastNotificationView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    notificationView.toast = self;
    return notificationView;
}

- (CGRect)notificationViewAnimationFrame1 {
    return CRNotificationViewFrame(self.notificationType, self.inAnimationDirection);
}

- (CGRect)notificationViewAnimationFrame2 {
    return CRNotificationViewFrame(self.notificationType, self.outAnimationDirection);
}

#pragma mark - Gesture Recognizer Actions

- (void)swipeGestureRecognizerSwiped:(CRToastSwipeGestureRecognizer*)swipeGestureRecognizer {
    if (swipeGestureRecognizer.automaticallyDismiss) {
        [CRToastManager dismissNotification:YES];
    }
    swipeGestureRecognizer.block(swipeGestureRecognizer.interactionType);
}

- (void)tapGestureRecognizerTapped:(CRToastTapGestureRecognizer*)tapGestureRecognizer {
    if (tapGestureRecognizer.automaticallyDismiss) {
        [CRToastManager dismissNotification:YES];
    }
    tapGestureRecognizer.block(tapGestureRecognizer.interactionType);
}

#pragma mark - Overrides

- (NSArray*)gestureRecognizersForInteractionResponder:(NSArray*)interactionResponders {
    NSMutableArray *gestureRecognizers = [@[] mutableCopy];
    for (CRToastInteractionResponder *interactionResponder in [kCRInteractionResponders arrayByAddingObjectsFromArray:interactionResponders]) {
        if (CRToastInteractionResponderIsGenertic(interactionResponder)) {
            gestureRecognizers = [CRToastGenericRecognizersMake(self, interactionResponder) mutableCopy];
        } else {
            UIGestureRecognizer *gestureRecognizer = CRToastGestureRecognizerMake(self, interactionResponder);
            gestureRecognizer.delegate = self;
            [gestureRecognizers addObject:gestureRecognizer];
        }
    }
    return [NSArray arrayWithArray:gestureRecognizers];
}

- (NSArray*)gestureRecognizers {
    return _options[kCRToastInteractionRespondersKey] ?
    _gestureRecognizers ?: [self gestureRecognizersForInteractionResponder:_options[kCRToastInteractionRespondersKey]] :
    [self gestureRecognizersForInteractionResponder:kCRInteractionResponders];
}

- (CRToastType)notificationType {
    return _options[kCRToastNotificationTypeKey] ?
    [self.options[kCRToastNotificationTypeKey] integerValue] :
    kCRNotificationTypeDefault;
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

- (UIImage*)image {
    return _options[kCRToastImageKey] ?: kCRImageDefault;
}

- (NSInteger)maxNumberOfLines {
    return _options[kCRToastTextMaxNumberOfLinesKey] ?
    [_options[kCRToastTextMaxNumberOfLinesKey] integerValue] :
    kCRTextMaxNumberOfLinesDefault;
}

- (NSInteger)subtitleMaxNumberOfLines {
    return _options[kCRToastSubtitleTextMaxNumberOfLinesKey] ?
    [_options[kCRToastSubtitleTextMaxNumberOfLinesKey] integerValue] :
    kCRSubtitleTextMaxNumberOfLinesDefault;
}

- (UIStatusBarStyle)statusBarStyle {
    return _options[kCRToastStatusBarStyleKey] ? [_options[kCRToastStatusBarStyleKey] integerValue] : kCRStatusBarStyleDefault;
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
            y = (factor*CGRectGetHeight(self.notificationViewAnimationFrame1))+(push ? -4*kCRCollisionTweak : kCRCollisionTweak);
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
    return (CGPoint){x, y};
}

- (CGPoint)inCollisionPoint2 {
    CGFloat x;
    CGFloat y;
    CGFloat factor = self.presentationType == CRToastPresentationTypeCover ?: 2;
    BOOL push = self.presentationType == CRToastPresentationTypePush;
    switch (self.inAnimationDirection) {
        case CRToastAnimationDirectionTop:
            x = CGRectGetWidth(self.notificationViewAnimationFrame1);
            y = (factor*CGRectGetHeight(self.notificationViewAnimationFrame1))+(push ? -4*kCRCollisionTweak : kCRCollisionTweak);
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
    return (CGPoint){x, y};
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
    return (CGPoint){x, y};
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
    return (CGPoint){x, y};
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
}

- (void)setOptions:(NSDictionary *)options {
    NSMutableDictionary *cleanOptions = [options mutableCopy];
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //Check keys validity followed by checking objects type validity
        if ([kCRToastKeyClassMap.allKeys indexOfObjectIdenticalTo:key] == NSNotFound) {
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

#pragma mark - CRToastNotificationView

@interface CRToastNotificationView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

static CGFloat const kCRStatusBarViewNoImageLeftContentInset = 10;
static CGFloat const kCRStatusBarViewNoImageRightContentInset = 10;

// UIApplication's statusBarFrame will return a height for the status bar that includes
// a 5 pixel vertical padding. This frame height is inappropriate to use when centering content
// vertically under the status bar. This adjustment is uesd to correct the frame height when centering
// content under the status bar.

static CGFloat const CRStatusBarViewUnderStatusBarYOffsetAdjustment = -5;

@implementation CRToastNotificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.userInteractionEnabled = NO;
        [self addSubview:label];
        self.label = label;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.userInteractionEnabled = NO;        
        [self addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame = self.bounds;
    CGSize imageSize = self.imageView.image.size;
    
    CGFloat statusBarYOffset = self.toast.displayUnderStatusBar ? (CRGetStatusBarHeight()+CRStatusBarViewUnderStatusBarYOffsetAdjustment) : 0;
    contentFrame.size.height = CGRectGetHeight(contentFrame) - statusBarYOffset;
    
    self.imageView.frame = CGRectMake(0,
                                      statusBarYOffset,
                                      imageSize.width == 0 ?
                                        0 :
                                        CGRectGetHeight(contentFrame),
                                      imageSize.height == 0 ?
                                        0 :
                                        CGRectGetHeight(contentFrame));
    CGFloat x = imageSize.width == 0 ? kCRStatusBarViewNoImageLeftContentInset : CGRectGetMaxX(_imageView.frame);
    CGFloat width = CGRectGetWidth(contentFrame)-x-kCRStatusBarViewNoImageRightContentInset;
    
    if (self.toast.subtitleText == nil) {
        self.label.frame = CGRectMake(x,
                                      statusBarYOffset,
                                      width,
                                      CGRectGetHeight(contentFrame));
    } else {
        CGFloat height = MIN([self.toast.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : self.toast.font}
                                                           context:nil].size.height,
                             CGRectGetHeight(contentFrame));
        CGFloat subtitleHeight = [self.toast.subtitleText boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName : self.toast.subtitleFont }
                                                       context:nil].size.height;
        if ((CGRectGetHeight(contentFrame) - (height + subtitleHeight)) < 5) {
            subtitleHeight = (CGRectGetHeight(contentFrame) - (height))-10;
        }
        CGFloat offset = (CGRectGetHeight(contentFrame) - (height + subtitleHeight))/2;
        
        self.label.frame = CGRectMake(x,
                                      offset+statusBarYOffset,
                                      CGRectGetWidth(contentFrame)-x-kCRStatusBarViewNoImageRightContentInset,
                                      height);

        self.subtitleLabel.frame = CGRectMake(x,
                                              height+offset+statusBarYOffset,
                                              CGRectGetWidth(contentFrame)-x-kCRStatusBarViewNoImageRightContentInset,
                                              subtitleHeight);
    }
}

#pragma mark - Overrides

- (void)setToast:(CRToast *)toast {
    _toast = toast;
    _label.text = toast.text;
    _label.font = toast.font;
    _label.textColor = toast.textColor;
    _label.textAlignment = toast.textAlignment;
    _label.numberOfLines = toast.textMaxNumberOfLines;
    if (toast.subtitleText != nil) {
        _subtitleLabel.text = toast.subtitleText;
        _subtitleLabel.font = toast.subtitleFont;
        _subtitleLabel.textColor = toast.subtitleTextColor;
        _subtitleLabel.textAlignment = toast.subtitleTextAlignment;
        _subtitleLabel.numberOfLines = toast.subtitleTextMaxNumberOfLines;
    }
    _imageView.image = toast.image;
    self.backgroundColor = toast.backgroundColor;
}

@end

#pragma mark - CRWindow

@interface CRWindow : UIWindow

@end

@implementation CRWindow

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    for (UIView*subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - CRToastView

@interface CRToastView : UIView

@end

@implementation CRToastView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    for (UIView*subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - CRToastViewController

@interface CRToastViewController : UIViewController <UICollisionBehaviorDelegate>

@property (nonatomic, weak, readonly) UIView *notificationView;
@property (nonatomic, weak, readonly) UIView *notificationContainerView;

@property (nonatomic, strong, readonly) CRToast *notification;
@property (nonatomic, strong) NSMutableArray *notifications;

@property (nonatomic, copy) void (^gravityAnimationCompletionBlock)(BOOL finished);

- (void)statusBarStyle:(UIStatusBarStyle)newStatusBarStyle;

- (void)displayNotification:(CRToast*)notification;
- (void)dismissNotification:(BOOL)animated;

@end

static NSString *const kCRToastManagerCollisionBoundryIdentifier = @"kCRToastManagerCollisionBoundryIdentifier";

typedef void (^CRToastAnimationCompletionBlock)(BOOL animated);
typedef void (^CRToastAnimationStepBlock)(void);

#pragma mark - Notification Management

CRToastAnimationCompletionBlock CRToastOutwardAnimationsCompletionBlock(CRToastViewController *weakSelf) {
    return ^void(BOOL completed){
        weakSelf.view.gestureRecognizers = nil;
        weakSelf.notification.state = CRToastStateCompleted;
        if (weakSelf.notification.completion) weakSelf.notification.completion();
        [weakSelf.notifications removeObject:weakSelf.notification];
        [weakSelf.notificationView removeFromSuperview];
        if (weakSelf.notifications.count > 0) {
            CRToast *notification = weakSelf.notifications.firstObject;
            weakSelf.gravityAnimationCompletionBlock = NULL;
            [weakSelf displayNotification:notification];
        } else {
            weakSelf.view.window.hidden = YES;
        }
    };
}

CRToastAnimationStepBlock CRToastOutwardAnimationsBlock(CRToastViewController *weakSelf) {
    return ^{
        weakSelf.notification.state = CRToastStateExiting;
        [weakSelf.notification.animator removeAllBehaviors];
        weakSelf.notificationView.frame = weakSelf.notification.notificationViewAnimationFrame2;
    };
}

CRToastAnimationStepBlock CRToastOutwardAnimationsSetupBlock(CRToastViewController *weakSelf) {
    return ^{
        CRToast *notification = weakSelf.notification;
        weakSelf.notification.state = CRToastStateExiting;
        [weakSelf.view.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIGestureRecognizer*)obj setEnabled:NO];
        }];
        
        switch (weakSelf.notification.outAnimationType) {
            case CRToastAnimationTypeLinear: {
                [UIView animateWithDuration:notification.animateOutTimeInterval
                                      delay:0
                                    options:0
                                 animations:CRToastOutwardAnimationsBlock(weakSelf)
                                 completion:CRToastOutwardAnimationsCompletionBlock(weakSelf)];
            } break;
            case CRToastAnimationTypeSpring: {
                [UIView animateWithDuration:notification.animateOutTimeInterval
                                      delay:0
                     usingSpringWithDamping:notification.animationSpringDamping
                      initialSpringVelocity:notification.animationSpringInitialVelocity
                                    options:0
                                 animations:CRToastOutwardAnimationsBlock(weakSelf)
                                 completion:CRToastOutwardAnimationsCompletionBlock(weakSelf)];
            } break;
            case CRToastAnimationTypeGravity: {
                if (weakSelf.notification.animator == nil) {
                    [weakSelf.notification initiateAnimator:weakSelf.notificationContainerView];
                }
                [weakSelf.notification.animator removeAllBehaviors];
                UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[weakSelf.notificationView]];
                gravity.gravityDirection = notification.outGravityDirection;
                gravity.magnitude = notification.animationGravityMagnitude;
                NSMutableArray *collisionItems = [@[weakSelf.notificationView] mutableCopy];
                UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
                collision.collisionDelegate = weakSelf;
                [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                           fromPoint:notification.outCollisionPoint1
                                             toPoint:notification.outCollisionPoint2];
                [weakSelf.notification.animator addBehavior:gravity];
                [weakSelf.notification.animator addBehavior:collision];
                weakSelf.gravityAnimationCompletionBlock = CRToastOutwardAnimationsCompletionBlock(weakSelf);
            } break;
        }
    };
}

@implementation CRToastViewController

UIStatusBarStyle statusBarStyle;

- (void)loadView {
    UIView *containerView = [[UIView alloc] init];
    self.view = [[CRToastView alloc] init];
    
    _notificationContainerView = containerView;
    [self.view addSubview:containerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.notificationContainerView.clipsToBounds = YES;
    self.notificationContainerView.userInteractionEnabled = YES;
    self.notificationContainerView.backgroundColor = [UIColor clearColor];
    
    self.notifications = [NSMutableArray array];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    CGSize notificationSize = CRNotificationViewSize(self.notification.notificationType);
    self.notificationContainerView.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    self.notificationView.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    if (self.notification.animator) {
        [self.notification.animator removeAllBehaviors];
        if (self.gravityAnimationCompletionBlock) {
            self.gravityAnimationCompletionBlock(YES);
        }
    }
}

- (void)addNotification:(CRToast*)notification {
    BOOL showingNotification = self.showingNotification;
    [self.notifications addObject:notification];
    if (!showingNotification) {
        [self displayNotification:notification];
    }
}

- (void)displayNotification:(CRToast*)notification {
    _notification = notification;
    _notificationView = notification.notificationView;
    
    self.view.window.hidden = NO;
    self.view.window.windowLevel = notification.displayUnderStatusBar ? UIWindowLevelNormal : UIWindowLevelStatusBar;
    [self statusBarStyle:notification.statusBarStyle];
    
    CGSize notificationSize = CRNotificationViewSize(notification.notificationType);
    
    UIView *notificationView = self.notificationView;
    notificationView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    notificationView.frame = notification.notificationViewAnimationFrame1;
    self.notificationContainerView.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    [self.notificationContainerView addSubview:notificationView];
    
    self.notificationView.gestureRecognizers = notification.gestureRecognizers;
    
    __weak __block typeof(self) weakSelf = self;
    CRToastAnimationStepBlock inwardAnimationsBlock = ^void(void) {
        weakSelf.notificationView.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    };
    
    NSString *notificationUUIDString = notification.uuid.UUIDString;
    CRToastAnimationCompletionBlock inwardAnimationsCompletionBlock = ^void(BOOL finished) {
        if (notification.timeInterval != DBL_MAX && notification.state == CRToastStateEntering) {
            notification.state = CRToastStateDisplaying;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(notification.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.notification.state == CRToastStateDisplaying && [weakSelf.notification.uuid.UUIDString isEqualToString:notificationUUIDString]) {
                    self.gravityAnimationCompletionBlock = NULL;
                    CRToastOutwardAnimationsSetupBlock(weakSelf)();
                }
            });
        }
    };
    
    notification.state = CRToastStateEntering;
    switch (notification.inAnimationType) {
        case CRToastAnimationTypeLinear: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        } break;
        case CRToastAnimationTypeSpring: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                                  delay:0.0
                 usingSpringWithDamping:notification.animationSpringDamping
                  initialSpringVelocity:notification.animationSpringInitialVelocity
                                options:0
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        } break;
        case CRToastAnimationTypeGravity: {
            [notification initiateAnimator:self.notificationContainerView];
            [notification.animator removeAllBehaviors];
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[notificationView]];
            gravity.gravityDirection = notification.inGravityDirection;
            gravity.magnitude = notification.animationGravityMagnitude;
            NSMutableArray *collisionItems = [@[notificationView] mutableCopy];
            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
            collision.collisionDelegate = self;
            [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                       fromPoint:notification.inCollisionPoint1
                                         toPoint:notification.inCollisionPoint2];
            [notification.animator addBehavior:gravity];
            [notification.animator addBehavior:collision];
            self.gravityAnimationCompletionBlock = inwardAnimationsCompletionBlock;
        } break;
    }
}

- (void)dismissNotification:(BOOL)animated {
    if (self.notifications.count == 0) return;
    
    if (animated && (self.notification.state == CRToastStateEntering || self.notification.state == CRToastStateDisplaying)) {
        __weak __block typeof(self) weakSelf = self;
        CRToastOutwardAnimationsSetupBlock(weakSelf)();
    } else {
        __weak __block typeof(self) weakSelf = self;
        CRToastOutwardAnimationsCompletionBlock(weakSelf)(YES);
    }
}

#pragma mark - Overrides

- (BOOL)showingNotification {
    return self.notifications.count > 0;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier {
    if (self.gravityAnimationCompletionBlock) {
        self.gravityAnimationCompletionBlock(YES);
        self.gravityAnimationCompletionBlock = NULL;
    }
}

@end

#pragma mark - CRToastManager

@interface CRToastManager ()

@property (nonatomic, strong) CRWindow *notificationWindow;
@property (nonatomic, strong) CRToastViewController *viewController;

@end

@implementation CRToastManager

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    [CRToast setDefaultOptions:defaultOptions];
}

+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    [[CRToastManager manager] addNotification:[CRToast notificationWithOptions:options
                                                               completionBlock:completion]];
}

+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(void))completion {
    [self showNotificationWithOptions:@{kCRToastTextKey : message}
                      completionBlock:completion];
}

+ (void)dismissNotification:(BOOL)animated {
    [[self manager] dismissNotification:animated];
}

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CRWindow *notificationWindow = [[CRWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        CRToastViewController *viewController = [[CRToastViewController alloc] init];
        
        notificationWindow.backgroundColor = [UIColor clearColor];
        notificationWindow.rootViewController = viewController;
        [notificationWindow addSubview:viewController.view];
        
        self.notificationWindow = notificationWindow;
        self.viewController = viewController;
    }
    return self;
}

- (void)dismissNotification:(BOOL)animated {
    [self.viewController dismissNotification:animated];
}

- (void)addNotification:(CRToast*)notification {
    [self.viewController addNotification:notification];
}

- (void)displayNotification:(CRToast*)notification {
    [self.viewController displayNotification:notification];
}

@end