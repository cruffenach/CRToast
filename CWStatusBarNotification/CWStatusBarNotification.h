//
//  CWStatusBarNotification
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWStatusBarNotification : NSObject

enum {
    CWNotificationStyleStatusBarNotification,
    CWNotificationStyleNavigationBarNotification
};

enum {
    CWNotificationAnimationStyleTop,
    CWNotificationAnimationStyleBottom,
    CWNotificationAnimationStyleLeft,
    CWNotificationAnimationStyleRight
};

@property (strong, nonatomic) UILabel *notificationLabel;
@property (strong, nonatomic) UIColor *notificationLabelBackgroundColor;
@property (strong, nonatomic) UIColor *notificationLabelTextColor;

@property (strong, nonatomic) UIView *statusBarView;

@property (nonatomic) NSInteger notificationStyle;
@property (nonatomic) NSInteger notificationAnimationInStyle;
@property (nonatomic) NSInteger notificationAnimationOutStyle;
@property (nonatomic) BOOL notificationIsShowing;

@property (strong, nonatomic) UIWindow *notificationWindow;

- (void)displayNotificationWithMessage:(NSString *)message forDuration:(CGFloat)duration;
- (void)displayNotificationWithMessage:(NSString *)message completion:(void (^)(void))completion;
- (void)dismissNotification;

@end
