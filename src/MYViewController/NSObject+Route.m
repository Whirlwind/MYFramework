//
//  NSObject+ONEObject.m
//  ONE
//
//  Created by Whirlwind on 12-11-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "NSObject+Route.h"

@implementation NSObject (Route)

#pragma mark - route
- (void)postRouteMethod:(SEL)selector {
    [self postRouteMethod:selector userInfo:nil];
}

- (void)postRouteMethod:(SEL)selector userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/%@",
                                                                [[self class] description],
                                                                NSStringFromSelector(selector), nil]
                                                        object:self
                                                      userInfo:userInfo];
    
}
@end
