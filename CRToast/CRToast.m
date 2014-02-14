//
//  CRToast.m
//  CRNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CRToast.h"

#pragma mark - CRToastView

@interface CRToastView : UIView
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) NSString *text;
@end

@interface CRToastView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

static CGFloat const kCRStatusBarViewNoImageLeftContentInset = 10;
static CGFloat const kCRStatusBarViewNoImageRightContentInset = 10;

@implementation CRToastView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGSize imageSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, imageSize.width == 0 ? 0 : CGRectGetHeight(bounds), imageSize.height == 0 ? 0 : CGRectGetHeight(bounds));
    CGFloat x = imageSize.width == 0 ? kCRStatusBarViewNoImageLeftContentInset : CGRectGetMaxX(_imageView.frame);
    self.label.frame = CGRectMake(x,
                                  0,
                                  CGRectGetWidth(bounds)-x-kCRStatusBarViewNoImageRightContentInset,
                                  CGRectGetHeight(bounds));
}

#pragma mark - Overrides

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self setNeedsLayout];
}

- (UIImage*)image {
    return self.imageView.image;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    [self setNeedsLayout];
}

- (NSString*)text {
    return self.label.text;
}

@end

#pragma mark - CRToast

@interface CRToast : NSObject

//Top Level Properties

@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, copy) void(^completion)(void);

//Views and Layout Data

@property (nonatomic, readonly) UIView *notificationView;
@property (nonatomic, readonly) CGRect notificationViewAnimationFrame1;
@property (nonatomic, readonly) CGRect notificationViewAnimationFrame2;
@property (nonatomic, readonly) UIView *statusBarView;
@property (nonatomic, readonly) CGRect statusBarViewAnimationFrame1;
@property (nonatomic, readonly) CGRect statusBarViewAnimationFrame2;

//Read Only Convinence Properties Providing Default Values or Values from Options

@property (nonatomic, readonly) CRToastType notificationType;
@property (nonatomic, readonly) CRToastPresentationType presentationType;

@property (nonatomic, readonly) CRToastAnimationType animationType;
@property (nonatomic, readonly) CRToastAnimationStyle inAnimationStyle;
@property (nonatomic, readonly) CRToastAnimationStyle outAnimationStyle;
@property (nonatomic, readonly) NSTimeInterval animateInTimeInterval;
@property (nonatomic, readonly) NSTimeInterval timeInterval;
@property (nonatomic, readonly) NSTimeInterval animateOutTimeInterval;

@property (nonatomic, readonly) CGFloat animationSpringDamping;
@property (nonatomic, readonly) CGFloat animationInitialVelocity;

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) NSTextAlignment textAlignment;
@property (nonatomic, readonly) UIColor *textShadowColor;
@property (nonatomic, readonly) CGSize textShadowOffset;
@property (nonatomic, readonly) NSInteger textMaxNumberOfLines;

@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIImage *image;

@end

#pragma mark - Option Constant Definitions

NSString *const kCRToastNotificationTypeKey                 = @"kCRToastNotificationTypeKey";
NSString *const kCRToastNotificationPresentationTypeKey     = @"kCRToastNotificationPresentationTypeKey";

NSString *const kCRToastAnimationTypeKey                    = @"kCRToastAnimationTypeKey";
NSString *const kCRToastAnimationInStyleKey                 = @"kCRToastAnimationInStyleKey";
NSString *const kCRToastAnimationOutStyleKey                = @"kCRToastAnimationOutStyleKey";

NSString *const kCRToastAnimationInTimeIntervalKey          = @"kCRToastAnimateInTimeInterval";
NSString *const kCRToastTimeIntervalKey                     = @"kCRToastTimeIntervalKey";
NSString *const kCRToastAnimationOutTimeIntervalKey         = @"kCRToastAnimateOutTimeInterval";

NSString *const kCRToastAnimationSpringDampingKey           = @"kCRToastAnimationSpringDampingKey";
NSString *const kCRToastAnimationSpringInitialVelocityKey   = @"kCRToastAnimateSpringVelocityKey";

NSString *const kCRToastTextKey                             = @"kCRToastTextKey";
NSString *const kCRToastFontKey                             = @"kCRToastFontKey";
NSString *const kCRToastTextColorKey                        = @"kCRToastTextColorKey";
NSString *const kCRToastTextAlignmentKey                    = @"kCRToastTextAlignmentKey";
NSString *const kCRToastTextShadowColorKey                  = @"kCRToastTextShadowColorKey";
NSString *const kCRToastTextShadowOffsetKey                 = @"kCRToastTextShadowOffsetKey";
NSString *const kCRToastTextMaxNumberOfLinesKey             = @"kCRToastTextMaxNumberOfLinesKey";

