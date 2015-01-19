//
//  CRToastViewController.h
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRToast;

@interface CRToastViewController : UIViewController

@property (nonatomic, assign) BOOL autorotate;
@property (nonatomic, weak) CRToast *notification;
@property (nonatomic, weak) UIView *toastView;

- (void)statusBarStyle:(UIStatusBarStyle)newStatusBarStyle;

@end
