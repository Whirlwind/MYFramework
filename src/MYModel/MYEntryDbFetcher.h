//
//  ONEBaseDbEntryFetcher.h
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-25.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase+MYAdditions.h"


@interface MYEntryDbFetcher : NSObject

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

+ (MYEntryDbFetcher *)fetcherForTableName:(NSString *)tableName;
+ (MYEntryDbFetcher *)fetcherForEntryClass:(Class)entryClass;

- (id)initWithTableName:(NSString *)tableName;
- (id)initWithEntryClass:(Class)entryClass;

#pragma mark - build
- (MYEntryDbFetcher *)offset:(NSInteger)offset;
- (MYEntryDbFetcher *)limit:(NSInteger)limit;
- (MYEntryDbFetcher *)orderBy:(NSString *)aField
                              ascending:(BOOL)isAscending;
- (MYEntryDbFetcher *)orderBy:(NSString *)aField;
- (MYEntryDbFetcher *)select:(NSString *)aFirstParam, ... NS_REQUIRES_NIL_TERMINATION;
- (MYEntryDbFetcher *)selectInArray:(NSArray *)fields;
- (MYEntryDbFetcher *)where:(NSString *)aCondition, ... NS_REQUIRES_NIL_TERMINATION;
- (MYEntryDbFetcher *)where:(NSString *)aCondition argsInArray:(NSArray *)args;
- (MYEntryDbFetcher *)update:(NSDictionary *)updateDic;
- (MYEntryDbFetcher *)insert:(NSDictionary *)insertDic;

- (MYEntryDbFetcher *)usingDb:(FMDatabase *)db;
- (MYEntryDbFetcher *)usingDbQueue:(FMDatabaseQueue *)dbQueue;

#pragma mark - fetch
- (NSInteger)fetchInteger;
- (NSNumber *)fetchNumber;
- (NSString *)fetchString;
- (MYEntry *)fetchRecord;
- (NSArray *)fetchRecords;
- (NSArray *)fetchDictionaryArray;
- (NSDictionary *)fetchDictionary;
- (NSInteger)fetchCounter;
- (void)fetchDbWithBlock:(void(^)(FMResultSet *rs))block;

- (MYEntryDbFetcher *)filterUserKey:(NSString *)userKey;

- (BOOL)updateDb;
- (BOOL)updateDb:(BOOL(^)(FMDatabase *db))block;
- (BOOL)insertDb;
- (BOOL)insertDbWithReplace:(BOOL)replace;
- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block;
- (BOOL)insertDb:(BOOL(^)(FMDatabase *db, NSInteger insertId))block
         replace:(BOOL)replace;
- (BOOL)deleteDb;
- (BOOL)deleteDb:(BOOL(^)(FMDatabase *db))block;

#pragma mark - for override
- (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs;
@end
