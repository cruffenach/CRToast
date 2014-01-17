//
//  CRToast
//  CRNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
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

typedef NS_ENUM(NSInteger, CRToastAnimationStyle) {
    CRToastAnimationStyleTop,
    CRToastAnimationStyleBottom,
    CRToastAnimationStyleLeft,
    CRToastAnimationStyleRight
};

typedef NS_ENUM(NSInteger, CRToastAnimationType) {
    CRToastAnimationTypeLinear,
    CRToastAnimationTypeSpring
};

extern NSString *const kCRToastNotificationTypeKey;
extern NSString *const kCRToastNotificationPresentationTypeKey;

extern NSString *const kCRToastAnimationTypeKey;
extern NSString *const kCRToastAnimationInStyleKey;
extern NSString *const kCRToastAnimationOutStyleKey;

extern NSString *const kCRToastAnimationInTimeIntervalKey;
extern NSString *const kCRToastTimeIntervalKey;
extern NSString *const kCRToastAnimationOutTimeIntervalKey;

extern NSString *const kCRToastAnimationSpringDampingKey;
extern NSString *const kCRToastAnimationSpringInitialVelocityKey;

extern NSString *const kCRToastTextKey;
extern NSString *const kCRToastFontKey;
extern NSString *const kCRToastTextColorKey;
extern NSString *const kCRToastTextAlignmentKey;
extern NSString *const kCRToastTextShadowColorKey;
extern NSString *const kCRToastTextShadowOffsetKey;

extern NSString *const kCRToastBackgroundColorKey;
extern NSString *const kCRToastImageKey;

@interface CRToastManager : NSObject

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;
+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion;
+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(void))completion;

@end