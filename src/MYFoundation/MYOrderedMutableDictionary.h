//
//  MYOrderedMutableDictionary.h
//  foodiet
//
//  Created by 詹 迟晶 on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYOrderedMutableDictionary : NSMutableDictionary
@property (nonatomic, strong) NSMutableArray *keyOrder;
@property (nonatomic, strong) NSMutableDictionary *dic;

- (id)initWithCapacity:(NSUInteger)numItems;
- (int)indexOfString:(NSString *)key;
- (void)removeObjectForString:(NSString *)key;
- (void)removeAllObjects;
- (id)objectForString:(NSString *)key;
- (id)objectForKey:(id)key;
- (id)objectAtIndex:(NSUInteger)index;
- (id)lastObject;
- (id)firstObject;
- (NSUInteger)count;
@end
