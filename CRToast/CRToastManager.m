//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import "CRToastManager.h"
#import "CRToast.h"
#import "CRToastView.h"
#import "CRToastViewController.h"
#import "CRToastWindow.h"
#import "CRToastLayoutHelpers.h"

@interface CRToast (CRToastManager)
+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;
+ (instancetype)notificationWithOptions:(NSDictionary*)options appearanceBlock:(void (^)(void))appearance completionBlock:(void (^)(void))completion;
@end

@interface CRToastManager () <UICollisionBehaviorDelegate>
@property (nonatomic, readonly) BOOL showingNotification;
@property (nonatomic, strong) UIWindow *notificationWindow;
@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, readonly) CRToast *notification;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, copy) void (^gravityAnimationCompletionBlock)(BOOL finished);
@end

static NSString *const kCRToastManagerCollisionBoundryIdentifier = @"kCRToastManagerCollisionBoundryIdentifier";

typedef void (^CRToastAnimationCompletionBlock)(BOOL animated);
typedef void (^CRToastAnimationStepBlock)(void);

@implementation CRToastManager

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    [CRToast setDefaultOptions:defaultOptions];
}

+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(void))completion {
    [self showNotificationWithOptions:@{kCRToastTextKey : message}
                      completionBlock:completion];
}

+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion {
    [self showNotificationWithOptions:options
                       apperanceBlock:nil
                      completionBlock:completion];
}

+ (void)showNotificationWithOptions:(NSDictionary*)options
                     apperanceBlock:(void (^)(void))appearance
                    completionBlock:(void (^)(void))completion
{
    [[CRToastManager manager] addNotification:[CRToast notificationWithOptions:options
                                                               appearanceBlock:appearance
                                                               completionBlock:completion]];
}


+ (void)dismissNotification:(BOOL)animated {
    [[self manager] dismissNotification:animated];
}

+ (void)dismissAllNotifications:(BOOL)animated {
    [[self manager] dismissAllNotifications:animated];
}

+ (void)dismissAllNotificationsWithIdentifier:(NSString *)identifer animated:(BOOL)animated {
    [[self manager] dismissAllNotificationsWithIdentifier:identifer animated:animated];
}

+ (NSArray *)notificationIdentifiersInQueue {
    return [[self manager] notificationIdentifiersInQueue];
}

+ (BOOL)isShowingNotification {
	return [[self manager] showingNotification];
}

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIWindow *notificationWindow = [[CRToastWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        notificationWindow.backgroundColor = [UIColor clearColor];
        notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        notificationWindow.windowLevel = UIWindowLevelStatusBar;
        notificationWindow.rootViewController = [CRToastViewController new];
        notificationWindow.rootViewController.view.clipsToBounds = YES;
        self.notificationWindow = notificationWindow;
        
        self.notifications = [@[] mutableCopy];
    }
    return self;
}

#pragma mark - -- Notification Management --
#pragma mark - Notification Animation Blocks
#pragma mark Inward Animations
CRToastAnimationStepBlock CRToastInwardAnimationsBlock(CRToastManager *weakSelf, CRToast *notification) {
    return ^void(void) {
        weakSelf.notificationView.frame = weakSelf.notificationWindow.rootViewController.view.bounds;
        weakSelf.statusBarView.frame = notification.statusBarViewAnimationFrame1;
    };
}

CRToastAnimationCompletionBlock CRToastInwardAnimationsCompletionBlock(CRToastManager *weakSelf, CRToast *notification, NSString *notificationUUIDString) {
    return ^void(BOOL finished) {
        if (notification.timeInterval != DBL_MAX && notification.state == CRToastStateEntering) {
            notification.state = CRToastStateDisplaying;
            if (!notification.forceUserInteraction) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(notification.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.notification.state == CRToastStateDisplaying && [weakSelf.notification.uuid.UUIDString isEqualToString:notificationUUIDString]) {
                        weakSelf.gravityAnimationCompletionBlock = NULL;
                        CRToastOutwardAnimationsSetupBlock(weakSelf)();
                    }
                });
            }
        }
    };
}

