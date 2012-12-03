//
//  MYBroadcast.h
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYRoute.h"
@interface MYBroadcast : MYRoute
@property (assign, nonatomic) NSInteger thread;

- (id)initWithName:(NSString *)name
              path:(NSString *)path
            thread:(NSInteger)thread;
@end
