//
//  MYDbFetcher.m
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-25.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYDbFetcher.h"

@implementation MYDbFetcher
#pragma mark - class methods
+ (id)fetcherForTableName:(NSString *)tableName {
    return [[[self alloc] initWithTableName:tableName] autorelease];
}

#pragma mark - dealloc
- (void)dealloc {
    [_db release], _db = nil;
    [_dbQueue release], _dbQueue = nil;
    [_orderBy release], _orderBy = nil;
    [_limit release], _limit = nil;
    [_offset release], _offset = nil;
    [_wheres release], _wheres = nil;
    [_fields release], _fields = nil;
    [_updateDictionary release], _updateDictionary = nil;
    [_tableName release], _tableName = nil;
    [super dealloc];
}

#pragma mark - init
- (id)initWithTableName:(NSString *)tableName {
    if (self = [self init]) {
        self.tableName = tableName;
    }
    return self;
}

- (NSMutableArray *)wheres {
    if (_wheres == nil) {
        _wheres = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _wheres;
}

#pragma mark offset
- (id)offset:(NSInteger)offset {
    self.offset = [NSNumber numberWithInteger:offset];
    return self;
}

#pragma mark limit
- (id)limit:(NSInteger)limit {
    self.limit = [NSNumber numberWithInteger:limit];
    return self;
}

#pragma mark order by
- (id)orderBy:(NSString *)aField
                         ascending:(BOOL)isAscending {
    NSArray *orderBy = @[aField, [NSNumber numberWithBool:isAscending]];
    if (_orderBy == nil) {
        _orderBy = [[NSMutableArray alloc] initWithObjects:orderBy, nil];
    } else {
        [_orderBy addObject:orderBy];
    }
    return self;
}

- (id)orderBy:(NSString *)aField {
    return [self orderBy:aField ascending:YES];
}

#pragma mark select
- (id)select:(NSString *)aFirstParam, ... {
    if (_fields == nil) {
        _fields = [[NSMutableArray alloc] initWithObjects:aFirstParam, nil];
    } else {
        [_fields addObject:aFirstParam];
    }
    va_list args;
    va_start(args, aFirstParam);
    NSString *field = nil;
    while((field = va_arg(args, NSString *))) {
        [_fields addObject:field];
    }
    va_end(args);
    return self;
}
- (id)selectInArray:(NSArray *)fields {
    if (_fields == nil) {
        _fields = [[NSMutableArray alloc] initWithArray:fields];
    } else {
        [_fields addObjectsFromArray:fields];
    }
    return self;
}

#pragma mark where
- (id)where:(NSString *)aCondition, ... {
    NSMutableArray *conditions = [[NSMutableArray alloc] initWithObjects:aCondition, nil];

    va_list args;
    va_start(args, aCondition);
    NSObject *condition = nil;
    while((condition = va_arg(args, NSObject *))) {
        [conditions addObject:condition];
    }
    va_end(args);
    [self.wheres addObject:conditions];
    [conditions release];
    return self;
}

- (id)where:(NSString *)aCondition argsInArray:(NSArray *)args {
    NSMutableArray *conditions = [[NSMutableArray alloc] initWithObjects:aCondition, nil];
    [conditions addObjectsFromArray:args];
    [self.wheres addObject:conditions];
    [conditions release];
    return self;
}

#pragma mark update
- (id)update:(NSDictionary *)updateDic {
    if (_updateDictionary == nil) {
        _updateDictionary = [[NSMutableDictionary alloc] initWithDictionary:updateDic copyItems:YES];
    } else {
        [_updateDictionary setValuesForKeysWithDictionary:updateDic];
    }
    return self;
}

#pragma mark insert
- (id)insert:(NSDictionary *)insertDic {
    return [self update:insertDic];
}

#pragma mark - using
- (id)usingDb:(FMDatabase *)db {
    self.db = db;
    return self;
}

- (id)usingDbQueue:(FMDatabaseQueue *)dbQueue {
    self.dbQueue = dbQueue;
    return self;
}
#pragma mark - fetch
- (void)fetchDbInDb:(FMDatabase *)db withBlock:(void (^)(FMResultSet *rs))block {
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [self buildSelectSqlWithArgs:&args];
    __block FMResultSet *rs = nil;
    rs = [db executeQuery:sql withArgumentsInArray:args];
    if ([db hadError]) {
        LogError(@"ERROR! %@ : %@", sql, [db lastError]);
    }
    [args release];
    block(rs);
    [rs close];
}

- (void)fetchDbWithBlock:(void(^)(FMResultSet *rs))block {
    NSAssert(self.dbQueue != nil || self.db != nil, @"dbQueue IS nil");
    if (self.db) {
        [self fetchDbInDb:self.db withBlock:block];
    } else {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [self fetchDbInDb:db withBlock:block];
        }];
    }
}

