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
//    self.notification = [CWStatusBarNotification new];
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
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationNotificationInAnimationStyleKey : @(CWStatusBarNotificationAnimationStyleLeft),
                                                                  kCWStatusBarNotificationNotificationOutAnimationStyleKey : @(CWStatusBarNotificationAnimationStyleRight),
                                                                  kCWStatusBarNotificationTextKey : @"Hello World",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(1),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:18],
                                                                  kCWStatusBarNotificationTextColorKey : [UIColor whiteColor],
                                                                  kCWStatusBarNotificationBackgroundColorKey : [UIColor redColor],
                                                                  kCWStatusBarNotificationImageKey : [UIImage imageNamed:@"white_checkmark.png"]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationTextKey : @"My Name is Collin",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(2),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:24],
                                                                  kCWStatusBarNotificationTextColorKey : [UIColor blackColor],
                                                                  kCWStatusBarNotificationBackgroundColorKey : [UIColor whiteColor]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationTextKey : @"I have a new framework",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(1.5),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:22],
                                                                  kCWStatusBarNotificationTextColorKey : [UIColor greenColor],
                                                                  kCWStatusBarNotificationBackgroundColorKey : [UIColor lightGrayColor]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationTextKey : @"For showing alerts",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(1),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:18],
                                                                  kCWStatusBarNotificationTextColorKey : [UIColor cyanColor],
                                                                  kCWStatusBarNotificationBackgroundColorKey : [UIColor purpleColor],
                                                                  kCWStatusBarNotificationImageKey : [UIImage imageNamed:@"subtle_checkmark.png"]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationTextKey : @"To Users",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(.5),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:18],
                                                                  kCWStatusBarNotificationTextColorKey : [UIColor whiteColor],
                                                                  kCWStatusBarNotificationBackgroundColorKey : [UIColor redColor],
                                                                  kCWStatusBarNotificationImageKey : [UIImage imageNamed:@"teal_checkmark.png"]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                                  kCWStatusBarNotificationTextKey : @"I hope you like it!",
                                                                  kCWStatusBarNotificationImageKey : [UIImage imageNamed:@"alert_icon.png"]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
//    self.notification.notificationAnimationInStyle = self.segFromStyle.selectedSegmentIndex;
//    self.notification.notificationAnimationOutStyle = self.segToStyle.selectedSegmentIndex;
//    [self.notification displayNotificationWithMessage:self.txtNotificationMessage.text forDuration:self.sliderDuration.value];
}

@end
