//
//  MYRouteCenter.h
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//


@interface MYRouteCenter : NSObject
@property (retain, nonatomic) NSMutableDictionary *routeList;
+ (id)sharedRouteCenter;

- (void)addRouteFile:(NSString *)fileName;
@end
