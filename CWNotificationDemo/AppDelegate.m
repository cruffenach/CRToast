//
//  AppDelegate.m
//  CWNotificationDemo
//
//  Created by Cezary Wojcik on 11/15/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CWStatusBarNotificationManager setDefaultOptions:@{kCWStatusBarNotificationNotificationTypeKey : @(CWStatusBarNotificationTypeNavigationBar),
                                                        kCWStatusBarNotificationFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:16],
                                                        kCWStatusBarNotificationTextColorKey        : [UIColor whiteColor],
                                                        kCWStatusBarNotificationBackgroundColorKey  : [UIColor orangeColor]}];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *navigationController = [UINavigationController new];
    self.window.rootViewController = navigationController;
    [navigationController pushViewController:mainViewController animated:NO];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
