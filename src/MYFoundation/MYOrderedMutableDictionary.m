//
//  MYOrderedMutableDictionary.m
//  foodiet
//
//  Created by 詹 迟晶 on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MYOrderedMutableDictionary.h"

@implementation MYOrderedMutableDictionary

@synthesize keyOrder = _keyOrder;
@synthesize dic = _dic;

#pragma mark - init and dealloc
- (id)initWithCapacity:(NSUInteger)numItems{
    if ((self = [self init])){
    }
    return self;
}

- (void)dealloc{
    [_keyOrder release], _keyOrder = nil;
    [_dic release], _dic = nil;
    [super dealloc];
}

#pragma mark - getter
- (NSMutableArray *)keyOrder{
    if (_keyOrder == nil) {
        _keyOrder = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _keyOrder;
}
- (NSMutableDictionary *)dic{
    if (_dic == nil) {
        _dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dic;
}
#pragma mark - override
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([self indexOfString:key] == -1) {
        [self.keyOrder addObject:key];
    }
    [self.dic setValue:value forKey:key];
}

- (void)setobject:(id)object forKey:(id)key{
    if ([self.keyOrder indexOfObject:key] == -1) {
        [self.keyOrder addObject:key];
    }
    [self.dic setObject:object forKey:key];
    
}
- (NSArray *)allKeys{
    return self.keyOrder;
}

- (void)removeObjectForKey:(id)key{
    [self.keyOrder removeObject:key];
    [self.dic removeObjectForKey:key];
}

- (void)removeAllObjects{
    [self.keyOrder removeAllObjects];
    [self.dic removeAllObjects];
}
- (id)objectForKey:(id)key{
    return [self.dic objectForKey:key];
}
#pragma mark - custom

- (NSUInteger)count{
    return [self.keyOrder count];
}

- (id)objectAtIndex:(NSUInteger)index{
    if (index >= [self.keyOrder count]) {
        return nil;
    }
    id key = [self.keyOrder objectAtIndex:index];
    return [self objectForKey:key];
}

- (id)objectForString:(NSString *)key{
    int index = [self indexOfString:key];
    if (index == -1) {
        return nil;
    }
    id oriKey = [self.keyOrder objectAtIndex:index];
    return [self objectForKey:oriKey];
}

- (void)removeObjectForString:(NSString *)key{
    int index = [self indexOfString:key];
    if (index == -1) {
        return;
    }
    id oriKey = [self.keyOrder objectAtIndex:index];
    [self removeObjectForKey:oriKey];
    
}

- (int)indexOfString:(NSString *)key{
    int index = 0;
    for (id dicKey in self.keyOrder) {
        if ([dicKey isKindOfClass:[NSString class]]) {
            if ([key isEqualToString:(NSString *)dicKey]) {
                return index;
            }
        }
        index ++;
    }
    return -1;
}

- (id)firstObject{
    if ([self.keyOrder count] == 0) {
        return nil;
    }
    return [self objectAtIndex:0];
}
- (id)lastObject{
    id last = [self.keyOrder lastObject];
    return [self.dic objectForKey:last];
}
@end
