//
//  MYFrameworkAppDelegate.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-4.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYFrameworkAppDelegate.h"

@implementation MYFrameworkAppDelegate

- (void)dealloc {
    [_window release], _window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MYBroadcastCenter addFileInBundle];
    [MYRouteCenter addFileInBundle];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    POST_BROADCAST_WITH_ARGS(@{@"window" : self.window});
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] increaseStartupCount];
    [[NSUserDefaults standardUserDefaults] updateTerminateTime];
}
@end