NSString *const kCRToastBackgroundColorKey                  = @"kCRToastBackgroundColorKey";
NSString *const kCRToastImageKey                            = @"kCRToastImageKey";

#pragma mark - Option Defaults

static CRToastType              kCRNotificationTypeDefault              = CRToastTypeStatusBar;
static CRToastPresentationType  kCRNotificationPresentationTypeDefault  = CRToastPresentationTypePush;

static CRToastAnimationType     kCRAnimationTypeDefault                 = CRToastAnimationTypeLinear;
static CRToastAnimationStyle    kCRInAnimationStyleDefault              = CRToastAnimationStyleTop;
static CRToastAnimationStyle    kCROutAnimationStyleDefault             = CRToastAnimationStyleBottom;
static NSTimeInterval           kCRAnimateInTimeIntervalDefault         = 0.4;
static NSTimeInterval           kCRTimeIntervalDefault                  = 2.0f;
static NSTimeInterval           kCRAnimateOutTimeIntervalDefault        = 0.4;

static CGFloat                  kCRSpringDampingDefault                 = 0.6;
static CGFloat                  kCRSpringInitialVelocityDefault         = 1.0;

static NSString *               kCRTextDefault                          = @"";
static UIFont   *               kCRFontDefault                          = nil;
static UIColor  *               kCRTextColorDefault                     = nil;
static NSTextAlignment          kCRTextAlignmentDefault                 = NSTextAlignmentCenter;
static UIColor  *               kCRTextShadowColorDefault               = nil;
static CGSize                   kCRTextShadowOffsetDefault;
static NSInteger                kCRTextMaxNumberOfLinesDefault          = 0;

static UIColor  *               kCRBackgroundColorDefault               = nil;
static UIImage  *               kCRImageDefault                         = nil;

#pragma mark - Layout Helper Functions

static CGFloat const CRStatusBarDefaultHeight = 44.0f;
static CGFloat const CRStatusBariPhoneLandscape = 30.0f;

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

static CGRect CRNotificationViewFrame(CRToastType type, CRToastAnimationStyle style) {
    return CGRectMake(style == CRToastAnimationStyleLeft ? -CRGetStatusBarWidth() : style == CRToastAnimationStyleRight ? CRGetStatusBarWidth() : 0,
                      style == CRToastAnimationStyleTop ? -CRGetNotificationViewHeight(type) : style == CRToastAnimationStyleBottom ? CRGetNotificationViewHeight(type) : 0,
                      CRGetStatusBarWidth(),
                      CRGetNotificationViewHeight(type));
}

static CGRect CRStatusBarViewFrame(CRToastType type, CRToastAnimationStyle style) {
    return CRNotificationViewFrame(type,style == CRToastAnimationStyleTop ? CRToastAnimationStyleBottom :
                                        style == CRToastAnimationStyleBottom ? CRToastAnimationStyleTop :
                                        style == CRToastAnimationStyleLeft ? CRToastAnimationStyleRight :
                                        CRToastAnimationStyleLeft);
}

@implementation CRToast

