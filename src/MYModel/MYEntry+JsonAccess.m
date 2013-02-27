//
//  MYEntry+JsonAccess.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntry+JsonAccess.h"

@implementation MYEntry (JsonAccess)

- (id)initWithJsonDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [self setPropertyWithJsonKey:key toValue:obj];
        }];
    }
    return self;
}

+ (NSString *)modelName {
    return [self convertAppleStylePropertyToRailsStyleProperty:NSStringFromClass([self class])];
}

- (void)setPropertyWithJsonKey:(NSString *)key toValue:(NSObject *)obj {
    NSString *property = [[self class] convertJsonKeyNameToPropertyName:key];
    SEL setSelector = [[self class] setterFromPropertyString:property];
    if ([self respondsToSelector:setSelector]) {
        [self performSelector:setSelector withObject:obj];
    }
}

+ (NSString *)convertJsonKeyNameToPropertyName:(NSString *)name {
    if ([name isEqualToString:@"id"]) {
        return @"remoteId";
    }
    return [self convertRailsStylePropertyToAppleStyleProperty:name];
}

+ (NSString *)convertPropertyNameToJsonKeyName:(NSString *)name {
    if ([name isEqualToString:@"remoteId"]) {
        return @"id";
    }
    return [self convertAppleStylePropertyToRailsStyleProperty:name];
}

+ (NSArray *)parseModelArrayFromHashArray:(NSArray *)list {
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[list count]];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ret addObject:[[[[self class] alloc] initWithJsonDictionary:obj] autorelease]];
    }];
    return [ret autorelease];
}

@end
