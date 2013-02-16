//
//  ONEBaseDbEntry+DatabaseReader.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "MYDbFetcher+MYEntry.h"

@interface MYEntry (DatabaseReader)


- (MYDbFetcher *)fetcher;
+ (MYDbFetcher *)fetcher;

#pragma mark - Convenient
+ (NSInteger)count;
+ (id)entryAt:(NSNumber *)index;
+ (BOOL)existEntry;
@end
