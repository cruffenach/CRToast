//
//  CWStatusBarNotification
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWStatusBarNotification : NSObject

typedef NS_ENUM(NSInteger, CWNotificationStyle){
    CWNotificationStyleStatusBarNotification,
    CWNotificationStyleNavigationBarNotification
};

typedef NS_ENUM(NSInteger, CWNotificationAnimationStyle) {
    CWNotificationAnimationStyleTop,
    CWNotificationAnimationStyleBottom,
    CWNotificationAnimationStyleLeft,
    CWNotificationAnimationStyleRight
};

@property (strong, nonatomic) UIColor *notificationLabelBackgroundColor;
@property (strong, nonatomic) UIColor *notificationLabelTextColor;

@property (nonatomic) CWNotificationStyle notificationStyle;
@property (nonatomic) CWNotificationAnimationStyle notificationAnimationInStyle;
@property (nonatomic) CWNotificationAnimationStyle notificationAnimationOutStyle;
@property (nonatomic) BOOL notificationIsShowing;

- (void)displayNotificationWithMessage:(NSString *)message forDuration:(CGFloat)duration;
- (void)displayNotificationWithMessage:(NSString *)message completion:(void (^)(void))completion;
- (void)dismissNotification;

@end
