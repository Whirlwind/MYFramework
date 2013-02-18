//
//  ONEBaseDbEntry+DatabaseWriter.m
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry+DatabaseWriter.h"
#import "MYEntryDbSchema.h"

@implementation MYEntry (DatabaseWriter)

- (NSDictionary *)changesDictionary {
    NSMutableDictionary *changeDic = [[NSMutableDictionary alloc] initWithCapacity:[self.changes count]];
    [self.changes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *field = [[MYEntryDbSchema sharedInstance] dbFieldNameForProperty:key forModel:[self class]];
        changeDic[field] = obj[1];
    }];
    return [changeDic autorelease];
}
#pragma mark - C
- (BOOL)createEntryInDb {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[[self fetcher] insert:changeDic] insertDb:^BOOL(FMDatabase *db, NSInteger insertId) {
        self.index = [NSNumber numberWithInteger:insertId];
        if (self.needLog && ![self logChanges:changeDic usingDb:db]) {
            return NO;
        }
        return YES;
    } replace:self.insertModeUsingReplace];
    if (status)
        [self postLocalChangeNotification];
    return status;
}

#pragma mark - U
- (BOOL)updateEntryInDb {
    NSDictionary *changeDic = [self changesDictionary];
    BOOL status = [[[[self fetcher] where:@"id = ?", self.index, nil] update:changeDic] updateDb:^BOOL(FMDatabase *db) {
        if (self.needLog && ![self logChanges:changeDic usingDb:db]) {
            return NO;
        }
        return YES;
    }];
    if (status)
        [self postLocalChangeNotification];
    return status;
}

#pragma mark - D
- (BOOL)removeEntryInDb {
    if (self.index == nil) {
        return YES;
    }
    BOOL status = [[[self fetcher] where:@"id = ?", self.index, nil] deleteDb:^BOOL(FMDatabase *db) {
        if (self.needLog && ![self logDeleteUsingDb:db]) {
            return NO;
        }
        return YES;
    }];
    if (status)
        [self postLocalChangeNotification];
    return status;
}

+ (BOOL)clearInDb {
    BOOL status = [[self fetcher] deleteDb];
    if (status)
        [self postLocalChangeNotification];
    return status;
}
#pragma mark - DAO
+ (NSString *)convertPropertyNameToDbFieldName:(NSString *)name {
    NSAssert(NO, @"method NOT implemented!");
    return nil;
}

+ (NSString *)convertDbFieldNameToPropertyName:(NSString *)name {
    if ([name isEqualToString:@"id"]) {
        return @"index";
    }
    return [self convertRailsStylePropertyToAppleStyleProperty:name];
}

+ (SEL)convertDbFieldNameToSetSelector:(NSString *)name {
    NSString *property = [self convertDbFieldNameToPropertyName:name];
    return [self setterFromPropertyString:property];
}

@end
