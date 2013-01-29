//
//  ONEBaseDbEntry+DatabaseWriter.h
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//


#import "MYEntry.h"
#import "MYEntryDbFetcher.h"

@interface MYEntry (DatabaseWriter)

- (NSDictionary *)changesDictionary;

+ (BOOL)clear;

#pragma mark - DAO
- (BOOL)destory;
- (BOOL)save;

#pragma mark - for override
+ (NSString *)convertDbFieldNameToPropertyName:(NSString *)name;
+ (SEL)convertDbFieldNameToSetSelector:(NSString *)name;
@end
