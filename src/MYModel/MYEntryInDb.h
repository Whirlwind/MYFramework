//
//  ONEBaseUserDbEntry.h
//  ONEBase
//
//  Created by Whirlwind on 12-12-1.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "MYEntrySqlAccess.h"
#import "MYEntry+SqlAccess.h"

#import "MYEntry+JsonAccess.h"

@interface MYEntryInDb : MYEntry

@property (copy, nonatomic) NSString *remoteUpdatedAt;
@property (copy, nonatomic) NSString *remoteCreatedAt;

@property (retain, nonatomic) NSMutableArray *ignoreLogProperties;
@property (retain, nonatomic) NSMutableArray *extendLogProperties;

+ (NSString *)selectFirstRemoteCreateDateInLocal;
+ (NSString *)selectLatestRemoteUpdateDateInLocal;

+ (BOOL)destoryInLocalWithRemoteIdArray:(NSArray *)ids;

+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic;
+ (BOOL)saveInLocalWithJSONArray:(NSArray *)array;

+ (BOOL)existAnonymousData;
+ (BOOL)setAnonymousDataToCurrentUserData;

//#pragma mark - log
//- (BOOL)logChanges:(NSDictionary *)changes usingDb:(FMDatabase *)db;
//- (BOOL)logDeleteUsingDb:(FMDatabase *)db;

@end