#pragma mark Outward Animations
CRToastAnimationCompletionBlock CRToastOutwardAnimationsCompletionBlock(CRToastManager *weakSelf) {
    return ^void(BOOL completed){
        if (weakSelf.notification.showActivityIndicator) {
            [[(CRToastView *)weakSelf.notificationView activityIndicator] stopAnimating];
        }
        weakSelf.notificationWindow.rootViewController.view.gestureRecognizers = nil;
        weakSelf.notification.state = CRToastStateCompleted;
        if (weakSelf.notification.completion) weakSelf.notification.completion();
        [weakSelf.notifications removeObject:weakSelf.notification];
        [weakSelf.notificationView removeFromSuperview];
        [weakSelf.statusBarView removeFromSuperview];
        if (weakSelf.notifications.count > 0) {
            CRToast *notification = weakSelf.notifications.firstObject;
            weakSelf.gravityAnimationCompletionBlock = NULL;
            [weakSelf displayNotification:notification];
        } else {
            weakSelf.notificationWindow.hidden = YES;
        }
    };
}

CRToastAnimationStepBlock CRToastOutwardAnimationsBlock(CRToastManager *weakSelf) {
    return ^{
        weakSelf.notification.state = CRToastStateExiting;
        [weakSelf.notification.animator removeAllBehaviors];
        weakSelf.notificationView.frame = weakSelf.notification.notificationViewAnimationFrame2;
        weakSelf.statusBarView.frame = weakSelf.notificationWindow.rootViewController.view.bounds;
    };
}

CRToastAnimationStepBlock CRToastOutwardAnimationsSetupBlock(CRToastManager *weakSelf) {
    return ^{
        CRToast *notification = weakSelf.notification;
        weakSelf.notification.state = CRToastStateExiting;
        weakSelf.statusBarView.frame = notification.statusBarViewAnimationFrame2;
        [weakSelf.notificationWindow.rootViewController.view.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIGestureRecognizer*)obj setEnabled:NO];
        }];
        
        switch (weakSelf.notification.outAnimationType) {
            case CRToastAnimationTypeLinear: {
                [UIView animateWithDuration:notification.animateOutTimeInterval
                                      delay:0
                                    options:0
                                 animations:CRToastOutwardAnimationsBlock(weakSelf)
                                 completion:CRToastOutwardAnimationsCompletionBlock(weakSelf)];
            } break;
            case CRToastAnimationTypeSpring: {
                [UIView animateWithDuration:notification.animateOutTimeInterval
                                      delay:0
                     usingSpringWithDamping:notification.animationSpringDamping
                      initialSpringVelocity:notification.animationSpringInitialVelocity
                                    options:0
                                 animations:CRToastOutwardAnimationsBlock(weakSelf)
                                 completion:CRToastOutwardAnimationsCompletionBlock(weakSelf)];
            } break;
            case CRToastAnimationTypeGravity: {
                if (weakSelf.notification.animator == nil) {
                    [weakSelf.notification initiateAnimator:weakSelf.notificationWindow.rootViewController.view];
                }
                [weakSelf.notification.animator removeAllBehaviors];
                UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[weakSelf.notificationView, weakSelf.statusBarView]];
                gravity.gravityDirection = notification.outGravityDirection;
                gravity.magnitude = notification.animationGravityMagnitude;
                NSMutableArray *collisionItems = [@[weakSelf.notificationView] mutableCopy];
                if (notification.presentationType == CRToastPresentationTypePush) [collisionItems addObject:weakSelf.statusBarView];
                UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
                collision.collisionDelegate = weakSelf;
                [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                           fromPoint:notification.outCollisionPoint1
                                             toPoint:notification.outCollisionPoint2];
                UIDynamicItemBehavior *rotationLock = [[UIDynamicItemBehavior alloc] initWithItems:collisionItems];
                rotationLock.allowsRotation = NO;
                [weakSelf.notification.animator addBehavior:gravity];
                [weakSelf.notification.animator addBehavior:collision];
                [weakSelf.notification.animator addBehavior:rotationLock];
                weakSelf.gravityAnimationCompletionBlock = CRToastOutwardAnimationsCompletionBlock(weakSelf);
            } break;
        }
    };
}

