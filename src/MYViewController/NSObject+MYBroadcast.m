//
//  NSObject+ONEObject.m
//  ONE
//
//  Created by Whirlwind on 12-11-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "NSObject+MYBroadcast.h"

@implementation NSObject (MYBroadcast)

#pragma mark - route
- (void)postBroadcastMethod:(NSString *)name {
    [self postBroadcastMethod:name userInfo:nil];
}

- (void)postBroadcastMethod:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/%@", [[self class] description], name, nil]
                                                        object:self
                                                      userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"*/%@", name, nil]
                                                        object:self
                                                      userInfo:userInfo];
    
}
@end
