//
//  CRToast.m
//  CRNotificationDemo
//
//

#import <QuartzCore/QuartzCore.h>
#import "CRToast.h"

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

@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) CGVector inGravityDirection;
@property (nonatomic, readonly) CGVector outGravityDirection;

@property (nonatomic, readonly) CGPoint inCollisionPoint1;
@property (nonatomic, readonly) CGPoint inCollisionPoint2;
@property (nonatomic, readonly) CGPoint outCollisionPoint1;
@property (nonatomic, readonly) CGPoint outCollisionPoint2;


@end

@interface CRToastView : UIView
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

NSString *const kCRToastBackgroundColorKey                  = @"kCRToastBackgroundColorKey";
NSString *const kCRToastImageKey                            = @"kCRToastImageKey";

#pragma mark - Option Defaults

static CRToastType                  kCRNotificationTypeDefault              = CRToastTypeStatusBar;
static CRToastPresentationType      kCRNotificationPresentationTypeDefault  = CRToastPresentationTypePush;

static BOOL                         kCRUnderStatusBarDefault                = NO;

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

static NSString *                   kCRSubtitleTextDefault                          = nil;
static UIFont   *                   kCRSubtitleFontDefault                          = nil;
static UIColor  *               	kCRSubtitleTextColorDefault                     = nil;
static NSTextAlignment          	kCRSubtitleTextAlignmentDefault                 = NSTextAlignmentCenter;
static UIColor  *               	kCRSubtitleTextShadowColorDefault               = nil;
static CGSize                   	kCRSubtitleTextShadowOffsetDefault;
static NSInteger                    kCRSubtitleTextMaxNumberOfLinesDefault          = 0;

static UIColor  *                   kCRBackgroundColorDefault               = nil;
static UIImage  *                   kCRImageDefault                         = nil;

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

static CGRect CRStatusBarViewFrame(CRToastType type, CRToastAnimationDirection direction) {
    return CRNotificationViewFrame(type,direction == CRToastAnimationDirectionTop ? CRToastAnimationDirectionBottom :
                                   direction == CRToastAnimationDirectionBottom ? CRToastAnimationDirectionTop :
                                   direction == CRToastAnimationDirectionLeft ? CRToastAnimationDirectionRight :
                                   CRToastAnimationDirectionLeft);
}

@implementation CRToast

