//
//  MainViewController.h
//  CRNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRToast.h"

@interface MainViewController : UIViewController

- (IBAction)sliderDurationChanged:(UISlider *)sender;
- (IBAction)btnShowNotificationPressed:(UIButton *)sender;

@end
