//
//  MYFrameworkAppDelegate.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-4.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYFrameworkAppDelegate.h"

@implementation MYFrameworkAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MYBroadcastCenter addFileInBundle];
    [MYRouteCenter addFileInBundle];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    POST_BROADCAST_WITH_ARGS(@{@"window" : self.window});
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

}
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

}
- (void)applicationWillResignActive:(UIApplication *)application {

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

}
- (void)applicationWillTerminate:(UIApplication *)application {

}
- (void)applicationSignificantTimeChange:(UIApplication *)application {

}
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {

}
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {

}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {

}
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {

}

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] increaseStartupCount];
//    [[NSUserDefaults standardUserDefaults] updateTerminateTime];

}
- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {

}
- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {

}

#pragma mark -- State Restoration protocol adopted by UIApplication delegate --

- (void) application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {

}
- (void) application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    
}
@end
