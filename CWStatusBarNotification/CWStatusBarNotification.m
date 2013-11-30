//
//  CWStatusBarNotification.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CWStatusBarNotification.h"

@interface CWStatusBarNotificationView : UIView
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) NSString *text;
@end

@interface CWStatusBarNotificationView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

static CGFloat const kCWStatusBarNotificationImageRightMagin = 10;
static CGFloat const kCWStatusBarNotificationLabelLeftMargin = kCWStatusBarNotificationImageRightMagin;
static CGFloat const kCWStatusBarNotificationLabelRightMargin = 10;

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
    self.label.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)+kCWStatusBarNotificationImageRightMagin,
                                  0,
                                  CGRectGetWidth(bounds)-CGRectGetMaxX(_imageView.frame)-kCWStatusBarNotificationImageRightMagin-kCWStatusBarNotificationLabelRightMargin,
                                  CGRectGetHeight(bounds));
}

#pragma mark - Overrides

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self setNeedsLayout];
}

- (UIImage*)image {
    return self.imageView.image;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    [self setNeedsLayout];
}

- (NSString*)text {
    return self.label.text;
    [self setNeedsLayout];
}

@end

#pragma mark - Option Constant Definitions

NSString *const kCWStatusBarNotificationNotificationTypeKey               = @"kSFCWStatusBarNotificationNotificationTypeKey";
NSString *const kCWStatusBarNotificationNotificationInAnimationStyleKey   = @"kSFCWStatusBarNotificationNotificationInAnimationStyleKey";
NSString *const kCWStatusBarNotificationNotificationOutAnimationStyleKey  = @"kSFCWStatusBarNotificationNotificationOutAnimationStyleKey";
NSString *const kCWStatusBarNotificationTimeIntervalKey                   = @"kSFCWStatusBarNotificationTimeIntervalKey";
NSString *const kCWStatusBarNotificationFontKey                           = @"kSFCWStatusBarNotificationFontKey";
NSString *const kCWStatusBarNotificationTextColorKey                      = @"kSFCWStatusBarNotificationTextColorKey";
NSString *const kCWStatusBarNotificationBackgroundColorKey                = @"kSFCWStatusBarNotificationBackgroundColorKey";
NSString *const kCWStatusBarNotificationTextKey                           = @"kSFCWStatusBarNotificationTextKey";
NSString *const kCWStatusBarNotificationImageKey                          = @"kSFCWStatusBarNotificationImageKey";

#pragma mark - Option Defaults

static CWStatusBarNotificationType kCWNotificationTypeDefault = CWStatusBarNotificationTypeStatusBar;
static CWStatusBarNotificationAnimationStyle kCWInAnimationStyleDefault = CWStatusBarNotificationAnimationStyleTop;
static CWStatusBarNotificationAnimationStyle kCWOutAnimationStyleDefault = CWStatusBarNotificationAnimationStyleBottom;
static NSTimeInterval kCWTimeIntervalDefault = 2.0f;
static UIFont  *kCWFontDefault;
static UIColor *kCWTextColorDefault;
static UIColor *kCWBackgroundColorDefault;
static NSString *kCWTextDefault = @"";
static UIImage *kCWImageDefault = nil;

@interface CWStatusBarNotification : NSObject

@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, copy) void(^completion)(void);
@property (nonatomic, readonly) UIView *notificationView;

@property (nonatomic, readonly) CWStatusBarNotificationType notificationType;
@property (nonatomic, readonly) CWStatusBarNotificationAnimationStyle inAnimationStyle;
@property (nonatomic, readonly) CWStatusBarNotificationAnimationStyle outAnimationStyle;
@property (nonatomic, readonly) NSTimeInterval timeInterval;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) CGRect prepareToAnimateInFrame;
@property (nonatomic, readonly) CGRect animatedOutFrame;

@end

