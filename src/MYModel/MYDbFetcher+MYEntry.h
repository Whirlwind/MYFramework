//
//  MYDbFetcher+MYEntry.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDbFetcher.h"

@interface MYDbFetcher (MYEntry)

+ (MYDbFetcher *)fetcherForEntryClass:(Class)entryClass;
- (id)initWithEntryClass:(Class)entryClass;

- (MYEntry *)fetchRecord;

#pragma mark - for override
- (MYEntry *)fetchRecordFromResultSet:(FMResultSet *)rs;
@end
