//
//  CRToast
//  CRNotificationDemo
//
//

#import <Foundation/Foundation.h>

/**
 CRToastInteractionType defines the types of interactions that can be injected into a CRToastIneractionResponder.
 */

typedef NS_OPTIONS(NSInteger, CRToastInteractionType) {
    CRToastInteractionTypeSwipeUp           = 1 << 0,
    CRToastInteractionTypeSwipeLeft         = 1 << 1,
    CRToastInteractionTypeSwipeDown         = 1 << 2,
    CRToastInteractionTypeSwipeRight        = 1 << 3,
    CRToastInteractionTypeTapOnce           = 1 << 4,
    CRToastInteractionTypeTapTwice          = 1 << 5,
    CRToastInteractionTypeTwoFingerTapOnce  = 1 << 6,
    CRToastInteractionTypeTwoFingerTapTwice = 1 << 7,
    
    //An interaction responder with a CRToastInteractionTypeSwipe interaction type will fire on all swipe interactions
    CRToastInteractionTypeSwipe             = (CRToastInteractionTypeSwipeUp    |
                                               CRToastInteractionTypeSwipeLeft  |
                                               CRToastInteractionTypeSwipeDown  |
                                               CRToastInteractionTypeSwipeRight),
    
    //An interaction responder with a CRToastInteractionTypeTap interaction type will fire on all tap interactions
    CRToastInteractionTypeTap               = (CRToastInteractionTypeTapOnce            |
                                               CRToastInteractionTypeTapTwice           |
                                               CRToastInteractionTypeTwoFingerTapOnce   |
                                               CRToastInteractionTypeTwoFingerTapTwice),
    
    //An interaction responder with a CRToastInteractionTypeAll interaction type will fire on all swipe and tap interactions
    CRToastInteractionTypeAll               = (CRToastInteractionTypeSwipe, CRToastInteractionTypeTap)
};

extern NSString *NSStringFromCRToastInteractionType(CRToastInteractionType interactionType);

/**
 CRToastInteractionResponder is a container object to configure responses to user interactions with a notification. A collection of interaction responders can be included in the 
 options for any given notification or in defaults.
 */

@interface CRToastInteractionResponder : NSObject

/**
 Creates an interaction responder for a given interaction type.
 @param interactionType The kind of interaction that will trigger the responder
 @param automaticallyDismiss A BOOL indiciating if the notification should automatically be dismissed on the interaction being observed. If YES the configured notification dismisall
 animation will begin immidiately upon encountering the interaction.
 @param block A block of code to be called immidiately upon the interaction being encountered. The block will be provided the specific CRToastInteractionType that resulted in the 
 block firing
 */

+ (instancetype)interactionResponderWithInteractionType:(CRToastInteractionType)interactionType
                                   automaticallyDismiss:(BOOL)automaticallyDismiss
                                                  block:(void (^)(CRToastInteractionType interactionType))block;
@end

///--------------------
/// @name Notification Option Types
///--------------------

/**
 `CRToastType` defines the height of the notification. `CRToastTypeStatusBar` covers the status bar, `CRToastTypeNavigationBar` covers the status bar
 and navigation bar
 */

typedef NS_ENUM(NSInteger, CRToastType){
    CRToastTypeStatusBar,
    CRToastTypeNavigationBar
};

/**
 `CRToastPresentationType` defines whether a notification will cover the contents of the status/navigation bar or whether the content will be pushed
 out by the notification.
 */

typedef NS_ENUM(NSInteger, CRToastPresentationType){
    CRToastPresentationTypeCover,
    CRToastPresentationTypePush
};

/**
 `CRToastAnimationDirection` defines the direction of the notification. A direction can be specified for both notification entrance and exit.
 */

typedef NS_ENUM(NSInteger, CRToastAnimationDirection) {
    CRToastAnimationDirectionTop,
    CRToastAnimationDirectionBottom,
    CRToastAnimationDirectionLeft,
    CRToastAnimationDirectionRight
};

/**
 `CRToastAnimationType` defines the timing function used for the notification presentation.
 */

typedef NS_ENUM(NSInteger, CRToastAnimationType) {
    CRToastAnimationTypeLinear,
    CRToastAnimationTypeSpring,
    CRToastAnimationTypeGravity
};

///--------------------
/// @name Option Keys
///--------------------

/**
 These are the keys that define the options that can be set for a notifaction. All primitive types mentioned should 
 be wrapped as `NSNumber`s or `NSValue`s
 */

/**
 The notification type for the notification. Expects type `CRToastType`.
 */

extern NSString *const kCRToastNotificationTypeKey;

/**
 The presentation type for the notification. Expects type `CRToastPresentationType`.
 */

extern NSString *const kCRToastNotificationPresentationTypeKey;

/**
 Indicates whether the notification should slide under the staus bar, leaving it visible or not.
 Making this YES with `kCRToastNotificationTypeKey` set to `CRToastTypeStatusBar` isn't sensible and will look
 odd. Expects type `BOOL`.
 */

extern NSString *const kCRToastUnderStatusBarKey;

/**
 The animation in type for the notification. Expects type `CRToastAnimationType`.
 */

extern NSString *const kCRToastAnimationInTypeKey;

/**
 The animation out type for the notification. Expects type `CRToastAnimationType`.
 */

extern NSString *const kCRToastAnimationOutTypeKey;

/**
 The animation in direction for the notification. Expects type `CRToastAnimationDirection`.
 */

extern NSString *const kCRToastAnimationInDirectionKey;

/**
 The animation out direction for the notification. Expects type `CRToastAnimationDirection`.
 */

extern NSString *const kCRToastAnimationOutDirectionKey;

/**
 The animation in time interval for the notification. Expects type `NSTimeInterval`.
 */

