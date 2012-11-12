//
//  NSObject+ONEObject.h
//  ONE
//
//  Created by Whirlwind on 12-11-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#define POST_ROUTE [self postRouteMethod:_cmd]
#define POST_ROUTE_WITH(_userInfo) [self postRouteMethod:_cmd userInfo:_userInfo]
@interface NSObject (Route)

#pragma mark - route
- (void)postRouteMethod:(SEL)selector;
- (void)postRouteMethod:(SEL)selector userInfo:(NSDictionary *)userInfo;
@end
