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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UISlider *sliderDuration;
@property (weak, nonatomic) IBOutlet UITextField *txtNotificationMessage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segFromStyle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segToStyle;
@property (weak, nonatomic) IBOutlet UISwitch *showImageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coverNavBarSwitch;
@property (weak, nonatomic) IBOutlet UIButton *showNotificationButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));

    self.title = @"CWStatusBarNotification";
    [self updateDurationLabel];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [self.segFromStyle setTitleTextAttributes:@{NSFontAttributeName : font}
                                     forState:UIControlStateNormal];
    [self.segToStyle setTitleTextAttributes:@{NSFontAttributeName : font}
                                   forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    [self.bottomLayoutGuide length],
                                                    0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));
}

- (void)updateDurationLabel {
    self.lblDuration.text = [NSString stringWithFormat:@"%f seconds", self.sliderDuration.value];
}

- (IBAction)sliderDurationChanged:(UISlider *)sender {
    [self updateDurationLabel];
}

# pragma mark - show notification

- (IBAction)btnShowNotificationPressed:(UIButton *)sender {
    NSMutableDictionary *options = [@{kCWStatusBarNotificationNotificationTypeKey               : self.coverNavBarSwitch.on ? @(CWStatusBarNotificationTypeNavigationBar) : @(CWStatusBarNotificationTypeStatusBar),
                                      kCWStatusBarNotificationAnimationTypeKey                  : @(CWStatusBarNotificationAnimationTypeSpring),
                                      kCWStatusBarNotificationAnimateInTimeIntervalKey          : @(0.5),
                                      kCWStatusBarNotificationAnimateOutTimeIntervalKey         : @(0.5),
                                      kCWStatusBarNotificationTextKey                           : self.txtNotificationMessage.text,
                                      kCWStatusBarNotificationTimeIntervalKey                   : @(self.sliderDuration.value),
                                      kCWStatusBarNotificationNotificationInAnimationStyleKey   : @(self.segFromStyle.selectedSegmentIndex),
                                      kCWStatusBarNotificationNotificationOutAnimationStyleKey  : @(self.segToStyle.selectedSegmentIndex)} mutableCopy];
    if (self.showImageSwitch.on) {
        options[kCWStatusBarNotificationImageKey] = [UIImage imageNamed:@"alert_icon.png"];
    }
    
    [CWStatusBarNotificationManager showNotificationWithOptions:[NSDictionary dictionaryWithDictionary:options]
                                                completionBlock:^{
                                                    NSLog(@"Completed");
                                                }];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]),
                                                    0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));
}

@end
