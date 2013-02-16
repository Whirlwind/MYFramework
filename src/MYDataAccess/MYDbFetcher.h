//
//  MYDbFetcher.h
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-25.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase+MYAdditions.h"


@interface MYDbFetcher : NSObject

@property (assign, nonatomic) Class entryClass;
@property (copy, nonatomic) NSString *tableName;
@property (retain, nonatomic) FMDatabaseQueue *dbQueue;
@property (retain, nonatomic) FMDatabase *db;

@property (retain, nonatomic) NSMutableDictionary *updateDictionary;
@property (retain, nonatomic) NSMutableArray *fields;
@property (retain, nonatomic) NSMutableArray *wheres;
@property (retain, nonatomic) NSNumber *offset;
@property (retain, nonatomic) NSNumber *limit;
@property (retain, nonatomic) NSMutableArray *orderBy;

+ (MYDbFetcher *)fetcherForTableName:(NSString *)tableName;

- (id)initWithTableName:(NSString *)tableName;

#pragma mark - build
- (MYDbFetcher *)offset:(NSInteger)offset;
- (MYDbFetcher *)limit:(NSInteger)limit;
- (MYDbFetcher *)orderBy:(NSString *)aField
                              ascending:(BOOL)isAscending;
- (MYDbFetcher *)orderBy:(NSString *)aField;
- (MYDbFetcher *)select:(NSString *)aFirstParam, ... NS_REQUIRES_NIL_TERMINATION;
- (MYDbFetcher *)selectInArray:(NSArray *)fields;
- (MYDbFetcher *)where:(NSString *)aCondition, ... NS_REQUIRES_NIL_TERMINATION;
- (MYDbFetcher *)where:(NSString *)aCondition argsInArray:(NSArray *)args;
- (MYDbFetcher *)update:(NSDictionary *)updateDic;
- (MYDbFetcher *)insert:(NSDictionary *)insertDic;

- (MYDbFetcher *)usingDb:(FMDatabase *)db;
- (MYDbFetcher *)usingDbQueue:(FMDatabaseQueue *)dbQueue;

#pragma mark - fetch
- (NSInteger)fetchInteger;
- (NSNumber *)fetchNumber;
- (NSString *)fetchString;
- (NSArray *)fetchRecords;
- (NSArray *)fetchDictionaryArray;
- (NSDictionary *)fetchDictionary;
- (NSInteger)fetchCounter;
- (void)fetchDbWithBlock:(void(^)(FMResultSet *rs))block;

- (MYDbFetcher *)filterUserKey:(NSString *)userKey;

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
