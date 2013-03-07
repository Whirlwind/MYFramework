//
//  MYDbFetcher.h
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-25.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase+MYAdditions.h"


@interface MYDbFetcher : NSObject

@property (copy, nonatomic) NSString *tableName;
@property (retain, nonatomic) FMDatabaseQueue *dbQueue;
@property (retain, nonatomic) FMDatabase *db;

@property (retain, nonatomic) NSMutableDictionary *updateDictionary;
@property (retain, nonatomic) NSMutableArray *fields;
@property (retain, nonatomic) NSMutableArray *wheres;
@property (retain, nonatomic) NSNumber *offset;
@property (retain, nonatomic) NSNumber *limit;
@property (retain, nonatomic) NSMutableArray *orderBy;

+ (id)fetcherForTableName:(NSString *)tableName;

- (id)initWithTableName:(NSString *)tableName;

#pragma mark - build
- (id)offset:(NSInteger)offset;
- (id)limit:(NSInteger)limit;
- (id)orderBy:(NSString *)aField
                              ascending:(BOOL)isAscending;
- (id)orderBy:(NSString *)aField;
- (id)select:(NSString *)aFirstParam, ... NS_REQUIRES_NIL_TERMINATION;
- (id)selectInArray:(NSArray *)fields;
- (id)where:(NSString *)aCondition, ... NS_REQUIRES_NIL_TERMINATION;
- (id)where:(NSString *)aCondition argsInArray:(NSArray *)args;
- (id)update:(NSDictionary *)updateDic;
- (id)insert:(NSDictionary *)insertDic;

- (id)usingDb:(FMDatabase *)db;
- (id)usingDbQueue:(FMDatabaseQueue *)dbQueue;

#pragma mark - fetch
- (NSInteger)fetchInteger;
- (NSNumber *)fetchNumber;
- (NSString *)fetchString;
- (NSArray *)fetchDictionaryArray;
- (NSDictionary *)fetchDictionary;
- (NSInteger)fetchCounter;
- (void)fetchDbWithBlock:(void(^)(FMResultSet *rs))block;


- (BOOL)updateDb;
- (BOOL)updateDb:(BOOL(^)(FMDatabase *db))block;
- (BOOL)insertDb;
- (BOOL)insertDbWithReplace:(BOOL)replace;
- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block;
- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block
         replace:(BOOL)replace;
- (BOOL)deleteDb;
- (BOOL)deleteDb:(BOOL(^)(FMDatabase *db))block;

@end