static CGFloat const CWStatusBarDefaultHeight = 44.0f;
static CGFloat const CWStatusBariPhoneLandscape = 30.0f;

static CGFloat const CWDefaultFontSize = 12.0f;

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

static CGFloat CWGetNotificationLabelHeight(CWStatusBarNotificationType notificationStyle) {
    switch (notificationStyle) {
        case CWStatusBarNotificationTypeStatusBar:
            return CWGetStatusBarHeight();
        case CWStatusBarNotificationTypeNavigationBar:
            return CWGetStatusBarHeight() + CWGetNavigationBarHeight();
        default:
            return CWGetStatusBarHeight();
    }
}

static CGRect CWGetNotificationLabelTopFrame(CWStatusBarNotificationType notificationStyle) {
    return CGRectMake(0, -1*CWGetNotificationLabelHeight(notificationStyle), CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelLeftFrame(CWStatusBarNotificationType notificationStyle) {
    return CGRectMake(-1*CWGetStatusBarWidth(), 0, CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelRightFrame(CWStatusBarNotificationType notificationStyle) {
    return CGRectMake(CWGetStatusBarWidth(), 0, CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGRect CWGetNotificationLabelBottomFrame(CWStatusBarNotificationType notificationStyle) {
    return CGRectMake(0, CWGetNotificationLabelHeight(notificationStyle), CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationStyle));
}

static CGSize CWNotificationViewSize(CWStatusBarNotificationType notificationType) {
    return CGSizeMake(CWGetStatusBarWidth(), CWGetNotificationLabelHeight(notificationType));
}

static CGRect CWNotificationViewFrame(CWStatusBarNotificationType type, CWStatusBarNotificationAnimationStyle style) {
    switch (style) {
        case CWStatusBarNotificationAnimationStyleTop:
            return CWGetNotificationLabelTopFrame(type);
        case CWStatusBarNotificationAnimationStyleLeft:
            return CWGetNotificationLabelLeftFrame(type);
        case CWStatusBarNotificationAnimationStyleBottom:
            return CWGetNotificationLabelBottomFrame(type);
        case CWStatusBarNotificationAnimationStyleRight:
            return CWGetNotificationLabelRightFrame(type);
    }
}

@implementation CWStatusBarNotification

+ (void)initialize {
    if (self == [CWStatusBarNotification class]) {
        kCWFontDefault = [UIFont systemFontOfSize:12];
        kCWTextColorDefault = [UIColor whiteColor];
        kCWBackgroundColorDefault = [[UIApplication sharedApplication] delegate].window.tintColor;
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
    if (defaultOptions[kCWStatusBarNotificationNotificationTypeKey]) kCWNotificationTypeDefault = [defaultOptions[kCWStatusBarNotificationNotificationTypeKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationNotificationInAnimationStyleKey]) kCWInAnimationStyleDefault = [defaultOptions[kCWStatusBarNotificationNotificationInAnimationStyleKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationNotificationOutAnimationStyleKey]) kCWOutAnimationStyleDefault = [defaultOptions[kCWStatusBarNotificationNotificationOutAnimationStyleKey] integerValue];
    if (defaultOptions[kCWStatusBarNotificationTimeIntervalKey]) kCWTimeIntervalDefault = [defaultOptions[kCWStatusBarNotificationTimeIntervalKey] doubleValue];
    if (defaultOptions[kCWStatusBarNotificationFontKey]) kCWFontDefault = defaultOptions[kCWStatusBarNotificationFontKey];
    if (defaultOptions[kCWStatusBarNotificationTextColorKey]) kCWTextColorDefault = defaultOptions[kCWStatusBarNotificationTextColorKey];
    if (defaultOptions[kCWStatusBarNotificationBackgroundColorKey]) kCWBackgroundColorDefault = defaultOptions[kCWStatusBarNotificationBackgroundColorKey];
    if (defaultOptions[kCWStatusBarNotificationTextKey]) kCWTextDefault = defaultOptions[kCWStatusBarNotificationTextKey];
    if (defaultOptions[kCWStatusBarNotificationImageKey]) kCWImageDefault = defaultOptions[kCWStatusBarNotificationImageKey];
}

#pragma mark - Overrides

- (CWStatusBarNotificationType)notificationType {
    return _options[kCWStatusBarNotificationNotificationTypeKey] ?
    [self.options[kCWStatusBarNotificationNotificationTypeKey] integerValue] :
    kCWNotificationTypeDefault;
}

- (CWStatusBarNotificationAnimationStyle)inAnimationStyle {
    return _options[kCWStatusBarNotificationNotificationInAnimationStyleKey] ?
    [_options[kCWStatusBarNotificationNotificationInAnimationStyleKey] integerValue] :
    kCWInAnimationStyleDefault;
}

- (CWStatusBarNotificationAnimationStyle)outAnimationStyle {
    return _options[kCWStatusBarNotificationNotificationInAnimationStyleKey] ?
    [_options[kCWStatusBarNotificationNotificationOutAnimationStyleKey] integerValue] :
    kCWOutAnimationStyleDefault;
}

- (NSTimeInterval)timeInterval {
    return _options[kCWStatusBarNotificationTimeIntervalKey] ?
    [_options[kCWStatusBarNotificationTimeIntervalKey] doubleValue] :
    kCWTimeIntervalDefault;
}

- (UIFont*)font {
    return _options[kCWStatusBarNotificationFontKey] ?: kCWFontDefault;
}

- (UIColor*)textColor {
    return _options[kCWStatusBarNotificationTextColorKey] ?: kCWTextColorDefault;
}

- (UIColor*)backgroundColor {
    return _options[kCWStatusBarNotificationBackgroundColorKey] ?: kCWBackgroundColorDefault;
}

- (NSString*)text {
    return _options[kCWStatusBarNotificationTextKey] ?: kCWTextDefault;
}

- (NSString*)image {
    return _options[kCWStatusBarNotificationImageKey] ?: kCWImageDefault;
}

- (UIView*)notificationView {
    if (self.notificationType == CWStatusBarNotificationTypeStatusBar) {
        return nil;
    } else {
        CGSize size = CWNotificationViewSize(self.notificationType);
        CWStatusBarNotificationView *notificationView = [[CWStatusBarNotificationView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        notificationView.label.text = self.text;
        notificationView.label.font = self.font;
        notificationView.label.textColor = self.textColor;
        notificationView.backgroundColor = self.backgroundColor;
        notificationView.image = self.image;
        return notificationView;
    }
}

- (CGRect)prepareToAnimateInFrame {
    return CWNotificationViewFrame(self.notificationType, self.inAnimationStyle);
}

- (CGRect)animatedOutFrame {
    return CWNotificationViewFrame(self.notificationType, self.outAnimationStyle);
}

//
//- (CWStatusBarNotification *)init {
//    self = [super init];
//    if (self) {
//        // set defaults
//        self.notificationLabelBackgroundColor = [[UIApplication sharedApplication] delegate].window.tintColor;
//        self.notificationLabelTextColor = [UIColor whiteColor];
//        self.notificationStyle = CWNotificationStyleStatusBarNotification;
//        self.notificationAnimationInStyle = CWStatusBarNotificationAnimationStyleBottom;
//        self.notificationAnimationOutStyle = CWStatusBarNotificationAnimationStyleBottom;
//    }
//    return self;
//}
//
//# pragma mark - screen orientation change
//
//- (void)screenOrientationChanged {
//    self.notificationLabel.frame = CWGetNotificationLabelFrame(self.notificationStyle);
//    self.statusBarView.hidden = YES;
//}
//
//# pragma mark - display helpers
//
//- (void)createNotificationLabelWithMessage:(NSString *)message
//{
//    self.notificationLabel = [UILabel new];
//    self.notificationLabel.text = message;
//    self.notificationLabel.textAlignment = NSTextAlignmentCenter;
//    self.notificationLabel.adjustsFontSizeToFitWidth = YES;
//    self.notificationLabel.font = [UIFont systemFontOfSize:CWDefaultFontSize];
//    self.notificationLabel.backgroundColor = self.notificationLabelBackgroundColor;
//    self.notificationLabel.textColor = self.notificationLabelTextColor;
//    switch (self.notificationAnimationInStyle) {
//        case CWStatusBarNotificationAnimationStyleTop:
//            self.notificationLabel.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleBottom:
//            self.notificationLabel.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleLeft:
//            self.notificationLabel.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleRight:
//            self.notificationLabel.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
//            break;
//            
//    }
//}
//
//- (void)createNotificationWindow
//{
//    self.notificationWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.notificationWindow.backgroundColor = [UIColor clearColor];
//    self.notificationWindow.userInteractionEnabled = NO;
//    self.notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.notificationWindow.windowLevel = UIWindowLevelStatusBar;
//    self.notificationWindow.rootViewController = [UIViewController new];
//    self.notificationWindow.rootViewController.view.bounds = CWGetNotificationLabelFrame(self.notificationStyle);
//}
//
//- (void)createStatusBarView
//{
//    self.statusBarView = [[UIView alloc] initWithFrame:CWGetNotificationLabelFrame(self.notificationStyle)];
//    self.statusBarView.clipsToBounds = YES;
//    UIView *statusBarImageView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
//    [self.statusBarView addSubview:statusBarImageView];
//    [self.notificationWindow.rootViewController.view addSubview:self.statusBarView];
//    [self.notificationWindow.rootViewController.view sendSubviewToBack:self.statusBarView];
//}
//
//# pragma mark - frame changing
//
//- (void)firstFrameChange
//{
//    self.notificationLabel.frame = CWGetNotificationLabelFrame(self.notificationStyle);
//    switch (self.notificationAnimationInStyle) {
//        case CWStatusBarNotificationAnimationStyleTop:
//            self.statusBarView.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleBottom:
//            self.statusBarView.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleLeft:
//            self.statusBarView.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleRight:
//            self.statusBarView.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
//            break;
//    }
//}
//
//- (void)secondFrameChange
//{
//    switch (self.notificationAnimationOutStyle) {
//        case CWStatusBarNotificationAnimationStyleTop:
//            self.statusBarView.frame = CWGetNotificationLabelBottomFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleBottom:
//            self.statusBarView.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
//            self.notificationLabel.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
//            self.notificationLabel.center = CGPointMake(self.notificationLabel.center.x, CWGetNotificationLabelHeight(self.notificationStyle));
//            break;
//        case CWStatusBarNotificationAnimationStyleLeft:
//            self.statusBarView.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleRight:
//            self.statusBarView.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
//            break;
//    }
//}
//
//- (void)thirdFrameChange
//{
//    self.statusBarView.frame = CWGetNotificationLabelFrame(self.notificationStyle);
//    switch (self.notificationAnimationOutStyle) {
//        case CWStatusBarNotificationAnimationStyleTop:
//            self.notificationLabel.frame = CWGetNotificationLabelTopFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleBottom:
//            self.notificationLabel.transform = CGAffineTransformMakeScale(1.0f, 0.0f);
//            break;
//        case CWStatusBarNotificationAnimationStyleLeft:
//            self.notificationLabel.frame = CWGetNotificationLabelLeftFrame(self.notificationStyle);
//            break;
//        case CWStatusBarNotificationAnimationStyleRight:
//            self.notificationLabel.frame = CWGetNotificationLabelRightFrame(self.notificationStyle);
//            break;
//    }
//}
//
//# pragma mark - display notification
//
//- (void)displayNotificationWithMessage:(NSString *)message completion:(void (^)(void))completion
//{
//    if (!self.notificationIsShowing) {
//        self.notificationIsShowing = YES;
//        
//        // create UIWindow
//        [self createNotificationWindow];
//        
//        // create UILabel
//        [self createNotificationLabelWithMessage:message];
//        
//        // create status bar view
//        [self createStatusBarView];
//        
//        // add label to window
//        [self.notificationWindow.rootViewController.view addSubview:self.notificationLabel];
//        [self.notificationWindow.rootViewController.view bringSubviewToFront:self.notificationLabel];
//        [self.notificationWindow setHidden:NO];
//        
//        // checking for screen orientation change
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenOrientationChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//        
//        // animate
//        [UIView animateWithDuration:CWStatusBarAnimationLength animations:^{
//            [self firstFrameChange];
//        } completion:^(BOOL finished) {
//            [completion invoke];
//        }];
//    }
//
//}
//
//- (void)dismissNotification
//{
//    if (self.notificationIsShowing) {
//        [self secondFrameChange];
//        [UIView animateWithDuration:CWStatusBarAnimationLength animations:^{
//            [self thirdFrameChange];
//        } completion:^(BOOL finished) {
//            [self.notificationLabel removeFromSuperview];
//            [self.statusBarView removeFromSuperview];
//            self.notificationWindow = nil;
//            self.notificationIsShowing = NO;
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//        }];
//    }
//}
//
//- (void)displayNotificationWithMessage:(NSString *)message forDuration:(CGFloat)duration
//{
//    [self displayNotificationWithMessage:message completion:^{
//        double delayInSeconds = duration;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self dismissNotification];
//        });
//    }];
//}

@end

@interface CWStatusBarNotificationManager ()
@property (nonatomic, readonly) BOOL showingNotification;
@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic, strong) NSMutableArray *notifications;
@end

static UIView *CWStatusBarScreenshot() {
    return [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
}

@implementation CWStatusBarNotificationManager

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

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    [CWStatusBarNotification setDefaultOptions:defaultOptions];
}

+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    [[CWStatusBarNotificationManager manager] addNotification:[CWStatusBarNotification notificationWithOptions:options
                                                                                               completionBlock:completion]];
}

#pragma mark - Notification Management

- (void)addNotification:(CWStatusBarNotification*)notification {
    BOOL showingNotification = self.showingNotification;
    [_notifications addObject:notification];
    if (!showingNotification) {
        [self displayNotification:notification];
    }
}

- (void)prepareToShowNotification {
    [_notificationWindow.rootViewController.view addSubview:CWStatusBarScreenshot()];
    _notificationWindow.hidden = NO;
}

- (void)displayNotification:(CWStatusBarNotification*)notification {
    [self prepareToShowNotification];
    CGSize notificationSize = CWNotificationViewSize(notification.notificationType);
    _notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    UIView *notificationView = notification.notificationView;
    notificationView.frame = notification.prepareToAnimateInFrame;
    [_notificationWindow.rootViewController.view addSubview:notificationView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         notificationView.frame = _notificationWindow.rootViewController.view.bounds;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                               delay:notification.timeInterval
                                             options:0
                                          animations:^{
                                              notificationView.frame = notification.animatedOutFrame;
                                          }
                                          completion:^(BOOL finished) {
                                              if (notification.completion) notification.completion();
                                              [weakSelf.notifications removeObject:notification];
                                              if (weakSelf.notifications.count > 0) {
                                                  CWStatusBarNotification *notification = weakSelf.notifications.firstObject;
                                                  [weakSelf  displayNotification:notification];
                                              } else {
                                                  for (UIView *view in _notificationWindow.rootViewController.view.subviews) {
                                                      [view removeFromSuperview];
                                                  }
                                              }
                                          }];
                     }];
}

#pragma mark - Overrides

- (BOOL)showingNotification {;
    return self.notifications.count > 0;
}

@end