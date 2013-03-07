//
//  MYEntrySqlAccess.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-19.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntrySqlAccess.h"
#import "MYDbSchema.h"
#import "MYDbManager.h"
#import "MYEntry+SqlAccess.h"

@interface MYDbFetcher (public)
- (NSString *)createWhereStatementWithArgs:(NSMutableArray **)args;
- (NSString *)buildInsertSqlWithArgs:(NSMutableArray **)args replace:(BOOL)replace;
@end

@interface MYEntrySqlAccess ()
@property (copy, nonatomic) NSString *userKey;
@end

@implementation MYEntrySqlAccess

@synthesize entry = _entry;
@synthesize entryClass = _entryClass;

- (void)dealloc {
    [_entry release], _entry = nil;
    _entryClass = nil;
    [_userKey release], _userKey = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        self.insertModeUsingReplace = YES;
    }
    return self;
}

- (id)initWithEntry:(MYEntry<MYEntrySqlAccessProtocol> *)entry {
    if (self = [self init]) {
        self.entry = entry;
        [[MYDbSchema sharedInstance] loadSchemaInTable:self.tableName
                                               dbQueue:self.dbQueue];
    }
    return self;
}

- (id)initWithEntryClass:(Class)entryClass {
    if (self = [self init]) {
        self.entryClass = entryClass;
        [[MYDbSchema sharedInstance] loadSchemaInTable:self.tableName
                                               dbQueue:self.dbQueue];
    }
    return self;
}

#pragma mark - getter
- (Class)entryClass {
    if (_entryClass == nil && self.entry != nil) {
        return [self.entry class];
    }
    return _entryClass;
}

- (FMDatabaseQueue *)dbQueue {
    if ([super dbQueue] == nil) {
        if (self.entry && [self.entry respondsToSelector:@selector(dbQueue)]) {
            self.dbQueue = [self.entry performSelector:@selector(dbQueue)];
        } else {
            self.dbQueue = [self.entryClass dbQueue];
        }
    }
    return [super dbQueue];
}

- (NSString *)tableName {
    if ([super tableName] == nil) {
        NSString *tb = nil;
        if (self.entry && [self.entry respondsToSelector:@selector(tableName)]) {
            tb = [self.entry performSelector:@selector(tableName)];
        }
        if (tb == nil) {
            tb = [self.entryClass tableName];
        }
        self.tableName = tb;
    }
    return [super tableName];
}

- (NSArray *)dataFields {
    return [[MYDbSchema sharedInstance] columnsForTable:self.tableName];
}

- (NSArray *)dataProperties {
    NSArray *fields = [self dataFields];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[fields count]];
    [fields enumerateObjectsUsingBlock:^(NSString *field, NSUInteger idx, BOOL *stop) {
        [array addObject:[self.entryClass convertDbFieldNameToPropertyName:field]];
    }];
    return [array autorelease];
}

#pragma mark - override
- (NSString *)createWhereStatementWithArgs:(NSMutableArray **)args {
    if ([[MYDbSchema sharedInstance] hasColumn:@"user_key" forTable:self.tableName]) {
        [self where:@"user_key = ?", self.userKey, nil];
    }
    return [super createWhereStatementWithArgs:args];
}

- (NSString *)buildInsertSqlWithArgs:(NSMutableArray **)args replace:(BOOL)replace {
    if (![self.updateDictionary existKey:@"user_key"] && [[MYDbSchema sharedInstance] hasColumn:@"user_key" forTable:self.tableName]) {
        self.updateDictionary[@"user_key"] = self.userKey;
    }
    return [super buildInsertSqlWithArgs:args replace:replace];
}

#pragma mark - DAO
#pragma mark C
- (BOOL)createEntry {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[self insert:changeDic] insertDb:^BOOL(FMDatabase *db, NSInteger insertId) {
        self.entry.index = [NSNumber numberWithInteger:insertId];
//        if (self.needLog && ![self logChanges:changeDic usingDb:db]) {
//            return NO;
//        }
        return YES;
    } replace:self.insertModeUsingReplace];
    return status;
    
}

#pragma mark U
- (BOOL)updateEntry {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[[self where:@"id = ?", self.entry.index, nil] update:changeDic] updateDb:^BOOL(FMDatabase *db) {
//        if (self.needLog && ![self logChanges:changeDic usingDb:db]) {
//            return NO;
//        }
        return YES;
    }];
    return status;
}

#pragma mark R

- (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs {
    if ([self.entryClass respondsToSelector:@selector(fetchRecordFromResultSet:)]) {
        return [self.entryClass performSelector:@selector(fetchRecordFromResultSet:) withObject:rs];
    }
    NSDictionary *dic = [rs resultDictionary];
    MYEntry *entry = [[self.entryClass alloc] init];
    [entry disableListenProperty:^{
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *property = [self.entryClass convertDbFieldNameToPropertyName:key];
            SEL setProperty = [[self entryClass] setterFromPropertyString:property];
            if ([entry respondsToSelector:setProperty]) {
                [entry performSelector:setProperty withObject:[obj isEqual:[NSNull null]] ? nil : obj];
            }
        }];
    }];
    return [entry autorelease];
}

- (NSArray *)fetchRecords {
    __block NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        while ([rs next]) {
            [result addObject:[self fetchRecordFromResultSet:rs]];
        }
    }];
    return [result autorelease];
}

- (MYEntry *)fetchRecord {
    [self limit:1];
    __block MYEntry *result = nil;
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            result = [self fetchRecordFromResultSet:rs];
        }
    }];
    return result;
}

#pragma mark D
- (BOOL)removeEntry {
    if (self.entry.index == nil) {
        return YES;
    }
    BOOL status = [[self where:@"id = ?", self.entry.index, nil] deleteDb:^BOOL(FMDatabase *db) {
//        if (self.needLog && ![self logDeleteUsingDb:db]) {
//            return NO;
//        }
        return YES;
    }];
    return status;
}

- (BOOL)clearEntries {
    BOOL status = [self deleteDb];
    return status;
}

#pragma mark - private
- (NSDictionary *)changesDictionary {
    NSMutableDictionary *changeDic = [[NSMutableDictionary alloc] initWithCapacity:[self.entry.changes count]];
    [self.entry.changes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *field = [self.entryClass convertPropertyNameToDbFieldName:key];
        changeDic[field] = obj[1];
    }];
    return [changeDic autorelease];
}


#pragma mark - MYEntryDataAccessProtocol

- (MYDbFetcher *)filterUserKey:(NSString *)userKey {
    self.userKey = userKey;
    return self;
}

- (MYEntry *)firstEntry {
    return [(MYEntrySqlAccess *)[[self orderBy:@"id"] limit:1] fetchRecord];
}
- (NSInteger)countEntries {
    return [self fetchCounter];
}
- (MYEntry *)entryAt:(NSNumber *)index {
    return [(MYEntrySqlAccess *)[self where:@"id = ?", index, nil] fetchRecord];
}
- (BOOL)existEntry {
    return [self fetchCounter] > 0;
}
@end