#pragma mark -

- (NSArray *)notificationIdentifiersInQueue {
    if (_notifications.count == 0) { return @[]; }
    return [[_notifications valueForKeyPath:@"options.kCRToastIdentifierKey"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != nil"]];
}

- (void)dismissNotification:(BOOL)animated {
    if (_notifications.count == 0) return;
    
    if (animated && (self.notification.state == CRToastStateEntering || self.notification.state == CRToastStateDisplaying)) {
        __weak __block typeof(self) weakSelf = self;
        CRToastOutwardAnimationsSetupBlock(weakSelf)();
    } else {
        __weak __block typeof(self) weakSelf = self;
        CRToastOutwardAnimationsCompletionBlock(weakSelf)(YES);
    }
}

- (void)dismissAllNotifications:(BOOL)animated {
    [self dismissNotification:animated];
    [self.notifications removeAllObjects];
}

- (void)dismissAllNotificationsWithIdentifier:(NSString *)identifer animated:(BOOL)animated {
    if (_notifications.count == 0) { return; }
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    __block BOOL callDismiss = NO;
    [self.notifications enumerateObjectsUsingBlock:^(CRToast *toast, NSUInteger idx, BOOL *stop) {
        NSString *toastIdentifier = toast.options[kCRToastIdentifierKey];
        if (toastIdentifier && [toastIdentifier isEqualToString:identifer]) {
            if (idx == 0) { callDismiss = YES; }
            else {
                [indexes addIndex:idx];
            }
        }
    }];
    [self.notifications removeObjectsAtIndexes:indexes];
    if (callDismiss) { [self dismissNotification:animated]; }
}

- (void)addNotification:(CRToast*)notification {
    BOOL showingNotification = self.showingNotification;
    [_notifications addObject:notification];
    if (!showingNotification) {
        [self displayNotification:notification];
    }
}

- (void)displayNotification:(CRToast*)notification {
    if (notification.appearance != nil)
    {
        notification.appearance();
    }
    
    _notificationWindow.hidden = NO;
    CGSize notificationSize = CRNotificationViewSize(notification.notificationType, notification.preferredHeight);
    if (notification.shouldKeepNavigationBarBorder) {
        notificationSize.height -= 1.0f;
    }
    
    CGRect containerFrame = CRGetNotificationContainerFrame(CRGetDeviceOrientation(), notificationSize);
    
    CRToastViewController *rootViewController = (CRToastViewController*)_notificationWindow.rootViewController;
    rootViewController.statusBarStyle = notification.statusBarStyle;
    rootViewController.autorotate = notification.autorotate;
    rootViewController.notification = notification;
    
    _notificationWindow.rootViewController.view.frame = containerFrame;
    _notificationWindow.windowLevel = notification.displayUnderStatusBar ? UIWindowLevelNormal + 1 : UIWindowLevelStatusBar;
    
    UIView *statusBarView = notification.statusBarView;
    statusBarView.frame = _notificationWindow.rootViewController.view.bounds;
    [_notificationWindow.rootViewController.view addSubview:statusBarView];
    self.statusBarView = statusBarView;
    statusBarView.hidden = notification.presentationType == CRToastPresentationTypeCover;
    
    UIView *notificationView = notification.notificationView;
    notificationView.frame = notification.notificationViewAnimationFrame1;
    [_notificationWindow.rootViewController.view addSubview:notificationView];
    self.notificationView = notificationView;
    rootViewController.toastView = notificationView;
    self.statusBarView = statusBarView;
    
    for (UIView *subview in _notificationWindow.rootViewController.view.subviews) {
        subview.userInteractionEnabled = NO;
    }
    
    _notificationWindow.rootViewController.view.userInteractionEnabled = YES;
    _notificationWindow.rootViewController.view.gestureRecognizers = notification.gestureRecognizers;
    
    __weak __block typeof(self) weakSelf = self;
    CRToastAnimationStepBlock inwardAnimationsBlock = CRToastInwardAnimationsBlock(weakSelf, notification);
    
    NSString *notificationUUIDString = notification.uuid.UUIDString;
    CRToastAnimationCompletionBlock inwardAnimationsCompletionBlock = CRToastInwardAnimationsCompletionBlock(weakSelf, notification, notificationUUIDString);
    
    notification.state = CRToastStateEntering;
    
    [self showNotification:notification inwardAnimationBlock:inwardAnimationsBlock inwardCompletionAnimationBlock:inwardAnimationsCompletionBlock];
    
    if (notification.text.length > 0 || notification.subtitleText.length > 0) {
        // Synchronous notifications (say, tapping a button that presents a toast) cause VoiceOver to read the button immediately, which interupts the toast. A short delay (not the best solution :/) allows the toast to interupt the button.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Alert: %@, %@", notification.text ?: @"", notification.subtitleText ?: @""]);
        });
    }
}

