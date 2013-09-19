//
//  CWSampleViewController.h
//  CWStatusBarNotificationDemo
//
//  Created by Cezary Wojcik on 9/18/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSampleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
