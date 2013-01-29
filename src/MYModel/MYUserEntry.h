//
//  ONEBaseUserDbEntry.h
//  ONEBase
//
//  Created by Whirlwind on 12-12-1.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"

@interface MYUserEntry : MYEntry

@property (retain, nonatomic) NSNumber *remoteId;
@property (copy, nonatomic) NSString *remoteUpdatedAt;
@property (copy, nonatomic) NSString *remoteCreatedAt;

@property (retain, nonatomic) NSString *userKey;

+ (NSString *)selectFirstRemoteCreateDateInLocal;
+ (NSString *)selectLatestRemoteUpdateDateInLocal;

+ (BOOL)destoryInLocalWithRemoteIdArray:(NSArray *)ids;

+ (BOOL)saveInLocalWithJSONDictionary:(NSDictionary *)dic;
+ (BOOL)saveInLocalWithJSONArray:(NSArray *)array;

+ (BOOL)existAnonymousData;
+ (BOOL)setAnonymousDataToCurrentUserData;
@end
