//
//  CRToast
//  CRNotificationDemo
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CRToastType){
    CRToastTypeStatusBar,
    CRToastTypeNavigationBar
};

typedef NS_ENUM(NSInteger, CRToastPresentationType){
    CRToastPresentationTypeCover,
    CRToastPresentationTypePush
};

typedef NS_ENUM(NSInteger, CRToastAnimationDirection) {
    CRToastAnimationDirectionTop,
    CRToastAnimationDirectionBottom,
    CRToastAnimationDirectionLeft,
    CRToastAnimationDirectionRight
};

typedef NS_ENUM(NSInteger, CRToastAnimationType) {
    CRToastAnimationTypeLinear,
    CRToastAnimationTypeSpring,
    CRToastAnimationTypeGravity
};

extern NSString *const kCRToastNotificationTypeKey;
extern NSString *const kCRToastNotificationPresentationTypeKey;

extern NSString *const kCRToastUnderStatusBarKey;

extern NSString *const kCRToastAnimationInTypeKey;
extern NSString *const kCRToastAnimationOutTypeKey;
extern NSString *const kCRToastAnimationInDirectionKey;
extern NSString *const kCRToastAnimationOutDirectionKey;

extern NSString *const kCRToastAnimationInTimeIntervalKey;
extern NSString *const kCRToastTimeIntervalKey;
extern NSString *const kCRToastAnimationOutTimeIntervalKey;

extern NSString *const kCRToastAnimationSpringDampingKey;
extern NSString *const kCRToastAnimationSpringInitialVelocityKey;

extern NSString *const kCRToastAnimationGravityMagnitudeKey;

extern NSString *const kCRToastTextKey;
extern NSString *const kCRToastFontKey;
extern NSString *const kCRToastTextColorKey;
extern NSString *const kCRToastTextAlignmentKey;
extern NSString *const kCRToastTextShadowColorKey;
extern NSString *const kCRToastTextShadowOffsetKey;
extern NSString *const kCRToastTextMaxNumberOfLinesKey;

extern NSString *const kCRToastSubtitleTextKey;
extern NSString *const kCRToastSubtitleFontKey;
extern NSString *const kCRToastSubtitleTextColorKey;
extern NSString *const kCRToastSubtitleTextAlignmentKey;
extern NSString *const kCRToastSubtitleTextShadowColorKey;
extern NSString *const kCRToastSubtitleTextShadowOffsetKey;
extern NSString *const kCRToastSubtitleTextMaxNumberOfLinesKey;

extern NSString *const kCRToastBackgroundColorKey;
extern NSString *const kCRToastImageKey;

@interface CRToastManager : NSObject

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;
+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion;
+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(void))completion;

@end