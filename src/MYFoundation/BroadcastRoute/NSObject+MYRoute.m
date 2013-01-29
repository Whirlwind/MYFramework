//
//  NSObject+MYRoute.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "NSObject+MYRoute.h"

@implementation NSObject (MYRoute)

- (id)postRouteMethod:(NSString *)name {
    return [self postRouteMethod:name userInfo:nil];
}
- (id)postRouteMethod:(NSString *)name userInfo:(NSDictionary *)userInfo {
    return [[MYRouteCenter sharedInstant] callRoute:[NSString stringWithFormat:@"%@/%@", [[self class] description], name, nil] object:self userInfo:userInfo];
}
@end
