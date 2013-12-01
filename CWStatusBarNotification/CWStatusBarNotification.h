//
//  CWStatusBarNotification
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CWStatusBarNotificationType){
    CWStatusBarNotificationTypeStatusBar,
    CWStatusBarNotificationTypeNavigationBar
};

typedef NS_ENUM(NSInteger, CWStatusBarNotificationAnimationStyle) {
    CWStatusBarNotificationAnimationStyleTop,
    CWStatusBarNotificationAnimationStyleBottom,
    CWStatusBarNotificationAnimationStyleLeft,
    CWStatusBarNotificationAnimationStyleRight
};

typedef NS_ENUM(NSInteger, CWStatusBarNotificationAnimationType) {
    CWStatusBarNotificationAnimationTypeLinear,
    CWStatusBarNotificationAnimationTypeSpring
};

extern NSString *const kCWStatusBarNotificationNotificationTypeKey;

extern NSString *const kCWStatusBarNotificationAnimationTypeKey;
extern NSString *const kCWStatusBarNotificationNotificationInAnimationStyleKey;
extern NSString *const kCWStatusBarNotificationNotificationOutAnimationStyleKey;

extern NSString *const kCWStatusBarNotificationAnimateInTimeIntervalKey;
extern NSString *const kCWStatusBarNotificationTimeIntervalKey;
extern NSString *const kCWStatusBarNotificationAnimateOutTimeIntervalKey;

extern NSString *const kCWStatusBarNotificationAnimateSpringDampingKey;
extern NSString *const kCWStatusBarNotificationAnimateSpringInitialVelocityKey;

extern NSString *const kCWStatusBarNotificationTextKey;
extern NSString *const kCWStatusBarNotificationFontKey;
extern NSString *const kCWStatusBarNotificationTextColorKey;
extern NSString *const kCWStatusBarNotificationTextAlignmentKey;
extern NSString *const kCWStatusBarNotificationTextShadowColorKey;
extern NSString *const kCWStatusBarNotificationTextShadowOffsetKey;

extern NSString *const kCWStatusBarNotificationBackgroundColorKey;
extern NSString *const kCWStatusBarNotificationImageKey;

@interface CWStatusBarNotificationManager : NSObject

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;
+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion;

@end