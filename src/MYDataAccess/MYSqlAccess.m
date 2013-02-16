//
//  MYSqlAccess.m
//  foodiet
//
//  Created by Whirlwind James on 11-12-26.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

#import "MYSqlAccess.h"
#import "VersionString.h"
#import "sys/xattr.h"//iCloud属性设置

@implementation MYSqlAccess

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
    return self;
}

#pragma mark - getter
- (FMDatabaseQueue *)dbQueue {
    if (_dbQueue == nil) {
        self.dbQueue = [[self class] openDB:self.writableDBPath password:self.password];
    }
    return _dbQueue;
}

- (NSInteger)currentVersionFor:(NSString *)plugin {
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
- (void)migratePlugin:(NSString *)plugin toVersion:(NSInteger)newVersion update:(void(^)(NSInteger oldVersion, MYSqlAccess *accessor))block {
    NSInteger currentVersion = [self currentVersionFor:plugin];
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


- (void)close {
    [[self class] closeDB:_dbQueue];
}

#pragma mark - class methods
+ (void)restore:(NSArray *)datas toDb:(FMDatabaseQueue *)newDbQueue toTable:(NSString *)ttable columnsMapTable:(NSDictionary *)mapTable confict:(NSString *)confict {
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
    confict = confict == nil ? @"" : [NSString stringWithFormat:@"OR %@", confict];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT %@ INTO %@", confict, ttable];
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

+ (void)closeDB:(FMDatabaseQueue *)db{
    [db close];
}

@end



@implementation MYSqlAccess (FileHelper)

#pragma mark - get file path
+ (NSString *)getTmpFile:(NSString *)fileName {
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile =[tmpDirectory stringByAppendingPathComponent:fileName];
    return tmpFile;
}

+ (NSString *)getCacheFile:(NSString *)fileName {
    NSString *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheFile =[cachesPath stringByAppendingPathComponent:fileName];
    return cacheFile;
}

+ (NSString *)getDocumentFile:(NSString *)fileName {
    NSArray *domainDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *writableDBPath = [[domainDir objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return writableDBPath;
}
+ (NSString *)getResourceFile:(NSString *)fileName {
    NSString *resourceDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return resourceDBPath;
}

+ (NSComparisonResult)compareDBDate:(NSString *)_newDBPath oldDBPath:(NSString *)_oldDBPath{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDate *oldDBDate = [[fm attributesOfItemAtPath:_oldDBPath error:&error] objectForKey:NSFileCreationDate];
	NSDate *newDBDate = [[fm attributesOfItemAtPath:_newDBPath error:&error] objectForKey:NSFileCreationDate];
	NSLog(@"%@:%@ %@ %@:%@", _oldDBPath, oldDBDate, [oldDBDate compare:newDBDate] == NSOrderedSame ? @"=":[oldDBDate compare:newDBDate] == NSOrderedAscending ? @"<":@">", _newDBPath, newDBDate);
	return [newDBDate compare:oldDBDate];
}

#pragma mark - SkipBackupAttribute
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@"5.0.1"]) {
        // for iOS 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@">=5.1"]) {
        // for iOS 5.1 and later
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            LogError(@"ERROR excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    return YES;
}

#pragma mark - copy db
+ (NSString *)copiedBundleDbIsExcludedFromBackupKey:(NSString *)_dbFileName
                                            replace:(BOOL)replace{
    NSString *resourceFile = [self getResourceFile:_dbFileName];
    NSString *documentFile = [self getDocumentFile:_dbFileName];
    NSString *cacheFile = [self getCacheFile:_dbFileName];
    NSString *lastedFile = resourceFile;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFile] && ![[self class] compareDBDate:documentFile oldDBPath:lastedFile] == NSOrderedDescending) {
        lastedFile = documentFile;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile] && ![[self class] compareDBDate:cacheFile oldDBPath:lastedFile] == NSOrderedDescending) {
        lastedFile = cacheFile;
    }
    NSString *toFile = nil;
    if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@"5.0"]) {
        toFile = cacheFile;
    } else {
        toFile = documentFile;
    }
    NSLog(@"lastedFile: %@ toFile: %@", lastedFile, toFile);
    if ([self copiedDb:lastedFile to:toFile replace:replace]) {
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:toFile]];
    } else {
        return nil;
    }
    if (toFile != documentFile && [[NSFileManager defaultManager] fileExistsAtPath:documentFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:documentFile error:nil];
    }
    if (toFile != cacheFile && [[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:cacheFile error:nil];
    }
    return toFile;
}

+ (NSString *)copiedBundleDbToTmp:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getTmpFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDbToCache:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getCacheFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDbToDocuments:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getDocumentFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDb:(NSString *)_dbFileName to:(NSString *)writableDBPath replace:(BOOL)replace{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getResourceFile:_dbFileName]])
        return nil;
    if ([self copiedDb:[self getResourceFile:_dbFileName] to:writableDBPath replace:replace]) {
        return writableDBPath;
    }
    return nil;
}
+ (BOOL)copiedDb:(NSString *)resourceDBPath to:(NSString *)writableDBPath replace:(BOOL)replace{
    if ([resourceDBPath isEqualToString:writableDBPath]) {
        return YES;
    }
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];

	// 如果文件存在
	if ([fm fileExistsAtPath:writableDBPath]) {
        if (!replace)
            return YES;
		// 如果文件是最新的
		if ([[self class] compareDBDate:resourceDBPath oldDBPath:writableDBPath] == NSOrderedSame)
            return YES;
        else {
            [fm removeItemAtPath:writableDBPath error:&error];
        }
    }
    // copy新数据
    NSLog(@"copy newDB...");
    return [fm copyItemAtPath:resourceDBPath toPath:writableDBPath error:&error];
}

@end