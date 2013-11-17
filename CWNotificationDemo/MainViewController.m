//
//  MainViewController.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "MainViewController.h"
#import "CWStatusBarNotification.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize lblDuration, txtNotificationMessage, sliderDuration;

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
    self.title = @"CWStatusBarNotification";
    [self updateDurationLabel];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segFromStyle setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segToStyle setTitleTextAttributes:attributes forState:UIControlStateNormal];
    // initialize CWNotification
    self.notification = [CWStatusBarNotification new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDurationLabel
{
    self.lblDuration.text = [NSString stringWithFormat:@"%f seconds", self.sliderDuration.value];
}

- (IBAction)sliderDurationChanged:(UISlider *)sender
{
    [self updateDurationLabel];
}

# pragma mark - show notification

- (IBAction)btnShowNotificationPressed:(UIButton *)sender
{
    self.notification.notificationAnimationInStyle = self.segFromStyle.selectedSegmentIndex;
    self.notification.notificationAnimationOutStyle = self.segToStyle.selectedSegmentIndex;
    [self.notification displayNotificationWithMessage:self.txtNotificationMessage.text forDuration:self.sliderDuration.value];
}

@end
