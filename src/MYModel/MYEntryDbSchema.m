//
//  ONEBaseUserDbSchema.m
//  ONEBase
//
//  Created by Whirlwind on 12-12-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntryDbSchema.h"

@implementation MYEntryDbSchema

DEF_MY_SINGLETON(MYEntryDbSchema)

- (void)dealloc {
    [_columns release], _columns = nil;
    [_models release], _models = nil;
    [_propertyMapTable release], _propertyMapTable = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:0];
        POST_BROADCAST_WITH_NAME_AND_ARGS(@"tryAddUserDbModel:", @{@"models" : models});
        [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self loadSchema:NSClassFromString(obj)];
        }];
        [models release];
    }
    return self;
}

#pragma mark - getter

- (NSMutableDictionary *)models {
    if (_models == nil) {
        _models = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _models;
}

- (NSMutableDictionary *)propertyMapTable {
    if (_propertyMapTable == nil) {
        _propertyMapTable = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _propertyMapTable;
}
#pragma mark - public
- (NSArray *)propertiesForModel:(Class)model {
    NSArray *properties = [self.models objectForKey:[model description]];
    if (properties) {
        return properties;
    }
    [self loadSchema:model];
    return [self.models objectForKey:[model description]];
}

- (NSString *)dbFieldNameForProperty:(NSString *)property forModel:(Class)model {
    return [[self.propertyMapTable valueForKey:[model description]] valueForKey:property];
}
#pragma mark - private
- (void)loadSchema:(Class)model {
    NSArray *columns = [self.dbQueue getTableColumns:[model tableName]];
    if (columns == nil) {
        return;
    }
    [self.columns setValue:columns forKey:[model tableName]];
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:[columns count]];
    NSMutableDictionary *mapTable = [[NSMutableDictionary alloc] initWithCapacity:[columns count]];
    for (NSString *column in columns) {
        NSString *property = [model convertDbFieldNameToPropertyName:column];
        [properties addObject:property];
        [mapTable setValue:column forKey:property];
    }
    [self.models setValue:properties forKey:[model description]];
    [self.propertyMapTable setValue:mapTable forKey:[model description]];
    [properties release];
    [mapTable release];
}

@end