- (void)showNotification:(CRToast *)notification
     inwardAnimationBlock:(CRToastAnimationStepBlock)inwardAnimationsBlock
inwardCompletionAnimationBlock:(CRToastAnimationCompletionBlock)inwardAnimationsCompletionBlock {
    
    switch (notification.inAnimationType) {
        case CRToastAnimationTypeLinear: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        } break;
        case CRToastAnimationTypeSpring: {
            [UIView animateWithDuration:notification.animateInTimeInterval
                                  delay:0.0
                 usingSpringWithDamping:notification.animationSpringDamping
                  initialSpringVelocity:notification.animationSpringInitialVelocity
                                options:0
                             animations:inwardAnimationsBlock
                             completion:inwardAnimationsCompletionBlock];
        } break;
        case CRToastAnimationTypeGravity: {
            UIView *notificationView = notification.notificationView;
            UIView *statusBarView = notification.statusBarView;
            
            [notification initiateAnimator:_notificationWindow.rootViewController.view];
            [notification.animator removeAllBehaviors];
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[notificationView, statusBarView]];
            gravity.gravityDirection = notification.inGravityDirection;
            gravity.magnitude = notification.animationGravityMagnitude;
            NSMutableArray *collisionItems = [@[notificationView] mutableCopy];
            if (notification.presentationType == CRToastPresentationTypePush) [collisionItems addObject:statusBarView];
            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
            collision.collisionDelegate = self;
            [collision addBoundaryWithIdentifier:kCRToastManagerCollisionBoundryIdentifier
                                       fromPoint:notification.inCollisionPoint1
                                         toPoint:notification.inCollisionPoint2];
            UIDynamicItemBehavior *rotationLock = [[UIDynamicItemBehavior alloc] initWithItems:collisionItems];
            rotationLock.allowsRotation = NO;
            [notification.animator addBehavior:gravity];
            [notification.animator addBehavior:collision];
            [notification.animator addBehavior:rotationLock];
            self.gravityAnimationCompletionBlock = inwardAnimationsCompletionBlock;
        } break;
    }
}


#pragma mark - Overrides

- (BOOL)showingNotification {
    return self.notifications.count > 0;
}

- (CRToast*)notification {
    return _notifications.firstObject;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier {
    if (self.gravityAnimationCompletionBlock) {
        self.gravityAnimationCompletionBlock(YES);
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item1
                 withItem:(id <UIDynamicItem>)item2 {
    if (self.gravityAnimationCompletionBlock) {
        self.gravityAnimationCompletionBlock(YES);
        self.gravityAnimationCompletionBlock = NULL;
    }
}

@end
