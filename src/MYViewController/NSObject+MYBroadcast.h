//
//  NSObject+ONEObject.h
//  ONE
//
//  Created by Whirlwind on 12-11-5.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#define POST_BROADCAST [self postBroadcastMethod:NSStringFromSelector(_cmd)]
#define POST_BROADCAST_WITH(_userInfo) [self postBroadcastMethod:NSStringFromSelector(_cmd) userInfo:_userInfo]
#define POST_BROADCAST_WITH_NAME_AND_ARGS(_name, _userInfo) [self postBroadcastMethod:_name userInfo:_userInfo]
@interface NSObject (MYBroadcast)

#pragma mark - route
- (void)postBroadcastMethod:(NSString *)name;
- (void)postBroadcastMethod:(NSString *)name userInfo:(NSDictionary *)userInfo;
@end
