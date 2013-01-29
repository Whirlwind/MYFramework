//
//  FMDatabase+MYAdditions.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

@interface FMDatabase (MYAdditions)
- (NSArray *)getTableColumns:(NSString *)table;
@end

@interface FMResultSet (NSString2NSDate)
- (NSDate*)stringDateTimeForColumn:(NSString*)columnName;
- (NSDate*)stringDateTimeForColumn:(NSString*)columnName
                        withFormat:(NSString *)format;
- (NSDate*)stringDateTimeForColumnIndex:(int)columnIdx;
- (NSDate*)stringDateTimeForColumnIndex:(int)columnIdx
                             withFormat:(NSString *)format;
@end

@interface FMDatabaseQueue (MYAdditions)

- (NSArray *)getTableColumns:(NSString *)table;

- (BOOL)executeUpdate:(NSString*)sql, ...;

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
@end