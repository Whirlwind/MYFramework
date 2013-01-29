//
//  ONEBaseDbEntry+DatabaseReader.m
//  ONEBase
//
//  Created by Whirlwind on 12-11-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry+DatabaseReader.h"

@implementation MYEntry (DatabaseReader)

#pragma mark - fetcher
+ (MYEntryDbFetcher *)fetcher {
    return [MYEntryDbFetcher fetcherForEntryClass:[self class]];
}
- (MYEntryDbFetcher *)fetcher {
    MYEntryDbFetcher *fetcher = [MYEntryDbFetcher fetcherForEntryClass:[self class]];
    [fetcher setDb:self.db];
    return fetcher;
}


#pragma mark - Convenient
+ (NSInteger)count {
    return [[self fetcher] fetchCounter];
}
+ (id)entryAt:(NSNumber *)index {
    return [[[self fetcher] where:@"id = ?", index, nil] fetchRecord];
}
+ (BOOL)existEntry {
    return [[self fetcher] fetchCounter] > 0;
}
@end
