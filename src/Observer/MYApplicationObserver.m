//
//  MYApplicationObserver.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYApplicationObserver.h"
#import "MYUserDataBase.h"

@implementation MYApplicationObserver

- (void)migrateUserDatabase:(NSNotification *)ntf {
    MYUserDataBase *db = [[MYUserDataBase alloc] init];
    [db migrateUserDatabase:ntf];
    [db release];
}
@end
