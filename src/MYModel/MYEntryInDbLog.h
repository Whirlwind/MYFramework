//
//  ONEBaseUserDataBaseLog.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntryWithSync.h"
#import "MYEntry+SqlAccess.h"

@interface MYEntryInDbLog : NSObject

+ (void)setTableName:(NSString *)tableName;
+ (void)setDbQueue:(FMDatabaseQueue *)dbQueue;

+ (BOOL)logChangeForModel:(NSString *)modelName
                  localId:(NSNumber *)localId
                 uniqueId:(NSNumber *)uniqueId
                  userKey:(NSString *)userKey
                  changes:(NSDictionary *)changes
                updatedAt:(MYDateTime *)updatedAt
                  usingDb:(FMDatabase *)db;
+ (BOOL)logDeleteForModel:(NSString *)modelName
                  localId:(NSNumber *)localId
                 uniqueId:(NSNumber *)uniqueId
                  userKey:(NSString *)userKey
                updatedAt:(MYDateTime *)updatedAt
                  usingDb:(FMDatabase *)db;

@end
