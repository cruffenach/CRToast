//
//  CRToastView.h
//  CRToastDemo
//
//  Created by Daniel on 12/19/14.
//  Copyright (c) 2014 Collin Ruffenach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRToast;

@interface CRToastView : UIView
@property (nonatomic, strong) CRToast *toast;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
