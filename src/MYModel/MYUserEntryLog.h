//
//  ONEBaseUserDataBaseLog.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYUserEntry.h"

@interface MYUserEntryLog : MYUserEntry

AS_MY_SINGLETON(MYUserEntryLog)

//- (BOOL)logChangeForModel:(NSString *)modelName
//                  localId:(NSNumber *)localId
//                 uniqueId:(NSNumber *)uniqueId
//                  changes:(NSDictionary *)changes
//                updatedAt:(NSString *)updatedAt
//                  usingDb:(FMDatabase *)db;
//- (BOOL)logDeleteForModel:(NSString *)modelName
//                  localId:(NSNumber *)localId
//                 uniqueId:(NSNumber *)uniqueId
//                updatedAt:(NSString *)updatedAt
//                  usingDb:(FMDatabase *)db;

@end
