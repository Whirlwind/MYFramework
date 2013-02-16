//
//  MYSqlAccess.h
//  foodiet
//
//  Created by Whirlwind James on 11-12-26.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface MYSqlAccess : NSObject
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *dbFileName;
@property (copy, nonatomic) NSString *writableDBPath;
@property (retain, nonatomic) FMDatabaseQueue *dbQueue;

- (id)initWithUserDatabaseFile:(NSString *)dbFileName password:(NSString *)password;

- (NSInteger)currentVersionFor:(NSString *)plugin;

- (void)migratePlugin:(NSString *)plugin toVersion:(NSInteger)newVersion update:(void(^)(NSInteger oldVersion, MYSqlAccess *accessor))block;

- (void)close;

+ (FMDatabaseQueue *)openDB:(NSString *)_dbPath
                   password:(NSString *)password;
+ (void)restore:(NSArray *)datas
           toDb:(FMDatabaseQueue *)newDbQueue
        toTable:(NSString *)ttable
columnsMapTable:(NSDictionary *)mapTable
        confict:(NSString *)confict;
+ (void)restore:(FMDatabaseQueue *)oldDbQueue
      fromTable:(NSString *)ftable
           toDb:(FMDatabaseQueue *)newDbQueue
        toTable:(NSString *)ttable
          limit:(NSInteger)limit
        columns:(NSArray *)columns;
+ (void)closeDB:(FMDatabaseQueue *)db;
@end




@interface MYSqlAccess (FileHelper)

+ (NSString *)getTmpFile:(NSString *)_dbFileName;
+ (NSString *)getCacheFile:(NSString *)_dbFileName;
+ (NSString *)getDocumentFile:(NSString *)_dbFileName;
+ (NSString *)getResourceFile:(NSString *)_dbFileName;

+ (NSComparisonResult)compareDBDate:(NSString *)_newDBPath
                          oldDBPath:(NSString *)_oldDBPath;

+ (NSString *)copiedBundleDbIsExcludedFromBackupKey:(NSString *)_dbFileName
                                            replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToTmp:(NSString *)_dbFileName
                          replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToDocuments:(NSString *)_dbFileName
                                replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToCache:(NSString *)_dbFileName
                            replace:(BOOL)replace;
+ (NSString *)copiedBundleDb:(NSString *)_dbFileName
                          to:(NSString *)writableDBPath
                     replace:(BOOL)replace;
+ (BOOL)copiedDb:(NSString *)resourceDBPath
              to:(NSString *)writableDBPath
         replace:(BOOL)replace;
@end