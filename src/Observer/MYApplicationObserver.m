//
//  MYApplicationObserver.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYApplicationObserver.h"
#import "MYDbManager.h"

@implementation MYApplicationObserver

- (void)migrateUserDatabase:(NSNotification *)ntf {
    MYDbManager *db = [[MYDbManager alloc] init];
    [db migrateUserDatabase:ntf];
    [db release];
}
@end
