//
//  ONEBaseDbEntry+DatabaseReader.h
//  ONEBase
//
//  Created by Whirlwind on 12-11-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"
#import "MYEntryDbFetcher.h"

@interface MYEntry (DatabaseReader)


- (MYEntryDbFetcher *)fetcher;
+ (MYEntryDbFetcher *)fetcher;

#pragma mark - Convenient
+ (NSInteger)count;
+ (id)entryAt:(NSNumber *)index;
+ (BOOL)existEntry;
@end
