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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segFromDirection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segToDirection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inAnimationTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outAnimationTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UISlider *sliderDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@property (weak, nonatomic) IBOutlet UISwitch *showImageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coverNavBarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *slideOverSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *slideUnderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dismissibleWithTapSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *statusBarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *navigationBarSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segAlignment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSubtitleAlignment;

@property (weak, nonatomic) IBOutlet UITextField *txtNotificationMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtSubtitleMessage;

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)layoutSubviews {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    [self.bottomLayoutGuide length],
                                                    0);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutSubviews];
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarSwitch ? !self.statusBarSwitch.on : NO;
}

- (void)updateDurationLabel {
    self.lblDuration.text = [NSString stringWithFormat:@"%f seconds", self.sliderDuration.value];
}

- (IBAction)sliderDurationChanged:(UISlider *)sender {
    [self updateDurationLabel];
}

- (IBAction)statusBarChanged:(UISwitch *)sender {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (IBAction)navigationBarChanged:(UISwitch *)sender {
    [[self navigationController] setNavigationBarHidden:!sender.on animated:YES];
}

# pragma mark - Show Notification

- (IBAction)btnShowNotificationPressed:(UIButton *)sender {
    [CRToastManager showNotificationWithOptions:[self options]
                                 apperanceBlock:^(void) {
                                     NSLog(@"Appeared");
                                 }
                                completionBlock:^(void) {
                                    NSLog(@"Completed");
                                }];
}

- (IBAction)btnDismissNotificationPressed:(UIButton *)sender {
    [CRToastManager dismissNotification:YES];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]),
                                                    0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length],
                                                    0,
                                                    [self.bottomLayoutGuide length],
                                                    0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
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
                                      kCRToastUnderStatusBarKey                 : @(self.slideUnderSwitch.on),
                                      kCRToastTextKey                           : self.txtNotificationMessage.text,
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
    
    if (_dismissibleWithTapSwitch.on) {
        options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                      automaticallyDismiss:YES
                                                                                                                     block:^(CRToastInteractionType interactionType){
                                                                                                                         NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                                     }]];
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