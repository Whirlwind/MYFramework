//
//  MYUserDataBase.m
//  ONEBase
//
//  Created by Whirlwind on 12-11-23.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYUserDataBase.h"

#ifndef kMYUserDatabaseFile
#   define kMYUserDatabaseFile @"user.sqlite"
#endif
#ifndef kMYUserDatabasePassword
#   define kMYUserDatabasePassword nil
#endif

static FMDatabaseQueue *_dbQueue = nil;
@implementation MYUserDataBase

+ (void)close {
    [_dbQueue close];
    [_dbQueue release], _dbQueue = nil;
}

+ (FMDatabaseQueue *)dbQueue {
    return _dbQueue;
}

- (void)migrateUserDatabase:(NSNotification *)ntf {
    if (_dbQueue != nil) {
        return;
    }
    MYSqlAccess *sql = [[MYSqlAccess alloc] initWithUserDatabaseFile:kMYUserDatabaseFile password:kMYUserDatabasePassword];
    _dbQueue = [sql.dbQueue retain];
    POST_BROADCAST_WITH_ARGS(@{@"sqlAccess" : sql});
    [sql release];
    POST_BROADCAST_WITH_NAME_AND_ARGS(@"migrateUserDatabaseCompleted", nil);
}
@end
