//
//  MYEntrySqlAccess.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-19.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYEntryDataAccessProtocol.h"
#import "MYDbFetcher.h"
#import "MYEntrySqlAccessProtocol.h"

@interface MYEntrySqlAccess : MYDbFetcher <MYEntryDataAccessProtocol>

@property (assign, nonatomic) BOOL insertModeUsingReplace;

- (MYEntry *)fetchRecord;
- (NSArray *)fetchRecords;

#pragma mark - for override
- (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs;
- (MYDbFetcher *)filterUserKey:(NSString *)userKey;

@end
