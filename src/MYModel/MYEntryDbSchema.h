//
//  ONEBaseUserDbSchema.h
//  ONEBase
//
//  Created by Whirlwind on 12-12-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEntry.h"

@interface MYEntryDbSchema : MYEntry

@property (retain, nonatomic) NSMutableDictionary *models;
@property (retain, nonatomic) NSMutableDictionary *propertyMapTable;
@property (retain, nonatomic) NSMutableDictionary *columns;

AS_MY_SINGLETON(MYEntryDbSchema)

- (NSArray *)propertiesForModel:(Class)model;
- (NSString *)dbFieldNameForProperty:(NSString *)property forModel:(Class)model;

@end
