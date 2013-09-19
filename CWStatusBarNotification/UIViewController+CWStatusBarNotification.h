//
//  UIViewController+CWStatusBarNotification.h
//  CWStatusBarNotificationDemo
//
//  Created by Cezary Wojcik on 9/18/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CWStatusBarNotification)

- (void)showStatusBarNotification:(NSString *)message forDuration:(CGFloat)duration;

@property (nonatomic, readwrite) BOOL statusBarIsHidden;
@property (nonatomic, readwrite) BOOL statusBarNotificationIsShowing;
@property (nonatomic, readwrite) UILabel *statusBarNotificationLabel;

@end
