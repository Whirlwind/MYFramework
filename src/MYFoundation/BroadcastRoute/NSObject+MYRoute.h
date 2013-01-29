//
//  NSObject+MYRoute.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYRouteCenter.h"

#define POST_ROUTE [self postRouteMethod:NSStringFromSelector(_cmd)]
#define POST_ROUTE_WITH_ARGS(_userInfo) [self postRouteMethod:NSStringFromSelector(_cmd) userInfo:_userInfo]
#define POST_ROUTE_WITH_NAME(_name) [self postRouteMethod:_name]
#define POST_ROUTE_WITH_NAME_AND_ARGS(_name, _userInfo) [self postRouteMethod:_name userInfo:_userInfo]
@interface NSObject (MYRoute)

- (id)postRouteMethod:(NSString *)name;
- (id)postRouteMethod:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end
