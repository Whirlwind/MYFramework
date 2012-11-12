//
//  MYRoute.m
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYRoute.h"

@implementation MYRoute
- (void)dealloc {
    [_name release], _name = nil;
    [_path release], _path = nil;
    [super dealloc];
}

- (id)initWithName:(NSString *)name
              path:(NSString *)path
            thread:(NSInteger)thread
              sync:(BOOL)sync {
    if (self = [self init]) {
        self.name = name;
        self.path = path;
        self.thread = thread;
        self.sync = sync;
    }
    return self;
}
- (void)executeWithNotification:(NSNotification *)ntf {
    NSArray *array = [self.path componentsSeparatedByString:@"/"];
    if ([array count] != 2)
        return;
    NSObject *target = [[NSClassFromString([array objectAtIndex:0]) alloc] init];
    SEL selector = NSSelectorFromString([array objectAtIndex:1]);
    switch (self.thread) {
        case 1: // 主线程
            if (self.sync && [NSThread currentThread].isMainThread) {
                [target performSelector:selector withObject:ntf];
            } else {
                [target performSelectorOnMainThread:selector
                                     withObject:ntf
                                  waitUntilDone:self.sync];
            }
            break;
        case 2: // 后台线程
            if (self.sync && ![NSThread currentThread].isMainThread) {
                [target performSelector:selector withObject:ntf];
            } else {
                [target performSelectorInBackground:selector withObject:ntf];
            }
            break;
        default: // 当前线程
            [target performSelector:selector withObject:ntf];
            break;
    }
    [target release];
}
+ (MYRoute *)parseRouteFileLine:(NSString *)line {
    line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
    line = [line stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSArray *array = [line componentsSeparatedByString:@","];
    if ([array count] < 2)
        return nil;
    NSString *name = [array objectAtIndex:0];
    NSString *path = [array objectAtIndex:1];
    NSInteger thread = 0;
    if ([array count] >= 3) {
        NSNumber *threadNumber = [array objectAtIndex:2];
        if (threadNumber)
            thread = [threadNumber integerValue];
    }
    BOOL sync = NO;
    if ([array count] >= 4) {
        NSNumber *syncNumber = [array objectAtIndex:3];
        if (syncNumber)
            sync = [syncNumber boolValue];
    }
    MYRoute *route = [[MYRoute alloc] initWithName:name
                                              path:path
                                            thread:thread
                                              sync:sync];
    return [route autorelease];
}
@end
