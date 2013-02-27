//
//  MYEntry+SqlAccess.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-27.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"

@interface MYEntry (SqlAccess)

+ (NSString *)convertPropertyNameToDbFieldName:(NSString *)name;
+ (NSString *)convertDbFieldNameToPropertyName:(NSString *)name;
+ (NSString *)tableName;
+ (FMDatabaseQueue *)dbQueue;

@end
