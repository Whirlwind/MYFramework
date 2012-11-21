//
//  NSObject+ONEObject.h
//  ONE
//
//  Created by Whirlwind on 12-11-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#define POST_ROUTE [self postRouteMethod:NSStringFromSelector(_cmd)]
#define POST_ROUTE_WITH(_userInfo) [self postRouteMethod:NSStringFromSelector(_cmd) userInfo:_userInfo]
#define POST_ROUTE_WITH_NAME_AND_ARGS(_name, _userInfo) [self postRouteMethod:_name userInfo:_userInfo]
@interface NSObject (Route)

#pragma mark - route
- (void)postRouteMethod:(NSString *)name;
- (void)postRouteMethod:(NSString *)name userInfo:(NSDictionary *)userInfo;
@end
