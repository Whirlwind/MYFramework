//
//  MYEntrySqlAccessWithLog.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-10.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntrySqlAccessWithLog.h"
#import "MYEntryWithSync.h"
#import "MYEntryInDbLog.h"
@interface MYEntrySqlAccess (private)

- (NSDictionary *)changesDictionary;

@end

@implementation MYEntrySqlAccessWithLog

#pragma mark - DAO
#pragma mark C
- (BOOL)createEntry {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[self insert:changeDic] insertDb:^BOOL(FMDatabase *db, NSInteger insertId) {
        self.entry.index = [NSNumber numberWithInteger:insertId];
        if (((MYEntryWithSync *)(self.entry)).needLog && ![self logChanges:changeDic usingDb:db]) {
            return NO;
        }
        return YES;
    } replace:self.insertModeUsingReplace];
    return status;
}

#pragma mark U
- (BOOL)updateEntry {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[[self where:@"id = ?", self.entry.index, nil] update:changeDic] updateDb:^BOOL(FMDatabase *db) {
        if (((MYEntryWithSync *)(self.entry)).needLog && ![self logChanges:changeDic usingDb:db]) {
            return NO;
        }
        return YES;
    }];
    return status;
}

#pragma mark D
- (BOOL)removeEntry {
    if (self.entry.index == nil) {
        return YES;
    }
    BOOL status = [[self where:@"id = ?", self.entry.index, nil] deleteDb:^BOOL(FMDatabase *db) {
        if (((MYEntryWithSync *)(self.entry)).needLog && ![self logDeleteUsingDb:db]) {
            return NO;
        }
        return YES;
    }];
    return status;
}

#pragma mark - log
- (BOOL)logChanges:(NSDictionary *)changes usingDb:(FMDatabase *)db {
    NSMutableDictionary *logChanges = [NSMutableDictionary dictionaryWithDictionary:changes];
    [((MYEntryWithSync *)(self.entry)).ignoreLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[self class] convertPropertyNameToDbFieldName:property];
        [logChanges removeObjectForKey:field];
    }];
    [((MYEntryWithSync *)(self.entry)).extendLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[self class] convertPropertyNameToDbFieldName:property];
        if (field) {
            [logChanges setValue:[self performSelector:NSSelectorFromString(property)] forKey:field];
        }
    }];
    return [MYEntryInDbLog logChangeForModel:[self modelName]
                                     localId:self.entry.index
                                    uniqueId:self.entry.remoteId
                                     userKey:self.entry.userKey
                                     changes:logChanges
                                   updatedAt:self.entry.updatedAt
                                     usingDb:db];
}

- (BOOL)logDeleteUsingDb:(FMDatabase *)db {
    return [MYEntryInDbLog logDeleteForModel:[self modelName]
                                     localId:self.entry.index
                                    uniqueId:self.entry.remoteId
                                     userKey:self.entry.userKey
                                   updatedAt:self.entry.updatedAt
                                     usingDb:db];
}

#pragma mark - private
- (NSString *)modelName {
    if ([self.entry respondsToSelector:@selector(modelName)]) {
        return [self.entry performSelector:@selector(modelName)];
    }
    return [(id)self.entry tableName];
}
@end
