//
//  AppDelegate.m
//  CRNotificationDemo
//
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CRToastManager setDefaultOptions:@{kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                        kCRToastFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:16],
                                        kCRToastTextColorKey        : [UIColor whiteColor],
                                        kCRToastBackgroundColorKey  : [UIColor orangeColor]}];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
