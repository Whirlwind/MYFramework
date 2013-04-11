//
//  MYEntryDataAccessProtocol.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-19.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYEntry;
@protocol MYEntryDataAccessProtocol <NSObject>

@required
@property (assign, nonatomic) Class entryClass;
@property (assign, nonatomic) MYEntry *entry;

@optional
@property (readonly, nonatomic) NSArray *dataProperties;
@property (readonly, nonatomic) NSArray *dataFields;

@required
- (id)initWithEntry:(MYEntry *)entry;
- (id)initWithEntryClass:(Class)entryClass;

#pragma mark - DAO
@required
- (BOOL)createEntry;
- (BOOL)updateEntry;
- (BOOL)removeEntry;
@optional
+ (BOOL)clearEntries;
- (MYEntry *)firstEntry;
- (NSInteger)countEntries;
- (MYEntry *)entryAt:(NSNumber *)index;
- (BOOL)existEntry;
@end
