//
//  MYDbFetcher+MYEntry.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDbFetcher+MYEntry.h"

@implementation MYDbFetcher (MYEntry)

+ (MYDbFetcher *)fetcherForEntryClass:(Class)entryClass {
    return [[[self alloc] initWithEntryClass:entryClass] autorelease];
}

- (id)initWithEntryClass:(Class)entryClass {
    if (self = [self initWithTableName:[(MYEntry *)entryClass tableName]]) {
        self.entryClass = entryClass;
        self.dbQueue = [entryClass dbQueue];
    }
    return self;
}
- (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs {
    NSAssert(self.entryClass != nil, @"");
    if ([self.entryClass respondsToSelector:@selector(fetchRecordFromResultSet:)]) {
        return [self.entryClass performSelector:@selector(fetchRecordFromResultSet:) withObject:rs];
    }
    NSDictionary *dic = [rs resultDictionary];
    MYEntry *entry = [[self.entryClass alloc] init];
    [entry disableListenProperty:^{
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            SEL setProperty = [self.entryClass convertDbFieldNameToSetSelector:key];
            if ([entry respondsToSelector:setProperty]) {
                [entry performSelector:setProperty withObject:[obj isEqual:[NSNull null]] ? nil : obj];
            }
        }];
    }];
    return [entry autorelease];
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
@end
