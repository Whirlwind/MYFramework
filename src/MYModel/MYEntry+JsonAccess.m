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
    if (self = [self init]) {
        [self updatePropertyWithJsonDictionary:dic];
    }
    return self;
}

- (void)updatePropertyWithJsonDictionary:(NSDictionary *)dic {
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [self setPropertyWithJsonKey:key toValue:obj];
    }];
}

+ (NSString *)modelName {
    return [self convertAppleStylePropertyToRailsStyleProperty:NSStringFromClass([self class])];
}

+ (NSString *)modelNameWithPlural {
    return [NSString stringWithFormat:@"%@s", [self modelName]];
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

- (NSMutableDictionary *)changesDictionarySerializeForJsonAccess {
    NSMutableDictionary *changeDic = [[NSMutableDictionary alloc] initWithCapacity:[self.changes count]];
    [self.changes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *field = [[self class] convertPropertyNameToJsonKeyName:key];
        if ([obj[1] isKindOfClass:[MYEntry class]]) {
            changeDic[field] = [((MYEntry *)obj[1]) changesDictionarySerializeForJsonAccess];
        } else {
            changeDic[field] = obj[1];
        }
    }];
    if (self.index != nil) {
        changeDic[@"id"] = self.index;
    }
    return [changeDic autorelease];
}

@end
