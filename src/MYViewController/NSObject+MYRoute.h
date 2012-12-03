//
//  NSObject+MYRoute.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POST_ROUTE [self postRouteMethod:NSStringFromSelector(_cmd)]
#define POST_ROUTE_WITH(_userInfo) [self postRouteMethod:NSStringFromSelector(_cmd) userInfo:_userInfo]
#define POST_ROUTE_WITH_NAME_AND_ARGS(_name, _userInfo) [self postRouteMethod:_name userInfo:_userInfo]
@interface NSObject (MYRoute)

- (id)postRouteMethod:(NSString *)name;
- (id)postRouteMethod:(NSString *)name userInfo:(id)userInfo;

@end
