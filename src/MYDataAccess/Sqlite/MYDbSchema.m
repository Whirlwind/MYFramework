//
//  MYDbSchema.m
//  ONEBase
//
//  Created by Whirlwind on 12-12-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYDbSchema.h"
#import "FMDatabase+MYAdditions.h"

@implementation MYDbSchema

DEF_MY_SINGLETON(MYDbSchema)

- (void)dealloc {
    [_columns release], _columns = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - getter

- (NSMutableDictionary *)columns {
    if (_columns == nil) {
        _columns = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _columns;
}

- (NSArray *)columnsForTable:(NSString *)tableName {
    return self.columns[tableName];
}

- (BOOL)hasColumn:(NSString *)column forTable:(NSString *)tableName {
    return [[self columnsForTable:tableName] indexOfObject:column] != NSNotFound;
}
#pragma mark - private
- (void)loadSchemaInTable:(NSString *)tableName dbQueue:(FMDatabaseQueue *)dbQueue {
    if ([self.columns existKey:tableName]) {
        return;
    }
    NSArray *columns = [dbQueue getTableColumns:tableName];
    if (columns == nil) {
        return;
    }
    [self.columns setValue:columns forKey:tableName];
}

@end