+ (void)initialize {
    if (self == [CRToast class]) {
        kCRFontDefault = [UIFont systemFontOfSize:12];
        kCRTextColorDefault = [UIColor whiteColor];
        kCRBackgroundColorDefault = [[UIApplication sharedApplication] delegate].window.tintColor;
        kCRTextShadowOffsetDefault = CGSizeZero;
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    CRToast *notification = [[self alloc] init];
    notification.options = options;
    notification.completion = completion;
    return notification;
}

+ (id)sharedNotification {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    if (defaultOptions[kCRToastNotificationTypeKey])                kCRNotificationTypeDefault              = [defaultOptions[kCRToastNotificationTypeKey] integerValue];
    if (defaultOptions[kCRToastNotificationPresentationTypeKey])    kCRNotificationPresentationTypeDefault  = [defaultOptions[kCRToastNotificationPresentationTypeKey] integerValue];

    if (defaultOptions[kCRToastAnimationTypeKey])                   kCRAnimationTypeDefault                 = [defaultOptions[kCRToastAnimationTypeKey] integerValue];
    if (defaultOptions[kCRToastAnimationInStyleKey])                kCRInAnimationStyleDefault              = [defaultOptions[kCRToastAnimationInStyleKey] integerValue];
    if (defaultOptions[kCRToastAnimationOutStyleKey])               kCROutAnimationStyleDefault             = [defaultOptions[kCRToastAnimationOutStyleKey] integerValue];

    if (defaultOptions[kCRToastAnimationInTimeIntervalKey])         kCRAnimateInTimeIntervalDefault         = [defaultOptions[kCRToastAnimationInTimeIntervalKey] doubleValue];
    if (defaultOptions[kCRToastTimeIntervalKey])                    kCRTimeIntervalDefault                  = [defaultOptions[kCRToastTimeIntervalKey] doubleValue];
    if (defaultOptions[kCRToastAnimationOutTimeIntervalKey])        kCRAnimateOutTimeIntervalDefault        = [defaultOptions[kCRToastAnimationOutTimeIntervalKey] doubleValue];
    
    if (defaultOptions[kCRToastAnimationSpringDampingKey])          kCRSpringDampingDefault                 = [defaultOptions[kCRToastAnimationSpringDampingKey] floatValue];
    if (defaultOptions[kCRToastAnimationSpringInitialVelocityKey])  kCRSpringInitialVelocityDefault         = [defaultOptions[kCRToastAnimationSpringInitialVelocityKey] floatValue];
    
    if (defaultOptions[kCRToastTextKey])                            kCRTextDefault                          = defaultOptions[kCRToastTextKey];
    if (defaultOptions[kCRToastFontKey])                            kCRFontDefault                          = defaultOptions[kCRToastFontKey];
    if (defaultOptions[kCRToastTextColorKey])                       kCRTextColorDefault                     = defaultOptions[kCRToastTextColorKey];
    if (defaultOptions[kCRToastTextAlignmentKey])                   kCRTextAlignmentDefault                 = [defaultOptions[kCRToastTextAlignmentKey] integerValue];
    if (defaultOptions[kCRToastTextShadowColorKey])                 kCRTextShadowColorDefault               = defaultOptions[kCRToastTextShadowColorKey];
    if (defaultOptions[kCRToastTextShadowOffsetKey])                kCRTextShadowOffsetDefault              = [defaultOptions[kCRToastTextShadowOffsetKey] CGSizeValue];
    if (defaultOptions[kCRToastTextMaxNumberOfLinesKey])            kCRTextMaxNumberOfLinesDefault          = [defaultOptions[kCRToastTextMaxNumberOfLinesKey] integerValue];
    
    if (defaultOptions[kCRToastBackgroundColorKey])                 kCRBackgroundColorDefault               = defaultOptions[kCRToastBackgroundColorKey];
    if (defaultOptions[kCRToastImageKey])                           kCRImageDefault                         = defaultOptions[kCRToastImageKey];
}

#pragma mark - Notification View Helpers

- (UIView*)notificationView {
    CGSize size = CRNotificationViewSize(self.notificationType);
    CRToastView *notificationView = [[CRToastView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    notificationView.label.text = self.text;
    notificationView.label.font = self.font;
    notificationView.label.textColor = self.textColor;
    notificationView.label.textAlignment = self.textAlignment;
    notificationView.label.numberOfLines = self.textMaxNumberOfLines;
    notificationView.backgroundColor = self.backgroundColor;
    notificationView.image = self.image;
    return notificationView;
}

- (CGRect)notificationViewAnimationFrame1 {
    return CRNotificationViewFrame(self.notificationType, self.inAnimationStyle);
}

- (CGRect)notificationViewAnimationFrame2 {
    return CRNotificationViewFrame(self.notificationType, self.outAnimationStyle);
}

- (UIView*)statusBarView {
    UIView *statusBarView = [[UIView alloc] initWithFrame:self.statusBarViewAnimationFrame1];
    [statusBarView addSubview:[[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES]];
    statusBarView.clipsToBounds = YES;
    return statusBarView;
}

- (CGRect)statusBarViewAnimationFrame1 {
    return CRStatusBarViewFrame(self.notificationType, self.inAnimationStyle);
}

- (CGRect)statusBarViewAnimationFrame2 {
    return CRStatusBarViewFrame(self.notificationType, self.outAnimationStyle);
}

#pragma mark - Overrides

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

- (CRToastAnimationType)animationType {
    return _options[kCRToastAnimationTypeKey] ?
    [_options[kCRToastAnimationTypeKey] integerValue] :
    kCRAnimationTypeDefault;
}

- (CRToastAnimationStyle)inAnimationStyle {
    return _options[kCRToastAnimationInStyleKey] ?
    [_options[kCRToastAnimationInStyleKey] integerValue] :
    kCRInAnimationStyleDefault;
}

- (CRToastAnimationStyle)outAnimationStyle {
    return _options[kCRToastAnimationInStyleKey] ?
    [_options[kCRToastAnimationOutStyleKey] integerValue] :
    kCROutAnimationStyleDefault;
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

- (CGFloat)animationInitialVelocity {
    return _options[kCRToastAnimationSpringInitialVelocityKey] ?
    [_options[kCRToastAnimationSpringInitialVelocityKey] floatValue] :
    kCRSpringInitialVelocityDefault;
}

- (CGFloat)animationSpringDamping {
    return _options[kCRToastAnimationSpringDampingKey] ?
    [_options[kCRToastAnimationSpringDampingKey] floatValue] :
    kCRSpringDampingDefault;
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

@end

#pragma mark - CRToastManager

@interface CRToastManager ()
@property (nonatomic, readonly) BOOL showingNotification;
@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic, strong) NSMutableArray *notifications;
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

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        UIWindow *notificationWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        notificationWindow.backgroundColor = [UIColor clearColor];
        notificationWindow.userInteractionEnabled = NO;
        notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        notificationWindow.windowLevel = UIWindowLevelStatusBar;
        notificationWindow.rootViewController = [UIViewController new];
        notificationWindow.rootViewController.view.clipsToBounds = YES;
        self.notificationWindow = notificationWindow;
        
        self.notifications = [@[] mutableCopy];
    }
    return self;
}

#pragma mark - Notification Management

- (void)addNotification:(CRToast*)notification {
    BOOL showingNotification = self.showingNotification;
    [_notifications addObject:notification];
    if (!showingNotification) {
        [self displayNotification:notification];
    }
}

- (void)displayNotification:(CRToast*)notification {
    _notificationWindow.hidden = NO;
    CGSize notificationSize = CRNotificationViewSize(notification.notificationType);
    _notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);

    UIView *statusBarView = notification.statusBarView;
    statusBarView.frame = _notificationWindow.rootViewController.view.bounds;
    [_notificationWindow.rootViewController.view addSubview:statusBarView];
    statusBarView.hidden = notification.presentationType == CRToastPresentationTypeCover;
    
    UIView *notificationView = notification.notificationView;
    notificationView.frame = notification.notificationViewAnimationFrame1;
    [_notificationWindow.rootViewController.view addSubview:notificationView];
    __weak __block typeof(self) weakSelf = self;
    
    void (^inwardAnimationsBlock)(void) = ^void(void) {
        notificationView.frame = _notificationWindow.rootViewController.view.bounds;
        statusBarView.frame = notification.statusBarViewAnimationFrame1;
    };
    
    void (^outwardAnimationsBlock)(void) = ^void(void) {
        notificationView.frame = notification.notificationViewAnimationFrame2;
        statusBarView.frame = _notificationWindow.rootViewController.view.bounds;
    };
    
    void (^outwardAnimationsCompletionBlock)(BOOL) = ^void(BOOL finished) {
        if (notification.completion) notification.completion();
        [weakSelf.notifications removeObject:notification];
        [notificationView removeFromSuperview];
        [statusBarView removeFromSuperview];
        if (weakSelf.notifications.count > 0) {
            CRToast *notification = weakSelf.notifications.firstObject;
            [weakSelf displayNotification:notification];
        } else {
            weakSelf.notificationWindow.hidden = YES;
        }
    };
    
    void (^inwardAnimationsCompletionBlock)(BOOL) = ^void(BOOL finished) {
        statusBarView.frame = notification.statusBarViewAnimationFrame2;
        if (notification.animationType == CRToastAnimationTypeLinear) {
            [UIView animateWithDuration:notification.animateOutTimeInterval
                                  delay:notification.timeInterval
                                options:0
                             animations:outwardAnimationsBlock
                             completion:outwardAnimationsCompletionBlock];
        } else if (notification.animationType == CRToastAnimationTypeSpring) {
            [UIView animateWithDuration:notification.animateOutTimeInterval
                                  delay:notification.timeInterval
                 usingSpringWithDamping:notification.animationSpringDamping
                  initialSpringVelocity:notification.animationInitialVelocity
                                options:0
                             animations:outwardAnimationsBlock
                             completion:outwardAnimationsCompletionBlock];
            
        }
    };
    
    if (notification.animationType == CRToastAnimationTypeLinear) {
        [UIView animateWithDuration:notification.animateInTimeInterval
                         animations:inwardAnimationsBlock
                         completion:inwardAnimationsCompletionBlock];

    } else if (notification.animationType == CRToastAnimationTypeSpring) {
        [UIView animateWithDuration:notification.animateInTimeInterval
                              delay:0.0
             usingSpringWithDamping:notification.animationSpringDamping
              initialSpringVelocity:notification.animationInitialVelocity
                            options:0
                         animations:inwardAnimationsBlock
                         completion:inwardAnimationsCompletionBlock];
    }
}

#pragma mark - Overrides

- (BOOL)showingNotification {;
    return self.notifications.count > 0;
}

@end