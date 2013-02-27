//
//  MYDbManager.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-23.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface MYDbManager : NSObject
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *dbFileName;
@property (copy, nonatomic) NSString *writableDBPath;
@property (retain, nonatomic) FMDatabaseQueue *dbQueue;



+ (FMDatabaseQueue *)openDB:(NSString *)_dbPath
                   password:(NSString *)password;
- (id)initWithUserDatabaseFile:(NSString *)dbFileName password:(NSString *)password;

#pragma mark - migrate

- (NSInteger)currentVersionForPlugin:(NSString *)plugin;

- (void)migrateUserDatabase:(NSNotification *)ntf;

- (void)migratePlugin:(NSString *)plugin
            toVersion:(NSInteger)newVersion
               update:(void(^)(NSInteger oldVersion, MYDbManager *accessor))block;

+ (void)restore:(NSArray *)datas
           toDb:(FMDatabaseQueue *)newDbQueue
        toTable:(NSString *)ttable
columnsMapTable:(NSDictionary *)mapTable
       conflict:(NSString *)conflict;

+ (void)restore:(FMDatabaseQueue *)oldDbQueue
      fromTable:(NSString *)ftable
           toDb:(FMDatabaseQueue *)newDbQueue
        toTable:(NSString *)ttable
          limit:(NSInteger)limit
        columns:(NSArray *)columns;

#pragma mark - SINGLETON

+ (void)closeSharedDbQueue;

+ (FMDatabaseQueue *)sharedDbQueue;

@end
