//
//  MYEntryJsonAccess.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-19.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYEntryJsonAccess.h"
#import "NSDictionary+KeyExtends.h"
#import "NSJSONSerialization+JSONKit.h"
#import "MYEntryJsonAccessProtocol.h"
#import "MYEntry+JsonAccess.h"

#ifndef kMYEntryJsonAccessAPICreate
#   define kMYEntryJsonAccessAPICreate @"POST@/:resource"
#endif

#ifndef kMYEntryJsonAccessAPIUpdate
#   define kMYEntryJsonAccessAPIUpdate @"DELETE@/:resource/:id"
#endif

#ifndef kMYEntryJsonAccessAPIDelete
#   define kMYEntryJsonAccessAPIDelete @"DELETE@/:resource/:id"
#endif

@interface MYEntryJsonAccess ()
@property (copy, nonatomic) NSString *userKey;
@end

@implementation MYEntryJsonAccess

@synthesize entry = _entry;
@synthesize entryClass = _entryClass;

- (void)dealloc {
    [_entry release], _entry = nil;
    _entryClass = nil;
    [_userKey release], _userKey = nil;
    [super dealloc];
}

- (id)initWithEntry:(MYEntry *)entry {
    if (self = [self init]) {
        self.entry = entry;
    }
    return self;
}

- (id)initWithEntryClass:(Class)entryClass {
    if (self = [self init]) {
        self.entryClass = entryClass;
    }
    return self;
}

- (Class)entryClass {
    if (_entryClass == nil && self.entry != nil) {
        return [self.entry class];
    }
    return _entryClass;
}

- (NSString *)modelName {
    if (_modelName == nil) {
        NSString *name = nil;
        if (self.entry && [self.entry respondsToSelector:@selector(modelName)]) {
            name = [self.entry performSelector:@selector(modelName)];
        }
        if (name == nil) {
            name = [self.entryClass modelName];
        }
        self.modelName = name;
    }
    return _modelName;
}

- (NSString *)parseAPI:(NSString *)api method:(NSString **)method args:(NSMutableDictionary **)args{
    api = [super parseAPI:api method:method args:args];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/:([a-zA-Z\\d]+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    __block NSString *param = nil;
    __block NSString *newApi = api;
    [regex enumerateMatchesInString:api options:NSMatchingReportCompletion range:NSMakeRange(0, [api length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            param = [api substringWithRange:[result rangeAtIndex:1]];
            NSObject *value = (*args)[param];
            if (value) {
                [*args removeObjectForKey:param];
            } else if ([param isEqualToString:@"resource"]) {
                value = self.modelName;
            } else if (self.entry && [self.entry respondsToSelector:NSSelectorFromString(param)]) {

                param = [self.entryClass convertJsonKeyNameToPropertyName:param];
                value = [self.entry performSelector:NSSelectorFromString(param)];
            } else {
                NSAssert(NO, @"param %@ NOT Found!", param);
            }
            newApi = [newApi stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/:%@", param]
                                                       withString:[NSString stringWithFormat:@"/%@", [self convertParamToString:value]]];
        }
    }];
    return newApi;
}

- (NSString *)convertParamToString:(NSObject *)param {
    if ([param isKindOfClass:[NSString class]]) {
        return (NSString *)param;
    }
    if ([param isKindOfClass:[NSDate class]]) {
        return [(NSDate *)param stringWithFormat:kMYDateTimeFormat];
    }
    if ([param respondsToSelector:@selector(universalConvertToJSONString)]) {
        return [param performSelector:@selector(universalConvertToJSONString)];
    }
    return @"";
}

#pragma mark - DAO

- (NSDictionary *)changesDictionary {
    NSMutableDictionary *changeDic = [[NSMutableDictionary alloc] initWithCapacity:[self.entry.changes count]];
    [self.entry.changes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *field = [self.entryClass convertPropertyNameToJsonKeyName:key];
        changeDic[field] = obj[1];
    }];
    return [changeDic autorelease];
}

#pragma mark C
- (BOOL)createEntry {
    if (self.entry.index != nil) {
        return YES;
    }
    NSString *api = nil;
    if ([self.entry respondsToSelector:@selector(createAPI)]) {
        api = [self.entry performSelector:@selector(createAPI)];
    }
    if (api == nil) {
        api = kMYEntryJsonAccessAPICreate;
    }
    NSDictionary *ret = [self requestAPI:api postValue:[self changesDictionary]];
    return ret != nil;
}

#pragma mark U
- (BOOL)updateEntry {
    if (self.entry.index == nil) {
        return NO;
    }
    NSString *api = nil;
    if ([self.entry respondsToSelector:@selector(updateAPI)]) {
        api = [self.entry performSelector:@selector(updateAPI)];
    }
    if (api == nil) {
        api = kMYEntryJsonAccessAPIUpdate;
    }
    NSDictionary *ret = [self requestAPI:api postValue:[self changesDictionary]];
    return ret != nil;
}

#pragma mark D
- (BOOL)removeEntry {
    if (self.entry.index == nil) {
        return YES;
    }
    NSString *api = nil;
    if ([self.entry respondsToSelector:@selector(deleteAPI)]) {
        api = [self.entry performSelector:@selector(deleteAPI)];
    }
    if (api == nil) {
        api = kMYEntryJsonAccessAPIDelete;
    }
    NSDictionary *ret = [self requestAPI:api];
    return ret != nil;
}

@end
