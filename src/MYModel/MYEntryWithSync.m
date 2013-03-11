//
//  MYEntryWithSync.m
//  ONEBase
//
//  Created by Whirlwind on 12-12-1.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntryWithSync.h"

@implementation MYEntryWithSync
@synthesize tableName = _tableName;
@synthesize dbQueue = _dbQueue;

- (void)dealloc {
    [_tableName release], _tableName = nil;
    [_dbQueue release], _dbQueue = nil;
    [_remoteCreatedAt release], _remoteCreatedAt = nil;
    [_remoteUpdatedAt release], _remoteUpdatedAt = nil;
    [_ignoreLogProperties release], _ignoreLogProperties = nil;
    [_extendLogProperties release], _extendLogProperties = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        self.needLog = [[self class] needLog];
    }
    return self;
}

- (NSString *)tableName {
    if (_tableName == nil) {
        return [[self class] tableName];
    }
    return _tableName;
}

- (FMDatabaseQueue *)dbQueue {
    if (_dbQueue == nil) {
        return [[self class] dbQueue];
    }
    return _dbQueue = nil;
}

+ (BOOL)needLog {
    return YES;
}

- (NSMutableArray *)extendLogProperties {
    if (_extendLogProperties == nil) {
        _extendLogProperties = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _extendLogProperties;
}

- (NSMutableArray *)ignoreLogProperties {
    if (_ignoreLogProperties == nil) {
        _ignoreLogProperties = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _ignoreLogProperties;
}

+ (id<MYEntryDataAccessProtocol>)dataAccessor {
    return [[[MYEntrySqlAccessWithLog alloc] initWithEntryClass:self] autorelease];
}


#pragma mark - select
+ (NSString *)selectFirstRemoteCreateDateInLocal {
    return [[[[(MYEntrySqlAccess *)[self dataAccessor] select:@"remote_created_at", nil] where:@"remote_id IS NOT NULL", nil] orderBy:@"remote_created_at" ascending:YES] fetchString];
}

+ (NSString *)selectLatestRemoteUpdateDateInLocal {
    return [[[[(MYEntrySqlAccess *)[self dataAccessor] select:@"remote_updated_at", nil] where:@"remote_id IS NOT NULL", nil] orderBy:@"remote_updated_at" ascending:NO] fetchString];
}

#pragma mark destory
+ (BOOL)destoryInLocalWithRemoteId:(NSNumber *)_id {
    return [[[self dataAccessor] where:@"remote_id = ?", _id, nil] deleteDb];
}
+ (BOOL)destoryInLocalWithRemoteIdArray:(NSArray *)ids {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[ids count]];
    for (NSInteger i = 0; i < [ids count]; i++) {
        [tmp addObject:@"?"];
    }
    return [[[self dataAccessor] where:[NSString stringWithFormat:@"remote_id in (%@)", [tmp componentsJoinedByString:@", "]] argsInArray:ids] deleteDb];
}
#pragma mark update
+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic usingDb:(FMDatabase *)db{
    if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
        return YES;
    }
    MYEntryWithSync *entry = [[MYEntryWithSync alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"id"]) {
            key = @"remote_id";
        } else if ([key isEqualToString:@"updated_at"]) {
            key = @"remote_updated_at";
        } else if ([key isEqualToString:@"created_at"]) {
            key = @"remote_created_at";
        }
        NSString *property = [[self class] convertDbFieldNameToPropertyName:key];
        SEL setProperty = [self setterFromPropertyString:property];
        if ([entry respondsToSelector:setProperty]) {
            [entry performSelector:setProperty withObject:obj];
        }
    }];
    return [entry save];
}
+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic {
    __block BOOL status = YES;
    [[self dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        status = [self saveInLocalWithJSONDictionary:dic usingDb:db];
        *rollback = !status;
    }];
    return status;
}
+ (BOOL)saveInLocalWithJSONArray:(NSArray *)array {
    __block BOOL status = YES;
    [[self dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            status = [self saveInLocalWithJSONDictionary:obj usingDb:db];
            *stop = *rollback = !status;
        }];
    }];
    return status;
}

#pragma mark - anonymous
+ (BOOL)existAnonymousData {
    return [[[self dataAccessor] filterUserKey:@" "] fetchCounter] > 0;
}

+ (BOOL)setAnonymousDataToCurrentUserData {
    NSString *user = [self userKey];
    if (user == nil || [user isEqualToString:@" "]) {
        return NO;
    }
    return [[[[self dataAccessor] filterUserKey:@" "] update:@{@"user_key" : user}] updateDb];
}
@end