- (NSInteger)fetchInteger {
    NSNumber *num = [self fetchNumber];
    if (num) {
        return [num integerValue];
    }
    return NSNotFound;
}

- (NSNumber *)fetchNumber {
    __block NSNumber *result = nil;
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            result = (NSNumber *)[rs objectForColumnIndex:0];
        }
    }];
    if ([result isKindOfClass:[NSNull class]])
        return nil;
    return result;
}
- (NSString *)fetchString {
    __block NSString *result = nil;
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            result = [rs stringForColumnIndex:0];
        }
    }];
    if ([result isKindOfClass:[NSNull class]])
        return nil;
    return result;
}

- (NSArray *)fetchDictionaryArray {
    __block NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
    }];
    return [result autorelease];
}

- (NSDictionary *)fetchDictionary {
    [self limit:1];
    __block NSDictionary *result = nil;
    [self fetchDbWithBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            result = [[rs resultDictionary] retain];
        }
    }];
    return [result autorelease];
}

- (NSInteger)fetchCounter {
    [self.fields removeAllObjects];
    [self select:@"count(*)", nil];
    return [self fetchInteger];
}
#pragma mark - update
- (BOOL)updateDb {
    return [self updateDb:nil];
}

- (BOOL)updateDbUsingDb:(FMDatabase *)db
                  block:(BOOL(^)(FMDatabase *db))block {
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [self buildUpdateSqlWithArgs:&args];
    if ([db executeUpdate:sql withArgumentsInArray:args]) {
        if (block) {
            return block(db);
        }
        return YES;
    } else {
        LogError(@"ERROR! %@ : %@", sql, [db lastErrorMessage]);
        return NO;
    }
}

- (BOOL)updateDb:(BOOL(^)(FMDatabase *db))block {
    if (self.db) {
        return [self updateDbUsingDb:self.db
                               block:block];
    }
    __block BOOL status = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        status = [self updateDbUsingDb:db block:block];
        *rollback = !status;
    }];
    return status;
}

#pragma mark - insert
- (BOOL)insertDb {
    return [self insertDbWithReplace:NO];
}
- (BOOL)insertDbWithReplace:(BOOL)replace {
    return [self insertDb:nil replace:replace];
}
- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block {
    return [self insertDb:block replace:NO];
}
- (BOOL)insertDbUsingDb:(FMDatabase *)db
                  block:(BOOL(^)(FMDatabase *db, NSInteger insertId))block
                replace:(BOOL)replace {
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [self buildInsertSqlWithArgs:&args replace:replace];
    if ([db executeUpdate:sql withArgumentsInArray:args]) {
        if (block) {
            NSInteger insertId = [db lastInsertRowId];
            return block(db, insertId);
        }
        return YES;
    } else {
        LogError(@"ERROR! %@ : %@", sql, [db lastErrorMessage]);
        return NO;
    }
}

- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block
         replace:(BOOL)replace {
    if (self.db) {
        return [self insertDbUsingDb:self.db
                               block:block
                             replace:replace];
    } else {
        __block BOOL status = NO;
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            status = [self insertDbUsingDb:db
                                   block:block
                                 replace:replace];
            *rollback = !status;
        }];
        return status;
    }
}
#pragma mark - delete
- (BOOL)deleteDb {
    return [self deleteDb:nil];
}
- (BOOL)deleteDbUsingDb:(FMDatabase *)db block:(BOOL (^)(FMDatabase *db))block {
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *whereStatement = [self createWhereStatementWithArgs:&args];
    NSString *sql = nil;
    if (whereStatement && ![whereStatement isEqualToString:@""]) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", self.tableName, whereStatement];
    } else {
        sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];
    }
    if ([db executeUpdate:sql withArgumentsInArray:args]) {
        [args release];
        if (block) {
            return block(db);
        }
        return YES;
    } else {
        [args release];
        LogError(@"ERROR! %@ : %@", sql, [db lastErrorMessage]);
        return NO;
    }
}
- (BOOL)deleteDb:(BOOL(^)(FMDatabase *db))block {
    if (self.db) {
        return [self deleteDbUsingDb:self.db
                               block:block];
    } else {
        __block BOOL status = NO;
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            status = [self deleteDbUsingDb:db
                                     block:block];
            *rollback = !status;
        }];
        return status;
    }
}

