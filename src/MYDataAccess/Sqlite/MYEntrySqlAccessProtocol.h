//
//  MYEntrySqlAccessProtocol.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-25.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYEntrySqlAccessProtocol <NSObject>

@optional

@property (retain, nonatomic) NSString *tableName;
@property (retain, nonatomic) FMDatabaseQueue *dbQueue;

+ (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs;
@end
