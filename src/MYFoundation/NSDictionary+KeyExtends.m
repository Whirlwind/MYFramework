//
//  NSDictionary+KeyExtends.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "NSDictionary+KeyExtends.h"

@implementation NSDictionary (KeyExtends)

- (BOOL)existKey:(NSString *)key {
    if ([self objectForKey:key]) {
        return YES;
    }
    return NO;
}

@end
