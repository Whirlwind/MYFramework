//
//  MYDbSchema.h
//  ONEBase
//
//  Created by Whirlwind on 12-12-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "FMDatabaseQueue.h"

@interface MYDbSchema : NSObject

@property (retain, nonatomic) NSMutableDictionary *columns;

AS_MY_SINGLETON(MYDbSchema)

- (NSArray *)columnsForTable:(NSString *)tableName;
- (BOOL)hasColumn:(NSString *)column forTable:(NSString *)tableName;
- (void)loadSchemaInTable:(NSString *)tableName dbQueue:(FMDatabaseQueue *)dbQueue;
@end