#pragma mark - private
- (NSString *)buildSelectSqlWithArgs:(NSMutableArray **)args {
    NSString *selectStatement = [self createSelectStatement];
    NSString *whereStatement = [self createWhereStatementWithArgs:args];
    NSString *orderStatement = [self createOrderStatement];
    NSString *limitOffsetStatement = [self createLimitOffsetStatement];

    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT %@ FROM `%@`", selectStatement, self.tableName];
    if (whereStatement && ![whereStatement isEqualToString:@""]) {
        [sql appendFormat:@" WHERE %@", whereStatement];
    }
    if (orderStatement && ![orderStatement isEqualToString:@""]) {
        [sql appendFormat:@" ORDER BY %@", orderStatement];
    }
    if (limitOffsetStatement && ![limitOffsetStatement isEqualToString:@""]) {
        [sql appendFormat:@" %@", limitOffsetStatement];
    }
    return sql;
}

- (NSString *)buildUpdateSqlWithArgs:(NSMutableArray **)args {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:[self.updateDictionary count]];
    [self.updateDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [tmp addObject:[NSString stringWithFormat:@"`%@` = ?", key]];
        [*args addObject:obj];
    }];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE `%@` SET %@", self.tableName, [tmp componentsJoinedByString:@", "]];
    [tmp release], tmp = nil;

    NSMutableArray *whereArgs = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *whereStatement = [self createWhereStatementWithArgs:&whereArgs];
    if (whereStatement && ![whereStatement isEqualToString:@""]) {
        [sql appendFormat:@" WHERE %@", whereStatement];
        [*args addObjectsFromArray:whereArgs];
    }
    [whereArgs release];
    return sql;
}

- (NSString *)buildInsertSqlWithArgs:(NSMutableArray **)args replace:(BOOL)replace {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:[self.updateDictionary count]+1];
    NSMutableArray *tmp2 = [[NSMutableArray alloc] initWithCapacity:[self.updateDictionary count]+1];
    [self.updateDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [tmp addObject:[NSString stringWithFormat:@"`%@`", key]];
        [tmp2 addObject:@"?"];
        [*args addObject:obj];
    }];
    NSString *sql = [NSString stringWithFormat:@"INSERT %@ INTO `%@` (%@) VALUES (%@)", replace ? @"OR REPLACE" : @"", self.tableName, [tmp componentsJoinedByString:@", "], [tmp2 componentsJoinedByString:@", "]];
    [tmp release], tmp = nil;
    [tmp2 release], tmp2 = nil;
    return sql;
}
- (NSString *)createSelectStatement {
    if (_fields == nil) {
        return @"*";
    }
    return [self.fields componentsJoinedByString:@", "];
}

- (NSString *)createWhereStatementWithArgs:(NSMutableArray **)args {
    if (_wheres == nil || [_wheres count] == 0) {
        return nil;
    }
    NSMutableArray *whereStrArray = [[NSMutableArray alloc] initWithCapacity:[self.wheres count]];
    [self.wheres enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [whereStrArray addObject:[NSString stringWithFormat:@"(%@)", obj]];
        } else {
            [(NSArray *)obj enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
                if (idx == 0) {
                    [whereStrArray addObject:[NSString stringWithFormat:@"(%@)", obj]];
                } else {
                    [*args addObject:obj];
                }
            }];
        }
    }];
    return [whereStrArray componentsJoinedByString:@" AND "];
}

- (NSString *)createLimitOffsetStatement {
    if (_limit == nil && _offset == nil) {
        return nil;
    }
    NSString *limitStr = nil;
    if (_limit) {
        limitStr = [NSString stringWithFormat:@"LIMIT %d", [self.limit integerValue]];
        if (_offset == nil) {
            return limitStr;
        }
    }
    NSString *offsetStr = nil;
    if (_offset) {
        offsetStr = [NSString stringWithFormat:@"OFFSET %d", [self.offset integerValue]];
        if (_limit == nil) {
            return offsetStr;
        }
    }
    return [NSString stringWithFormat:@"%@ %@", limitStr, offsetStr];
}

- (NSString *)createOrderStatement {
    if (self.orderBy == nil || [self.orderBy count] == 0) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self.orderBy count]];
    [self.orderBy enumerateObjectsUsingBlock:^(NSArray *order, NSUInteger idx, BOOL *stop) {
        [array addObject:[NSString stringWithFormat:@"%@ %@", order[0], [order[1] boolValue] ? @"ASC" : @"DESC"]];
    }];
    return [array componentsJoinedByString:@", "];
}
@end
