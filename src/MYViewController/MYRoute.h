//
//  MYRoute.h
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

@interface MYRoute : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *path;
@property (assign, nonatomic) NSInteger thread;
@property (assign, nonatomic) BOOL sync;

+ (MYRoute *)parseRouteFileLine:(NSString *)line;
- (void)executeWithNotification:(NSNotification *)ntf;
@end
