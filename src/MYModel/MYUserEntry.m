//
//  ONEBaseUserDbEntry.m
//  ONEBase
//
//  Created by Whirlwind on 12-12-1.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYUserEntry.h"
#import "MYUserEntryLog.h"
#import "MYEntryDbSchema.h"

@implementation MYUserEntry
- (void)dealloc {
    [_userKey release], _userKey = nil;
    [_remoteId release], _remoteId = nil;
    [_remoteCreatedAt release], _remoteCreatedAt = nil;
    [_remoteUpdatedAt release], _remoteUpdatedAt = nil;
    [super dealloc];
}

#pragma mark - override
+ (NSInteger)count {
    return [[[self fetcher] where:@"user_key = ?", [self userKey], nil] fetchCounter];
}

- (BOOL)save {
    if ([self.changes count] == 0)
        return YES;
    [self setUpdatedAt:[NSDate date]];
    return [super save];
}

- (BOOL)destroy {
    [self setUpdatedAt:[NSDate date]];
    return [super destroy];
}

+ (BOOL)isUserDb {
    return YES;
}

- (BOOL)logChanges:(NSDictionary *)changes usingDb:(FMDatabase *)db {
    NSMutableDictionary *logChanges = [NSMutableDictionary dictionaryWithDictionary:changes];
    [self.ignoreLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[MYEntryDbSchema sharedInstance] dbFieldNameForProperty:property forModel:[self class]];
        [logChanges removeObjectForKey:field];
    }];
    [self.extendLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[MYEntryDbSchema sharedInstance] dbFieldNameForProperty:property forModel:[self class]];
        if (field) {
            [logChanges setValue:[self performSelector:NSSelectorFromString(property)] forKey:field];
        }
    }];
    return [[MYUserEntryLog sharedInstance] logChangeForModel:[[self class] modelName]
                                                              localId:self.index
                                                             uniqueId:self.remoteId
                                                              changes:logChanges
                                                            updatedAt:self.updatedAt
                                                              usingDb:db];
}

- (BOOL)logDeleteUsingDb:(FMDatabase *)db {
    return [[MYUserEntryLog sharedInstance] logDeleteForModel:[[self class] modelName]
                                                              localId:self.index
                                                             uniqueId:self.remoteId
                                                            updatedAt:self.updatedAt
                                                              usingDb:db];
}

- (NSString *)userKey {
    return [[self class] userKey];
}

+ (NSString *)userKey {
    return @"";
}

#pragma mark - select
+ (NSString *)selectFirstRemoteCreateDateInLocal {
    return [[[[[self fetcher] select:@"remote_created_at", nil] where:@"remote_id IS NOT NULL", nil] orderBy:@"remote_created_at" ascending:YES] fetchString];
}
+ (NSString *)selectLatestRemoteUpdateDateInLocal {
    return [[[[[self fetcher] select:@"remote_updated_at", nil] where:@"remote_id IS NOT NULL", nil] orderBy:@"remote_updated_at" ascending:NO] fetchString];
}

#pragma mark destory
+ (BOOL)destoryInLocalWithRemoteId:(NSNumber *)_id {
    return [[[self fetcher] where:@"remote_id = ?", _id, nil] deleteDb];
}
+ (BOOL)destoryInLocalWithRemoteIdArray:(NSArray *)ids {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[ids count]];
    for (NSInteger i = 0; i < [ids count]; i++) {
        [tmp addObject:@"?"];
    }
    return [[[self fetcher] where:[NSString stringWithFormat:@"remote_id in (%@)", [tmp componentsJoinedByString:@", "]] argsInArray:ids] deleteDb];
}
#pragma mark update
+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic usingDb:(FMDatabase *)db{
    if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
        return YES;
    }
    MYUserEntry *entry = [[MYUserEntry alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"id"]) {
            key = @"remote_id";
        } else if ([key isEqualToString:@"updated_at"]) {
            key = @"remote_updated_at";
        } else if ([key isEqualToString:@"created_at"]) {
            key = @"remote_created_at";
        }
        SEL setProperty = [self convertDbFieldNameToSetSelector:key];
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
    return [[[self fetcher] filterUserKey:@" "] fetchCounter] > 0;
}

+ (BOOL)setAnonymousDataToCurrentUserData {
    NSString *user = [self userKey];
    if ([user isEqualToString:@" "]) {
        return NO;
    }
    return [[[[self fetcher] filterUserKey:@" "] update:@{@"user_key" : user}] updateDb];
}
@end
