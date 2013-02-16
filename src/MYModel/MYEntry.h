//
//  MYEntry.h
//  MYFramework
//
//  Created by Whirlwind on 13-1-16.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NSObject+MYProperty.h"

@interface MYEntry : NSObject{
    BOOL listening;
}

@property (retain, nonatomic) NSNumber *index;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *updatedAt;
@property (assign, nonatomic) NSDate *createDate;
@property (assign, nonatomic) NSDate *updateDate;

@property (retain, nonatomic) NSError *error;

@property (assign, nonatomic) BOOL needPostLocalChangeNotification;
@property (retain, nonatomic) NSMutableDictionary *changes;

@property (retain, nonatomic) NSString *tableName;
@property (assign, nonatomic) BOOL needLog;
@property (retain, nonatomic) NSMutableArray *ignoreLogProperties;
@property (retain, nonatomic) NSMutableArray *extendLogProperties;

@property (retain, nonatomic) FMDatabaseQueue *dbQueue;
@property (retain, nonatomic) FMDatabase *db;
@property (assign, nonatomic) BOOL insertModeUsingReplace;


#pragma mark - listen
- (void)disableListenProperty:(void(^)(void))block;
- (void)reverseWithProperty:(NSString *)property;
- (void)reverse;
- (void)postLocalChangeNotification;
+ (void)postLocalChangeNotification;

#pragma mark - for override
+ (NSString *)tableName;
+ (NSString *)modelName;
+ (FMDatabaseQueue *)dbQueue;
+ (BOOL)needLog;
+ (BOOL)isUserDb;

#pragma mark - log
- (BOOL)logChanges:(NSDictionary *)changes usingDb:(FMDatabase *)db;
- (BOOL)logDeleteUsingDb:(FMDatabase *)db;

#pragma mark - DAO
- (BOOL)save;
- (BOOL)destroy;

#pragma mark for override
- (BOOL)createEntry;
- (BOOL)updateEntry;
- (BOOL)removeEntry;

@end

#import "MYEntry+DatabaseReader.h"
#import "MYEntry+DatabaseWriter.h"