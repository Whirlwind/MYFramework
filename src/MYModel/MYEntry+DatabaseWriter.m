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
- (BOOL)createEntry {
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
- (BOOL)updateEntry {
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
- (BOOL)removeEntry {
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
    NSArray *pieces = [name componentsSeparatedByString:@"_"];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:[pieces count]] autorelease];
    [pieces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [array addObject:obj];
        } else {
            [array addObject:[obj capitalizedString]];
        }
    }];
    return [array componentsJoinedByString:@""];
}

+ (SEL)convertDbFieldNameToSetSelector:(NSString *)name {
    NSString *property = [self convertDbFieldNameToPropertyName:name];
    NSString *firstCapChar = [[property substringToIndex:1] capitalizedString];
    NSString *cappedString = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", cappedString]);
}

- (BOOL)saveInDb {
    if (self.index != nil && [self.changes count] <= 0) {
        return YES;
    }
    if (self.index == nil) { // C
        if ([self createEntry]) {
            [self.changes removeAllObjects];
            return YES;
        }
        return NO;
    } else { // U
        if ([self updateEntry]) {
            [self.changes removeAllObjects];
            return YES;
        }
        return NO;
    }
    return NO;
}
- (BOOL)destroyInDb {
    return [self removeEntry];
}
@end
