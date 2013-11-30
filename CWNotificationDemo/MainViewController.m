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
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UISlider *sliderDuration;
@property (weak, nonatomic) IBOutlet UITextField *txtNotificationMessage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segFromStyle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segToStyle;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"CWStatusBarNotification";
    [self updateDurationLabel];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [self.segFromStyle setTitleTextAttributes:@{NSFontAttributeName : font}
                                     forState:UIControlStateNormal];
    [self.segToStyle setTitleTextAttributes:@{NSFontAttributeName : font}
                                   forState:UIControlStateNormal];
}

- (void)updateDurationLabel {
    self.lblDuration.text = [NSString stringWithFormat:@"%f seconds", self.sliderDuration.value];
}

- (IBAction)sliderDurationChanged:(UISlider *)sender {
    [self updateDurationLabel];
}

# pragma mark - show notification

- (IBAction)btnShowNotificationPressed:(UIButton *)sender {
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationTextKey : @"Hello World!"}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
    
    [CWStatusBarNotificationManager showNotificationWithOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeStatusBar),
                                                                  kCWStatusBarNotificationTextKey : @"Let's test a little one!",
                                                                  kCWStatusBarNotificationTimeIntervalKey : @(5),
                                                                  kCWStatusBarNotificationFontKey : [UIFont systemFontOfSize:10]}
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
}

@end
