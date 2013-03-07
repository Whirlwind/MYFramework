//
//  MYDbManager.m
//  ONEBase
//
//  Created by Whirlwind on 12-11-23.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYDbManager.h"
#import "MYDbManager+FileHelper.h"

#ifndef kMYUserDatabaseFile
#   define kMYUserDatabaseFile @"user.sqlite"
#endif
#ifndef kMYUserDatabasePassword
#   define kMYUserDatabasePassword nil
#endif

static FMDatabaseQueue *_sharedDbQueue = nil;
@implementation MYDbManager

- (void)dealloc {
    [_password release], _password = nil;
    [_dbFileName release], _dbFileName = nil;
    [_writableDBPath release], _writableDBPath = nil;
    [_dbQueue release], _dbQueue = nil;//no close!!
    [super dealloc];
}

#pragma mark - init
- (id)initWithUserDatabaseFile:(NSString *)dbFileName password:(NSString *)password{
    if (self = [self init]) {
        [self setDbFileName:dbFileName password:password];
    }
    return self;
}

- (void)setDbFileName:(NSString *)dbFileName password:(NSString *)password {
    self.dbFileName = dbFileName;
    self.password = password;

    // 获取用户数据库路径
    self.writableDBPath = [[self class] getDocumentFile:dbFileName];
    NSLog(@"user db: %@", self.writableDBPath);

    if (![[NSFileManager defaultManager] fileExistsAtPath:self.writableDBPath]) {
        // 文件不存在则复制bundle内的原始包
        [[self class] copiedBundleDbToDocuments:self.dbFileName replace:NO];
    }
}

#pragma mark - getter
- (FMDatabaseQueue *)dbQueue {
    if (_dbQueue == nil) {
        self.dbQueue = [[self class] openDB:self.writableDBPath password:self.password];
    }
    return _dbQueue;
}

- (NSInteger)currentVersionForPlugin:(NSString *)plugin {
    // 获取当前数据库版本
    __block NSInteger currentVersion = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select version_num from metadata where plugin_name = ? limit 1", plugin];
        if ([rs next]) {
            currentVersion = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return currentVersion;
}

#pragma mark - migration
- (void)migratePlugin:(NSString *)plugin toVersion:(NSInteger)newVersion update:(void(^)(NSInteger oldVersion, MYDbManager *accessor))block {
    NSInteger currentVersion = [self currentVersionForPlugin:plugin];
    if (currentVersion < newVersion) {
        // 回调update方法，如果版本不是最新的
        NSLog(@"==============Start update %@'s db==========", plugin);
#ifndef __OPTIMIZE__
        NSDate *beginDate = [NSDate date];
#endif
        block(currentVersion, self);
#ifndef __OPTIMIZE__
        NSLog(@"use time: %.2f", [[NSDate date] timeIntervalSinceDate:beginDate]);
#endif
        NSLog(@"==============End update %@'s db==========", plugin);
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if (currentVersion == 0) {
                if (![db tableExists:@"metadata"]) {
                    [db executeUpdate:@"CREATE TABLE metadata(plugin_name varchar(20) primary key, version_num int);"];
                    [db executeUpdate:@"insert into metadata  (plugin_name, version_num) values ('db', 1);"];
                }
                [db executeUpdate:@"insert into metadata (plugin_name, version_num) values (?, ?);", plugin, [NSNumber numberWithInteger:newVersion]];
            } else {
                [db executeUpdate:@"update metadata set version_num = ? where plugin_name = ?;", [NSNumber numberWithInteger:newVersion], plugin];
            }
        }];
    }
}

#pragma mark - class methods
+ (void)restore:(NSArray *)datas toDb:(FMDatabaseQueue *)newDbQueue toTable:(NSString *)ttable columnsMapTable:(NSDictionary *)mapTable conflict:(NSString *)conflict {
    if ([datas count] == 0) {
        return;
    }
    NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:[datas count]];
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:[datas count]];
    NSArray *oldColumns = [datas[0] allKeys];
    if (mapTable) {
        [oldColumns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *c = mapTable[obj];
            [columns addObject:c == nil ? obj : c];
        }];
    } else {
        [columns addObjectsFromArray:oldColumns];
    }
    conflict = conflict == nil ? @"" : [NSString stringWithFormat:@"OR %@", conflict];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT %@ INTO %@", conflict, ttable];
    insertSql = [insertSql stringByAppendingFormat:@" (%@) VALUES (%@)", [columns componentsJoinedByString:@", "], [@"" stringByPaddingToLength: [columns count] * 3 - 2 withString: @", ?" startingAtIndex:2], nil];
    NSLog(@"restore sql: %@", insertSql);
    [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [args removeAllObjects];
        [oldColumns enumerateObjectsUsingBlock:^(NSDictionary *column, NSUInteger idx, BOOL *stop) {
            [args addObject:obj[column]];
        }];
        [newDbQueue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:insertSql withArgumentsInArray:args]) {
                LogError(@"ERROR! SQL: %@ ARGS: %@ %@", insertSql, args, [db lastErrorMessage]);
            }
        }];
    }];
    [columns release];
    [args release];
}

+ (void)restore:(FMDatabaseQueue *)oldDbQueue fromTable:(NSString *)ftable toDb:(FMDatabaseQueue *)newDbQueue toTable:(NSString *)ttable limit:(NSInteger)limit columns:(NSArray *)columns{

    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT ?, ?", ftable];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@", ttable];
    insertSql = [insertSql stringByAppendingFormat:@" (%@) VALUES (%@)", [columns componentsJoinedByString:@", "], [@"" stringByPaddingToLength: [columns count] * 3 - 2 withString: @", ?" startingAtIndex:2], nil];
    NSLog(@"restore sql: %@", insertSql);
    int offset = 0;
    __block int n = limit;
    while (n == limit) {
        n = 0;
        [oldDbQueue inDatabase:^(FMDatabase *oldDb) {
            FMResultSet *rs = [oldDb executeQuery:sql, [NSNumber numberWithInt:offset], [NSNumber numberWithInt:limit], nil];
            while ([rs next]) {
                n ++;
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSString *str in columns) {
                    [array addObject:[rs objectForColumnName:str]];
                }
                [newDbQueue inDatabase:^(FMDatabase *newDb) {
                    if (![newDb executeUpdate:insertSql withArgumentsInArray:array]) {
                        LogError(@"ERROR! SQL: %@ ARGS: %@ %@", insertSql, array, [newDb lastErrorMessage]);
                    }
                }];
                [array release];
            }
            [rs close];
        }];
        offset += limit;
    }
}

+ (FMDatabaseQueue *)openDB:(NSString *)_dbPath password:(NSString *)password{
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    [dbQueue inDatabase:^(FMDatabase *db)   {
        if (password != nil) {
            [db setKey:password];
        }
		[db setShouldCacheStatements:YES];
	}];
    return dbQueue;
}

+ (void)closeSharedDbQueue {
    [_sharedDbQueue close];
    [_sharedDbQueue release], _sharedDbQueue = nil;
}

+ (FMDatabaseQueue *)sharedDbQueue {
    return _sharedDbQueue;
}

- (void)migrateUserDatabase:(NSNotification *)ntf {
    if (_dbQueue != nil) {
        return;
    }
    [self setDbFileName:kMYUserDatabaseFile password:kMYUserDatabasePassword];
    _sharedDbQueue = [self.dbQueue retain];
    POST_BROADCAST_WITH_ARGS(@{@"sqlAccess" : self});
    POST_BROADCAST_WITH_NAME(@"migrateUserDatabaseCompleted");
}
@end
