//
//  MYEntry+SqlAccess.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-27.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntry+SqlAccess.h"
#import "MYDbManager.h"

@implementation MYEntry (SqlAccess)

+ (NSString *)convertPropertyNameToDbFieldName:(NSString *)name {
    if ([name isEqualToString:@"index"]) {
        return @"id";
    }
    return [self convertAppleStylePropertyToRailsStyleProperty:name];
}

+ (NSString *)convertDbFieldNameToPropertyName:(NSString *)name {
    if ([name isEqualToString:@"id"]) {
        return @"index";
    }
    return [self convertRailsStylePropertyToAppleStyleProperty:name];
}

+ (NSString *)tableName {
    return [self convertAppleStylePropertyToRailsStyleProperty:NSStringFromClass([self class])];
}

+ (FMDatabaseQueue *)dbQueue {
    return [MYDbManager sharedDbQueue];
}

@end
