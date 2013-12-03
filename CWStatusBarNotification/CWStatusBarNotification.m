//
//  CWStatusBarNotification.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CWStatusBarNotification.h"

#pragma mark - CWStatusBarNotificationView

@interface CWStatusBarNotificationView : UIView
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) NSString *text;
@end

@interface CWStatusBarNotificationView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

static CGFloat const kCWStatusBarViewNoImageLeftContentInset = 10;
static CGFloat const kCWStatusBarViewNoImageRightContentInset = 10;

@implementation CWStatusBarNotificationView

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
    CGFloat x = imageSize.width == 0 ? kCWStatusBarViewNoImageLeftContentInset : CGRectGetMaxX(_imageView.frame);
    self.label.frame = CGRectMake(x,
                                  0,
                                  CGRectGetWidth(bounds)-x-kCWStatusBarViewNoImageRightContentInset,
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

#pragma mark - CWStatusBarNotification

@interface CWStatusBarNotification : NSObject

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

@property (nonatomic, readonly) CWStatusBarNotificationType notificationType;
@property (nonatomic, readonly) CWStatusBarNotificationPresentationType presentationType;

@property (nonatomic, readonly) CWStatusBarNotificationAnimationType animationType;
@property (nonatomic, readonly) CWStatusBarNotificationAnimationStyle inAnimationStyle;
@property (nonatomic, readonly) CWStatusBarNotificationAnimationStyle outAnimationStyle;
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

@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIImage *image;

@end

#pragma mark - Option Constant Definitions

NSString *const kCWStatusBarNotificationNotificationTypeKey                 = @"kCWStatusBarNotificationNotificationTypeKey";
NSString *const kCWStatusBarNotificationNotificationPresentationTypeKey     = @"kCWStatusBarNotificationNotificationPresentationTypeKey";

NSString *const kCWStatusBarNotificationAnimationTypeKey                    = @"kCWStatusBarNotificationAnimationTypeKey";
NSString *const kCWStatusBarNotificationAnimationInStyleKey     = @"kCWStatusBarNotificationAnimationInStyleKey";
NSString *const kCWStatusBarNotificationAnimationOutStyleKey    = @"kCWStatusBarNotificationAnimationOutStyleKey";

NSString *const kCWStatusBarNotificationAnimationInTimeIntervalKey            = @"kCWStatusBarNotificationAnimateInTimeInterval";
NSString *const kCWStatusBarNotificationTimeIntervalKey                     = @"kCWStatusBarNotificationTimeIntervalKey";
NSString *const kCWStatusBarNotificationAnimationOutTimeIntervalKey           = @"kCWStatusBarNotificationAnimateOutTimeInterval";

NSString *const kCWStatusBarNotificationAnimationSpringDampingKey             = @"kCWStatusBarNotificationAnimationSpringDampingKey";
NSString *const kCWStatusBarNotificationAnimationSpringInitialVelocityKey     = @"kCWStatusBarNotificationAnimateSpringVelocityKey";

NSString *const kCWStatusBarNotificationTextKey                             = @"kCWStatusBarNotificationTextKey";
NSString *const kCWStatusBarNotificationFontKey                             = @"kCWStatusBarNotificationFontKey";
NSString *const kCWStatusBarNotificationTextColorKey                        = @"kCWStatusBarNotificationTextColorKey";
NSString *const kCWStatusBarNotificationTextAlignmentKey                    = @"kCWStatusBarNotificationTextAlignmentKey";
NSString *const kCWStatusBarNotificationTextShadowColorKey                  = @"kCWStatusBarNotificationTextShadowColorKey";
NSString *const kCWStatusBarNotificationTextShadowOffsetKey                 = @"kCWStatusBarNotificationTextShadowOffsetKey";

NSString *const kCWStatusBarNotificationBackgroundColorKey                  = @"kCWStatusBarNotificationBackgroundColorKey";
NSString *const kCWStatusBarNotificationImageKey                            = @"kCWStatusBarNotificationImageKey";

#pragma mark - Option Defaults

static CWStatusBarNotificationType              kCWNotificationTypeDefault              = CWStatusBarNotificationTypeStatusBar;
static CWStatusBarNotificationPresentationType  kCWNotificationPresentationTypeDefault  = CWStatusBarNotificationPresentationTypePush;

static CWStatusBarNotificationAnimationType     kCWAnimationTypeDefault                 = CWStatusBarNotificationAnimationTypeLinear;
static CWStatusBarNotificationAnimationStyle    kCWInAnimationStyleDefault              = CWStatusBarNotificationAnimationStyleTop;
static CWStatusBarNotificationAnimationStyle    kCWOutAnimationStyleDefault             = CWStatusBarNotificationAnimationStyleBottom;
static NSTimeInterval                           kCWAnimateInTimeIntervalDefault         = 0.25;
static NSTimeInterval                           kCWTimeIntervalDefault                  = 2.0f;
static NSTimeInterval                           kCWAnimateOutTimeIntervalDefault        = 0.25;

static CGFloat                                  kCWSpringDampingDefault                 = 0.4;
static CGFloat                                  kCWSpringInitialVelocityDefault         = 1.0;

static NSString *                               kCWTextDefault                          = @"";
static UIFont   *                               kCWFontDefault                          = nil;
static UIColor  *                               kCWTextColorDefault                     = nil;
static NSTextAlignment                          kCWTextAlignmentDefault                 = NSTextAlignmentCenter;
static UIColor  *                               kCWTextShadowColorDefault               = nil;
static CGSize                                   kCWTextShadowOffsetDefault;

static UIColor  *                               kCWBackgroundColorDefault               = nil;
static UIImage  *                               kCWImageDefault                         = nil;

#pragma mark - Layout Helper Functions

static CGFloat const CWStatusBarDefaultHeight = 44.0f;
static CGFloat const CWStatusBariPhoneLandscape = 30.0f;

static CGFloat CWGetStatusBarHeight() {
    return (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ?
    [[UIApplication sharedApplication] statusBarFrame].size.width :
    [[UIApplication sharedApplication] statusBarFrame].size.height;
}

static CGFloat CWGetStatusBarWidth() {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return [UIScreen mainScreen].bounds.size.height;
}

static CGFloat CWGetNavigationBarHeight() {
    return (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ||
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
    CWStatusBarDefaultHeight :
    CWStatusBariPhoneLandscape;
}

static CGFloat CWGetNotificationViewHeight(CWStatusBarNotificationType type) {
    switch (type) {
        case CWStatusBarNotificationTypeStatusBar:
            return CWGetStatusBarHeight();
        case CWStatusBarNotificationTypeNavigationBar:
            return CWGetStatusBarHeight() + CWGetNavigationBarHeight();
    }
}

static CGSize CWNotificationViewSize(CWStatusBarNotificationType notificationType) {
    return CGSizeMake(CWGetStatusBarWidth(), CWGetNotificationViewHeight(notificationType));
}

static CGRect CWNotificationViewFrame(CWStatusBarNotificationType type, CWStatusBarNotificationAnimationStyle style) {
    return CGRectMake(style == CWStatusBarNotificationAnimationStyleLeft ? -CWGetStatusBarWidth() : style == CWStatusBarNotificationAnimationStyleRight ? CWGetStatusBarWidth() : 0,
                      style == CWStatusBarNotificationAnimationStyleTop ? -CWGetNotificationViewHeight(type) : style == CWStatusBarNotificationAnimationStyleBottom ? CWGetNotificationViewHeight(type) : 0,
                      CWGetStatusBarWidth(),
                      CWGetNotificationViewHeight(type));
}

static CGRect CWStatusBarViewFrame(CWStatusBarNotificationType type, CWStatusBarNotificationAnimationStyle style) {
    return CWNotificationViewFrame(type,style == CWStatusBarNotificationAnimationStyleTop ? CWStatusBarNotificationAnimationStyleBottom :
                                        style == CWStatusBarNotificationAnimationStyleBottom ? CWStatusBarNotificationAnimationStyleTop :
                                        style == CWStatusBarNotificationAnimationStyleLeft ? CWStatusBarNotificationAnimationStyleRight :
                                        CWStatusBarNotificationAnimationStyleLeft);
}

@implementation CWStatusBarNotification

+ (void)initialize {
    if (self == [CWStatusBarNotification class]) {
        kCWFontDefault = [UIFont systemFontOfSize:12];
        kCWTextColorDefault = [UIColor whiteColor];
        kCWBackgroundColorDefault = [[UIApplication sharedApplication] delegate].window.tintColor;
        kCWTextShadowOffsetDefault = CGSizeZero;
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    CWStatusBarNotification *notification = [[self alloc] init];
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
    if (defaultOptions[kCWStatusBarNotificationNotificationTypeKey])                kCWNotificationTypeDefault              = [defaultOptions[kCWStatusBarNotificationNotificationTypeKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationNotificationPresentationTypeKey])    kCWNotificationPresentationTypeDefault  = [defaultOptions[kCWStatusBarNotificationNotificationPresentationTypeKey] integerValue];

    if (defaultOptions[kCWStatusBarNotificationAnimationTypeKey])                   kCWAnimationTypeDefault                 = [defaultOptions[kCWStatusBarNotificationAnimationTypeKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationAnimationInStyleKey])    kCWInAnimationStyleDefault              = [defaultOptions[kCWStatusBarNotificationAnimationInStyleKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationAnimationOutStyleKey])   kCWOutAnimationStyleDefault             = [defaultOptions[kCWStatusBarNotificationAnimationOutStyleKey] integerValue];

    if (defaultOptions[kCWStatusBarNotificationAnimationInTimeIntervalKey])           kCWAnimateInTimeIntervalDefault         = [defaultOptions[kCWStatusBarNotificationAnimationInTimeIntervalKey] doubleValue];
    if (defaultOptions[kCWStatusBarNotificationTimeIntervalKey])                    kCWTimeIntervalDefault                  = [defaultOptions[kCWStatusBarNotificationTimeIntervalKey] doubleValue];
    if (defaultOptions[kCWStatusBarNotificationAnimationOutTimeIntervalKey])          kCWAnimateOutTimeIntervalDefault        = [defaultOptions[kCWStatusBarNotificationAnimationOutTimeIntervalKey] doubleValue];
    
    if (defaultOptions[kCWStatusBarNotificationAnimationSpringDampingKey])            kCWSpringDampingDefault                 = [defaultOptions[kCWStatusBarNotificationAnimationSpringDampingKey] floatValue];
    if (defaultOptions[kCWStatusBarNotificationAnimationSpringInitialVelocityKey])    kCWSpringInitialVelocityDefault         = [defaultOptions[kCWStatusBarNotificationAnimationSpringInitialVelocityKey] floatValue];
    
    if (defaultOptions[kCWStatusBarNotificationTextKey])                            kCWTextDefault                          = defaultOptions[kCWStatusBarNotificationTextKey];
    if (defaultOptions[kCWStatusBarNotificationFontKey])                            kCWFontDefault                          = defaultOptions[kCWStatusBarNotificationFontKey];
    if (defaultOptions[kCWStatusBarNotificationTextColorKey])                       kCWTextColorDefault                     = defaultOptions[kCWStatusBarNotificationTextColorKey];
    if (defaultOptions[kCWStatusBarNotificationTextAlignmentKey])                   kCWTextAlignmentDefault                 = [defaultOptions[kCWStatusBarNotificationTextAlignmentKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationTextShadowColorKey])                 kCWTextShadowColorDefault               = defaultOptions[kCWStatusBarNotificationTextShadowColorKey];
    if (defaultOptions[kCWStatusBarNotificationTextShadowOffsetKey])                kCWTextShadowOffsetDefault              = [defaultOptions[kCWStatusBarNotificationTextShadowOffsetKey] CGSizeValue];
    
    if (defaultOptions[kCWStatusBarNotificationBackgroundColorKey])                 kCWBackgroundColorDefault               = defaultOptions[kCWStatusBarNotificationBackgroundColorKey];
    if (defaultOptions[kCWStatusBarNotificationImageKey])                           kCWImageDefault                         = defaultOptions[kCWStatusBarNotificationImageKey];
}

#pragma mark - Notification View Helpers

- (UIView*)notificationView {
    CGSize size = CWNotificationViewSize(self.notificationType);
    CWStatusBarNotificationView *notificationView = [[CWStatusBarNotificationView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    notificationView.label.text = self.text;
    notificationView.label.font = self.font;
    notificationView.label.textColor = self.textColor;
    notificationView.label.textAlignment = self.textAlignment;
    notificationView.backgroundColor = self.backgroundColor;
    notificationView.image = self.image;
    return notificationView;
}

- (CGRect)notificationViewAnimationFrame1 {
    return CWNotificationViewFrame(self.notificationType, self.inAnimationStyle);
}

- (CGRect)notificationViewAnimationFrame2 {
    return CWNotificationViewFrame(self.notificationType, self.outAnimationStyle);
}

- (UIView*)statusBarView {
    UIView *statusBarView = [[UIView alloc] initWithFrame:self.statusBarViewAnimationFrame1];
    [statusBarView addSubview:[[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES]];
    statusBarView.clipsToBounds = YES;
    return statusBarView;
}

- (CGRect)statusBarViewAnimationFrame1 {
    return CWStatusBarViewFrame(self.notificationType, self.inAnimationStyle);
}

- (CGRect)statusBarViewAnimationFrame2 {
    return CWStatusBarViewFrame(self.notificationType, self.outAnimationStyle);
}

#pragma mark - Overrides

- (CWStatusBarNotificationType)notificationType {
    return _options[kCWStatusBarNotificationNotificationTypeKey] ?
    [self.options[kCWStatusBarNotificationNotificationTypeKey] integerValue] :
    kCWNotificationTypeDefault;
}

- (CWStatusBarNotificationPresentationType)presentationType {
    return _options[kCWStatusBarNotificationNotificationPresentationTypeKey] ?
    [self.options[kCWStatusBarNotificationNotificationPresentationTypeKey] integerValue] :
    kCWNotificationPresentationTypeDefault;
}

- (CWStatusBarNotificationAnimationType)animationType {
    return _options[kCWStatusBarNotificationAnimationTypeKey] ?
    [_options[kCWStatusBarNotificationAnimationTypeKey] integerValue] :
    kCWAnimationTypeDefault;
}

- (CWStatusBarNotificationAnimationStyle)inAnimationStyle {
    return _options[kCWStatusBarNotificationAnimationInStyleKey] ?
    [_options[kCWStatusBarNotificationAnimationInStyleKey] integerValue] :
    kCWInAnimationStyleDefault;
}

- (CWStatusBarNotificationAnimationStyle)outAnimationStyle {
    return _options[kCWStatusBarNotificationAnimationInStyleKey] ?
    [_options[kCWStatusBarNotificationAnimationOutStyleKey] integerValue] :
    kCWOutAnimationStyleDefault;
}

- (NSTimeInterval)animateInTimeInterval {
    return _options[kCWStatusBarNotificationAnimationInTimeIntervalKey] ?
    [_options[kCWStatusBarNotificationAnimationInTimeIntervalKey] doubleValue] :
    kCWAnimateInTimeIntervalDefault;
}

- (NSTimeInterval)timeInterval {
    return _options[kCWStatusBarNotificationTimeIntervalKey] ?
    [_options[kCWStatusBarNotificationTimeIntervalKey] doubleValue] :
    kCWTimeIntervalDefault;
}

- (NSTimeInterval)animateOutTimeInterval {
    return _options[kCWStatusBarNotificationAnimationOutTimeIntervalKey] ?
    [_options[kCWStatusBarNotificationAnimationOutTimeIntervalKey] doubleValue] :
    kCWAnimateOutTimeIntervalDefault;
}

- (CGFloat)animationInitialVelocity {
    return _options[kCWStatusBarNotificationAnimationSpringInitialVelocityKey] ?
    [_options[kCWStatusBarNotificationAnimationSpringInitialVelocityKey] floatValue] :
    kCWSpringInitialVelocityDefault;
}

- (CGFloat)animationSpringDamping {
    return _options[kCWStatusBarNotificationAnimationSpringDampingKey] ?
    [_options[kCWStatusBarNotificationAnimationSpringDampingKey] floatValue] :
    kCWSpringDampingDefault;
}

- (NSString*)text {
    return _options[kCWStatusBarNotificationTextKey] ?: kCWTextDefault;
}

- (UIFont*)font {
    return _options[kCWStatusBarNotificationFontKey] ?: kCWFontDefault;
}

- (UIColor*)textColor {
    return _options[kCWStatusBarNotificationTextColorKey] ?: kCWTextColorDefault;
}

- (NSTextAlignment)textAlignment {
    return _options[kCWStatusBarNotificationTextAlignmentKey] ? [_options[kCWStatusBarNotificationTextAlignmentKey] integerValue] : kCWTextAlignmentDefault;
}

- (UIColor*)textShadowColor {
    return _options[kCWStatusBarNotificationTextShadowColorKey] ?: kCWTextShadowColorDefault;
}

- (CGSize)textShadowOffset {
    return _options[kCWStatusBarNotificationTextShadowOffsetKey] ?
    [_options[kCWStatusBarNotificationTextShadowOffsetKey] CGSizeValue]:
    kCWTextShadowOffsetDefault;
}

- (UIColor*)backgroundColor {
    return _options[kCWStatusBarNotificationBackgroundColorKey] ?: kCWBackgroundColorDefault;
}

- (UIImage*)image {
    return _options[kCWStatusBarNotificationImageKey] ?: kCWImageDefault;
}

@end

#pragma mark - CWStatusBarNotificationManager

@interface CWStatusBarNotificationManager ()
@property (nonatomic, readonly) BOOL showingNotification;
@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic, strong) NSMutableArray *notifications;
@end

@implementation CWStatusBarNotificationManager

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    [CWStatusBarNotification setDefaultOptions:defaultOptions];
}

+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    [[CWStatusBarNotificationManager manager] addNotification:[CWStatusBarNotification notificationWithOptions:options
                                                                                               completionBlock:completion]];
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

- (void)addNotification:(CWStatusBarNotification*)notification {
    BOOL showingNotification = self.showingNotification;
    [_notifications addObject:notification];
    if (!showingNotification) {
        [self displayNotification:notification];
    }
}

- (void)displayNotification:(CWStatusBarNotification*)notification {
    _notificationWindow.hidden = NO;
    CGSize notificationSize = CWNotificationViewSize(notification.notificationType);
    _notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);

    UIView *statusBarView = notification.statusBarView;
    statusBarView.frame = _notificationWindow.rootViewController.view.bounds;
    [_notificationWindow.rootViewController.view addSubview:statusBarView];
    statusBarView.hidden = notification.presentationType == CWStatusBarNotificationPresentationTypeCover;
    
    UIView *notificationView = notification.notificationView;
    notificationView.frame = notification.notificationViewAnimationFrame1;
    [_notificationWindow.rootViewController.view addSubview:notificationView];
    __weak typeof(self) weakSelf = self;
    
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
            CWStatusBarNotification *notification = weakSelf.notifications.firstObject;
            [weakSelf displayNotification:notification];
        } else {
            weakSelf.notificationWindow.hidden = YES;
        }
    };
    
    void (^inwardAnimationsCompletionBlock)(BOOL) = ^void(BOOL finished) {
        statusBarView.frame = notification.statusBarViewAnimationFrame2;
        if (notification.animationType == CWStatusBarNotificationAnimationTypeLinear) {
            [UIView animateWithDuration:notification.animateOutTimeInterval
                                  delay:notification.timeInterval
                                options:0
                             animations:outwardAnimationsBlock
                             completion:outwardAnimationsCompletionBlock];
        } else if (notification.animationType == CWStatusBarNotificationAnimationTypeSpring) {
            [UIView animateWithDuration:notification.animateOutTimeInterval
                                  delay:notification.timeInterval
                 usingSpringWithDamping:notification.animationSpringDamping
                  initialSpringVelocity:notification.animationInitialVelocity
                                options:0
                             animations:outwardAnimationsBlock
                             completion:outwardAnimationsCompletionBlock];
            
        }
    };
    
    if (notification.animationType == CWStatusBarNotificationAnimationTypeLinear) {
        [UIView animateWithDuration:notification.animateInTimeInterval
                         animations:inwardAnimationsBlock
                         completion:inwardAnimationsCompletionBlock];

    } else if (notification.animationType == CWStatusBarNotificationAnimationTypeSpring) {
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