+ (void)initialize {
    if (self == [CRToast class]) {
        kCRFontDefault = [UIFont systemFontOfSize:12];
        kCRTextColorDefault = [UIColor whiteColor];
        kCRBackgroundColorDefault = [[UIApplication sharedApplication] delegate].window.tintColor;
        kCRTextShadowOffsetDefault = CGSizeZero;
        
        kCRSubtitleFontDefault = [UIFont systemFontOfSize:12];
        kCRSubtitleTextColorDefault = [UIColor whiteColor];
        kCRSubtitleTextShadowOffsetDefault = CGSizeZero;
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    CRToast *notification = [[self alloc] init];
    notification.options = options;
    notification.completion = completion;
    return notification;
}

+ (instancetype)sharedNotification {
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
    
    if (defaultOptions[kCRToastUnderStatusBarKey])                  kCRUnderStatusBarDefault                = [defaultOptions[kCRToastUnderStatusBarKey] boolValue];
    
    if (defaultOptions[kCRToastAnimationInTypeKey])                 kCRAnimationTypeDefaultIn               = [defaultOptions[kCRToastAnimationInTypeKey] integerValue];
    if (defaultOptions[kCRToastAnimationOutTypeKey])                kCRAnimationTypeDefaultOut              = [defaultOptions[kCRToastAnimationOutTypeKey] integerValue];
    if (defaultOptions[kCRToastAnimationInDirectionKey])            kCRInAnimationDirectionDefault              = [defaultOptions[kCRToastAnimationInDirectionKey] integerValue];
    if (defaultOptions[kCRToastAnimationOutDirectionKey])           kCROutAnimationDirectionDefault             = [defaultOptions[kCRToastAnimationOutDirectionKey] integerValue];
    
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
    
    if (defaultOptions[kCRToastSubtitleTextKey])                            kCRSubtitleTextDefault                          = defaultOptions[kCRToastSubtitleTextKey];
    if (defaultOptions[kCRToastSubtitleFontKey])                            kCRSubtitleFontDefault                          = defaultOptions[kCRToastSubtitleFontKey];
    if (defaultOptions[kCRToastSubtitleTextColorKey])                       kCRSubtitleTextColorDefault                     = defaultOptions[kCRToastSubtitleTextColorKey];
    if (defaultOptions[kCRToastSubtitleTextAlignmentKey])                   kCRSubtitleTextAlignmentDefault                 = [defaultOptions[kCRToastSubtitleTextAlignmentKey] integerValue];
    if (defaultOptions[kCRToastSubtitleTextShadowColorKey])                 kCRSubtitleTextShadowColorDefault               = defaultOptions[kCRToastSubtitleTextShadowColorKey];
    if (defaultOptions[kCRToastSubtitleTextShadowOffsetKey])                kCRSubtitleTextShadowOffsetDefault              = [defaultOptions[kCRToastSubtitleTextShadowOffsetKey] CGSizeValue];
    if (defaultOptions[kCRToastSubtitleTextMaxNumberOfLinesKey])            kCRSubtitleTextMaxNumberOfLinesDefault          = [defaultOptions[kCRToastSubtitleTextMaxNumberOfLinesKey] integerValue];
    
    if (defaultOptions[kCRToastBackgroundColorKey])                 kCRBackgroundColorDefault               = defaultOptions[kCRToastBackgroundColorKey];
    if (defaultOptions[kCRToastImageKey])                           kCRImageDefault                         = defaultOptions[kCRToastImageKey];
}

#pragma mark - Notification View Helpers

- (UIView*)notificationView {
    CGSize size = CRNotificationViewSize(self.notificationType);
    CRToastView *notificationView = [[CRToastView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    notificationView.toast = self;
    return notificationView;
}

- (CGRect)notificationViewAnimationFrame1 {
    return CRNotificationViewFrame(self.notificationType, self.inAnimationDirection);
}

- (CGRect)notificationViewAnimationFrame2 {
    return CRNotificationViewFrame(self.notificationType, self.outAnimationDirection);
}

- (UIView*)statusBarView {
    UIView *statusBarView = [[UIView alloc] initWithFrame:self.statusBarViewAnimationFrame1];
    if ([self underStatusBar]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIGraphicsBeginImageContextWithOptions(window.frame.size, NO, 0);
        CGRect rect = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
        [window drawViewHierarchyInRect:rect afterScreenUpdates:YES];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
        [statusBarView addSubview:imageView];
    }
    else {
        [statusBarView addSubview:[[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES]];
    }
    statusBarView.clipsToBounds = YES;
    return statusBarView;
}

- (CGRect)statusBarViewAnimationFrame1 {
    return CRStatusBarViewFrame(self.notificationType, self.inAnimationDirection);
}

- (CGRect)statusBarViewAnimationFrame2 {
    return CRStatusBarViewFrame(self.notificationType, self.outAnimationDirection);
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

- (BOOL)underStatusBar {
    return _options[kCRToastUnderStatusBarKey] ?
    [self.options[kCRToastUnderStatusBarKey] boolValue] :
    kCRUnderStatusBarDefault;
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

@end

#pragma mark - CRToastView

@interface CRToastView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

static CGFloat const kCRStatusBarViewNoImageLeftContentInset = 10;
static CGFloat const kCRStatusBarViewNoImageRightContentInset = 10;

@implementation CRToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.label = label;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGSize imageSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0,
                                      0,
                                      imageSize.width == 0 ?
                                        0 :
                                        CGRectGetHeight(bounds),
                                      imageSize.height == 0 ?
                                        0 :
                                        CGRectGetHeight(bounds));
    CGFloat x = imageSize.width == 0 ? kCRStatusBarViewNoImageLeftContentInset : CGRectGetMaxX(_imageView.frame);
    CGFloat width = CGRectGetWidth(bounds)-x-kCRStatusBarViewNoImageRightContentInset;
    
    if (self.toast.subtitleText == nil) {
        self.label.frame = CGRectMake(x,
                                      0,
                                      width,
                                      CGRectGetHeight(bounds));
    } else {
        CGFloat height = [self.toast.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                                 NSFontAttributeName : self.toast.font
                                                 }
                                      context:nil].size.height;
        CGFloat subtitleHeight = [self.toast.subtitleText boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{
                                                                 NSFontAttributeName : self.toast.subtitleFont
                                                                 }
                                                       context:nil].size.height;
        
        CGFloat offset = (CGRectGetHeight(bounds) - (height + subtitleHeight))/2;
        
        self.label.frame = CGRectMake(x,
                                      offset,
                                      CGRectGetWidth(bounds)-x-kCRStatusBarViewNoImageRightContentInset,
                                      height);

        self.subtitleLabel.frame = CGRectMake(x,
                                  height+offset,
                                  CGRectGetWidth(bounds)-x-kCRStatusBarViewNoImageRightContentInset,
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

#pragma mark - CRToastManager

@interface CRToastManager () <UICollisionBehaviorDelegate>
@property (nonatomic, readonly) BOOL showingNotification;
@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, retain) UIDynamicAnimator *animator;
@property (nonatomic, copy) void (^gravityAnimationCompletionBlock)(BOOL finished);
@end

static NSString *const kCRToastManagerCollisionBoundryIdentifier = @"kCRToastManagerCollisionBoundryIdentifier";

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

- (instancetype)init {
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
        
        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:notificationWindow.rootViewController.view];
        self.animator = animator;
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
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        _notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, notificationSize.height, notificationSize.width);
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        _notificationWindow.rootViewController.view.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-notificationSize.height, 0, notificationSize.height, notificationSize.width);
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _notificationWindow.rootViewController.view.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height, notificationSize.width, notificationSize.height);
    } else {
        _notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, notificationSize.width, notificationSize.height);
    }
    
    _notificationWindow.windowLevel = notification.underStatusBar ? UIWindowLevelNormal : UIWindowLevelStatusBar;
    
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
    
    __weak __block typeof(self) blockSelf = self;
    void (^outwardAnimationsBlock)(void) = ^void(void) {
        [blockSelf.animator removeAllBehaviors];
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
        switch (notification.outAnimationType) {
            case CRToastAnimationTypeLinear: {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((notification.inAnimationType == CRToastAnimationTypeGravity ? notification.timeInterval : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    statusBarView.frame = notification.statusBarViewAnimationFrame2;
                    [UIView animateWithDuration:notification.animateOutTimeInterval
                                          delay:notification.timeInterval
                                        options:0
                                     animations:outwardAnimationsBlock
                                     completion:outwardAnimationsCompletionBlock];
                });
            } break;
            case CRToastAnimationTypeSpring: {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((notification.inAnimationType == CRToastAnimationTypeGravity ? notification.timeInterval : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    statusBarView.frame = notification.statusBarViewAnimationFrame2;
                    [UIView animateWithDuration:notification.animateOutTimeInterval
                                          delay:notification.timeInterval
                         usingSpringWithDamping:notification.animationSpringDamping
                          initialSpringVelocity:notification.animationSpringInitialVelocity
                                        options:0
                                     animations:outwardAnimationsBlock
                                     completion:outwardAnimationsCompletionBlock];
                });
            } break;
            case CRToastAnimationTypeGravity: {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(notification.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    statusBarView.frame = notification.statusBarViewAnimationFrame2;
                    [_animator removeAllBehaviors];
                    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[notificationView, statusBarView]];
                    gravity.gravityDirection = notification.outGravityDirection;
                    gravity.magnitude = notification.animationGravityMagnitude;
                    NSMutableArray *collisionItems = [@[notificationView] mutableCopy];
                    if (notification.presentationType == CRToastPresentationTypePush) [collisionItems addObject:statusBarView];
                    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
                    collision.collisionDelegate = self;
                    [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                               fromPoint:notification.outCollisionPoint1
                                                 toPoint:notification.outCollisionPoint2];
                    [_animator addBehavior:gravity];
                    [_animator addBehavior:collision];
                    
                    self.gravityAnimationCompletionBlock = outwardAnimationsCompletionBlock;
                });
            } break;
        }
    };
    
    switch (notification.inAnimationType) {
        case CRToastAnimationTypeLinear: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        }
            break;
        case CRToastAnimationTypeSpring: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                                  delay:0.0
                 usingSpringWithDamping:notification.animationSpringDamping
                  initialSpringVelocity:notification.animationSpringInitialVelocity
                                options:0
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        }
            break;
        case CRToastAnimationTypeGravity: {
            [_animator removeAllBehaviors];
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[notificationView, statusBarView]];
            gravity.gravityDirection = notification.inGravityDirection;
            gravity.magnitude = notification.animationGravityMagnitude;
            NSMutableArray *collisionItems = [@[notificationView] mutableCopy];
            if (notification.presentationType == CRToastPresentationTypePush) [collisionItems addObject:statusBarView];
            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
            collision.collisionDelegate = self;
            [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                       fromPoint:notification.inCollisionPoint1
                                         toPoint:notification.inCollisionPoint2];
            [_animator addBehavior:gravity];
            [_animator addBehavior:collision];
            self.gravityAnimationCompletionBlock = inwardAnimationsCompletionBlock;
        }
            break;
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

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item1
                 withItem:(id <UIDynamicItem>)item2 {
    if (self.gravityAnimationCompletionBlock) {
        self.gravityAnimationCompletionBlock(YES);
        self.gravityAnimationCompletionBlock = NULL;
    }
}

@end