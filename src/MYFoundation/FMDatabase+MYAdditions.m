//
//  FMDatabase+MYAdditions.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "FMDatabase+MYAdditions.h"
#import "NSDate+Extend.h"

@implementation FMDatabase (MYAdditions)

- (NSArray *)getTableColumns:(NSString *)table {
    NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:5];
    FMResultSet *rs = [self getTableSchema:table];
    while ([rs next]) {
        [columns addObject:[rs stringForColumnIndex:1]];
    }
    [rs close];
    return [columns autorelease];
}
@end

@implementation FMResultSet (NSString2NSDate)
- (NSDate*)stringDateTimeForColumn:(NSString*)columnName {
    NSString *v = [self stringForColumn:columnName];
    if (v) {
        return [NSDate dateFromString:v];
    }
    return nil;
}
- (NSDate*)stringDateTimeForColumnIndex:(int)columnIdx {
    NSString *v = [self stringForColumnIndex:columnIdx];
    if (v) {
        return [NSDate dateFromString:v];
    }
    return nil;
}
- (NSDate*)stringDateTimeForColumn:(NSString*)columnName
                        withFormat:(NSString *)format{
    NSString *v = [self stringForColumn:columnName];
    if (v) {
        return [NSDate dateFromString:v withFormat:format];
    }
    return nil;
}
- (NSDate*)stringDateTimeForColumnIndex:(int)columnIdx
                             withFormat:(NSString *)format{
    NSString *v = [self stringForColumnIndex:columnIdx];
    if (v) {
        return [NSDate dateFromString:v withFormat:format];
    }
    return nil;
}
@end

@implementation FMDatabaseQueue (MYAdditions)

- (NSArray *)getTableColumns:(NSString *)table {
    __block NSArray *columns = nil;
    [self inDatabase:^(FMDatabase *db) {
        columns = [db getTableColumns:table];
    }];
    return columns;
}

- (BOOL)executeUpdate:(NSString*)sql, ... {
    __block BOOL state = YES;
    va_list args;
    va_start(args, sql);
    [self inDatabase:^(FMDatabase *db) {

        state = [db executeUpdate:sql error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
        if ([db hadError]) {
            LogError(@"ERROR! %@; %@", sql, db.lastErrorMessage);
        }
    }];
    va_end(args);
    return state;
}

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    __block BOOL status = NO;
    [self inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:sql withArgumentsInArray:arguments]) {
            LogError(@"ERROR! %@; %@", sql, db.lastErrorMessage);
        } else {
            status = YES;
        }
    }];
    return status;
}
@end
