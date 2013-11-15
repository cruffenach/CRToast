//
//  CWSampleViewController.m
//  CWStatusBarNotificationDemo
//
//  Created by Cezary Wojcik on 9/18/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "CWSampleViewController.h"
#import "UIViewController+CWStatusBarNotification.h"

@interface CWSampleViewController ()

@end

@implementation CWSampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self sliderValueChanged:nil];
    self.title = @"CWStatusBarNotification";
    // setup status bar notification visuals
    self.statusBarNotificationLabel.textColor = [UIColor whiteColor];
    self.statusBarNotificationLabel.backgroundColor = self.view.tintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShowNotification:(UIButton *)sender {
    // display notification
    [self showStatusBarNotification:self.textField.text forDuration:self.slider.value];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSString *labelText = [NSString stringWithFormat:@"Duration: %f seconds", self.slider.value];
    self.label.text = labelText;
}

@end