extern NSString *const kCRToastAnimationInTimeIntervalKey;

/**
 The notification presentation timeinterval of type for the notification. This is how long the notification
 will be on screen after its presentation but before its dismissal. Expects type `NSTimeInterval`.
 */

extern NSString *const kCRToastTimeIntervalKey;

/**
 The animation out timeinterval for the notification. Expects type `NSTimeInterval`.
 */

extern NSString *const kCRToastAnimationOutTimeIntervalKey;

/**
 The spring damping coefficient to be used when `kCRToastAnimationInTypeKey` or `kCRToastAnimationOutTypeKey` is set to 
 `CRToastAnimationTypeSpring`. Currently you can't define separate damping for in and out. Expects type `CGFloat`.
 */


extern NSString *const kCRToastAnimationSpringDampingKey;

/**
 The initial velocity coefficient to be used when `kCRToastAnimationInTypeKey` or `kCRToastAnimationOutTypeKey` is set to
 `CRToastAnimationTypeSpring`. Currently you can't define initial velocity for in and out. Expects type `CGFloat`.
 */

extern NSString *const kCRToastAnimationSpringInitialVelocityKey;

/**
 The gravity magnitude coefficient to be used when `kCRToastAnimationInTypeKey` or `kCRToastAnimationOutTypeKey` is set to
 `CRToastAnimationTypeGravity`. Currently you can't define gravity magnitude for in and out. Expects type `CGFloat`.
 */

extern NSString *const kCRToastAnimationGravityMagnitudeKey;

/**
 The main text to be shown in the notification. Expects type `NSString`.
 */

extern NSString *const kCRToastTextKey;

/**
 The font to be used for the `kCRToastTextKey` value . Expects type `UIFont`.
 */

extern NSString *const kCRToastFontKey;

/**
 The text color to be used for the `kCRToastTextKey` value . Expects type `UIColor`.
 */

extern NSString *const kCRToastTextColorKey;

/**
 The text alignment to be used for the `kCRToastTextKey` value . Expects type `NSTextAlignment`.
 */

extern NSString *const kCRToastTextAlignmentKey;

/**
 The shadow color to be used for the `kCRToastTextKey` value . Expects type `UIColor`.
 */

extern NSString *const kCRToastTextShadowColorKey;

/**
 The shadow offset to be used for the `kCRToastTextKey` value . Expects type `CGSize`.
 */

extern NSString *const kCRToastTextShadowOffsetKey;

/**
 The max number of lines to be used for the `kCRToastTextKey` value . Expects type `NSInteger`.
 */

extern NSString *const kCRToastTextMaxNumberOfLinesKey;

/**
 The subtitle text to be shown in the notification. Expects type `NSString`.
 */

extern NSString *const kCRToastSubtitleTextKey;

/**
 The font to be used for the `kCRToastSubtitleTextKey` value . Expects type `UIFont`.
 */

extern NSString *const kCRToastSubtitleFontKey;

/**
 The text color to be used for the `kCRToastSubtitleTextKey` value . Expects type `UIColor`.
 */

extern NSString *const kCRToastSubtitleTextColorKey;

/**
 The text alignment to be used for the `kCRToastSubtitleTextKey` value . Expects type `NSTextAlignment`.
 */

extern NSString *const kCRToastSubtitleTextAlignmentKey;

/**
 The shadow color to be used for the `kCRToastSubtitleTextKey` value . Expects type `UIColor`.
 */

extern NSString *const kCRToastSubtitleTextShadowColorKey;

/**
 The shadow offset to be used for the `kCRToastSubtitleTextKey` value . Expects type `NSInteger`.
 */

extern NSString *const kCRToastSubtitleTextShadowOffsetKey;

/**
 The max number of lines to be used for the `kCRToastSubtitleTextKey` value . Expects type `NSInteger`.
 */

extern NSString *const kCRToastSubtitleTextMaxNumberOfLinesKey;

/**
 The status bar style for the navigation bar.  Expects type `NSInteger`.
 */

extern NSString *const kCRToastStatusBarStyleKey;

/**
 The background color for the notification. Expects type `UIColor`.
 */

extern NSString *const kCRToastBackgroundColorKey;

/**
 The image to be shown on the left side of the notification. Expects type `UIImage`.
 */

extern NSString *const kCRToastImageKey;

/**
 An Array of Interaction Responders for the Notification. Expects type `NSArray` full of `CRToastInteractionResponders`
 */

extern NSString *const kCRToastInteractionRespondersKey;

/**
 A toast manager providing Class level API's for the presentation of notifications with a variery of options
 */

@interface CRToastManager : NSObject

/**
 Sets the default options that CRToast will use when displaying a notification
 @param defaultOptions A dictionary of the options that are to be used as defaults for all subsequent
 showNotificationWithOptions:completionBlock and showNotificationWithMessage:completionBlock: calls
 */

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;

/**
 Queues a notification to be shown with a collection of options.
 @param options A dictionary of the options that are to be used when showing the notification, defaults
 will be used for all non present options. Options passed in will override defaults
 @param completion A completion block to be fired at the completion of the dismisall of the notification
 */

+ (void)showNotificationWithOptions:(NSDictionary*)options completionBlock:(void (^)(void))completion;

/**
 Queues a notification to be shown with a given message
 @param options The notification message to be shown. Defaults will be used for all other notification
 properties
 @param completion A completion block to be fired at the completion of the dismisall of the notification
 */

+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(void))completion;

/**
 Immidiately begins the (un)animated dismisal of a notification
 @param animated If YES the notification will dismiss with its configure animation, otherwise it will immidiately disappear
 */

+ (void)dismissNotification:(BOOL)animated;

@end