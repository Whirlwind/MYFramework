//
//  MYEntryWithSync.h
//  ONEBase
//
//  Created by Whirlwind on 12-12-1.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "MYEntrySqlAccessWithLog.h"
#import "MYEntry+SqlAccess.h"

#import "MYEntry+JsonAccess.h"

@interface MYEntryWithSync : MYEntry <MYEntrySqlAccessProtocol>

@property (assign, nonatomic) BOOL needLog;

@property (retain, nonatomic) MYDateTime *remoteUpdatedAt;
@property (retain, nonatomic) MYDateTime *remoteCreatedAt;

@property (retain, nonatomic) NSMutableArray *ignoreLogProperties;
@property (retain, nonatomic) NSMutableArray *extendLogProperties;

+ (BOOL)needLog;

+ (NSString *)selectFirstRemoteCreateDateInLocal;
+ (NSString *)selectLatestRemoteUpdateDateInLocal;

+ (BOOL)destoryInLocalWithRemoteIdArray:(NSArray *)ids;

+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic;
+ (BOOL)saveInLocalWithJSONArray:(NSArray *)array;

+ (BOOL)existAnonymousData;
+ (BOOL)setAnonymousDataToCurrentUserData;

@end
