//
//  MYBroadcast.h
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

@interface MYBroadcast : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *path;
@property (assign, nonatomic) NSInteger thread;

+ (MYBroadcast *)parseBroadcastFileLine:(NSString *)line;
- (void)executeWithNotification:(NSNotification *)ntf;
@end
