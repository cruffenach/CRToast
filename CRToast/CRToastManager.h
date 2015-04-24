//
//  CRToast
//  Copyright (c) 2014-2015 Collin Ruffenach. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 @param appearance A  block to be fired when the notification is actually shown -- notifications can queue,
 and this block will only fire when the notification actually becomes visible to the user. Useful for
 synchronizing sound / vibration.
 */

+ (void)showNotificationWithOptions:(NSDictionary*)options apperanceBlock:(void (^)(void))appearance completionBlock:(void (^)(void))completion;

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

/**
 Immidiately begins the (un)animated dismisal of a notification and canceling all others
 @param animated If YES the notification will dismiss with its configure animation, otherwise it will immidiately disappear
 */
+ (void)dismissAllNotifications:(BOOL)animated;

/**
 Immidiately begins the (un)animated dismisal of a notification and removing of all notifications 
 with specified identifier
 @param identifier `kCRToastIdentiferKey` specified for the toasts in queue. If no toasts are found with that identifier, none will be removed.
 @param animated   If YES the notification will dismiss with its configure animation, otherwise it will immidiately disappear
 */
+ (void)dismissAllNotificationsWithIdentifier:(NSString *)identifer animated:(BOOL)animated;

/**
 Gets the array of notification identifiers currently in the @c CRToastManager notifications queue.
 If no identifier is specified for the @c kCRToastIdentifier when created, it will be excluded from this collection.
 */
+ (NSArray *)notificationIdentifiersInQueue;

/**
 Checks if there is a notification currently being displayed
 */
+ (BOOL)isShowingNotification;

@end
