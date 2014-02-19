//
//  MainViewController.m
//  CRNotificationDemo
//
//

#import "MainViewController.h"
#import "CRToast.h"

@interface MainViewController ()<UITextFieldDelegate>

@property (weak, readonly) NSDictionary *options;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segFromDirection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segToDirection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inAnimationTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outAnimationTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UISlider *sliderDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@property (weak, nonatomic) IBOutlet UISwitch *showImageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coverNavBarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *springPhysicsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *slideOverSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segAlignment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSubtitleAlignment;

@property (weak, nonatomic) IBOutlet UITextField *txtNotificationMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtSubtitleMessage;
@property (weak, nonatomic) IBOutlet UIButton *showNotificationButton;

@property (assign, nonatomic) NSTextAlignment textAlignment;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));

    self.title = @"CRToast";
    [self updateDurationLabel];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [self.segFromDirection setTitleTextAttributes:@{NSFontAttributeName : font}
                                     forState:UIControlStateNormal];
    [self.segToDirection setTitleTextAttributes:@{NSFontAttributeName : font}
                                   forState:UIControlStateNormal];
    [self.inAnimationTypeSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : font}
                                                        forState:UIControlStateNormal];
    [self.outAnimationTypeSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : font}
                                                        forState:UIControlStateNormal];
    
    self.txtNotificationMessage.delegate = self;
    self.txtSubtitleMessage.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)layoutSubviews {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    [self.bottomLayoutGuide length],
                                                    0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutSubviews];
}

- (void)updateDurationLabel {
    self.lblDuration.text = [NSString stringWithFormat:@"%f seconds", self.sliderDuration.value];
}

- (IBAction)sliderDurationChanged:(UISlider *)sender {
    [self updateDurationLabel];
}

# pragma mark - Show Notification

- (IBAction)btnShowNotificationPressed:(UIButton *)sender {
    [CRToastManager showNotificationWithOptions:[self options]
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

- (void)keyboardWillHide:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    [self.bottomLayoutGuide length],
                                                    0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                             CGRectGetMaxY(self.showNotificationButton.frame));
}

- (void)orientationChanged:(NSNotification*)notification {
    [self layoutSubviews];
}

#pragma mark - Overrides

CRToastAnimationType CRToastAnimationTypeFromSegmentedControl(UISegmentedControl *segmentedControl) {
    return segmentedControl.selectedSegmentIndex == 0 ? CRToastAnimationTypeLinear :
           segmentedControl.selectedSegmentIndex == 1 ? CRToastAnimationTypeSpring :
           CRToastAnimationTypeGravity;
}

- (NSDictionary*)options {
    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : self.coverNavBarSwitch.on ? @(CRToastTypeNavigationBar) : @(CRToastTypeStatusBar),
                                      kCRToastNotificationPresentationTypeKey   : self.slideOverSwitch.on ? @(CRToastPresentationTypeCover) : @(CRToastPresentationTypePush),
                                      kCRToastTextKey                           : self.txtNotificationMessage.text,
                                      kCRToastTimeIntervalKey                   : @(self.sliderDuration.value),
                                      kCRToastTextAlignmentKey                  : @(self.textAlignment),
                                      kCRToastTimeIntervalKey                   : @(self.sliderDuration.value),
                                      kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeFromSegmentedControl(_inAnimationTypeSegmentedControl)),
                                      kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeFromSegmentedControl(_outAnimationTypeSegmentedControl)),
                                      kCRToastAnimationInDirectionKey           : @(self.segFromDirection.selectedSegmentIndex),
                                      kCRToastAnimationOutDirectionKey          : @(self.segToDirection.selectedSegmentIndex)} mutableCopy];
    if (self.showImageSwitch.on) {
        options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon.png"];
    }
    
    if (![self.txtSubtitleMessage.text isEqualToString:@""]) {
        options[kCRToastSubtitleTextKey] = self.txtSubtitleMessage.text;
        options[kCRToastSubtitleTextAlignmentKey] = @(self.subtitleAlignment);
    }
    
    return [NSDictionary dictionaryWithDictionary:options];
}

- (NSTextAlignment)textAlignment {
    NSInteger selectedSegment = self.segAlignment.selectedSegmentIndex;
    return selectedSegment == 0 ? NSTextAlignmentLeft :
    selectedSegment == 1 ? NSTextAlignmentCenter :
    NSTextAlignmentRight;
}

- (NSTextAlignment)subtitleAlignment {
    NSInteger selectedSegment = self.segSubtitleAlignment.selectedSegmentIndex;
    return selectedSegment == 0 ? NSTextAlignmentLeft :
    selectedSegment == 1 ? NSTextAlignmentCenter :
    NSTextAlignmentRight;
}

#pragma mark - Gesture Recognizer Selectors

- (void)scrollViewTapped:(UITapGestureRecognizer*)tapGestureRecognizer {
    [_txtNotificationMessage resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // close the keyboard
    [textField resignFirstResponder];
    return YES;
}

@end