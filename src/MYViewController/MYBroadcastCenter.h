//
//  MYBroadcastCenter.h
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//


@interface MYBroadcastCenter : NSObject
@property (retain, nonatomic) NSMutableDictionary *broadcastList;
+ (id)sharedInstant;
+ (void)addBroadcastFileInBundle;

- (void)addBroadcastFile:(NSString *)path;
@end
