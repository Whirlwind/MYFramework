//
//  MYUserDataBase.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-23.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSqlAccess.h"

@interface MYUserDataBase : NSObject
+ (void)close;
+ (FMDatabaseQueue *)dbQueue;

- (void)migrateUserDatabase:(NSNotification *)ntf;
@end
