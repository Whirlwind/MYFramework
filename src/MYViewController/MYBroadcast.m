//
//  MYBroadcast.m
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYBroadcast.h"
#import "MYFramework.h"

@implementation MYBroadcast

- (id)initWithName:(NSString *)name
              path:(NSString *)path
            thread:(NSInteger)thread {
    if (self = [self initWithName:name path:path]) {
        self.thread = thread;
    }
    return self;
}
- (id)executeWithNotification:(NSNotification *)ntf {
    NSArray *array = [self.path componentsSeparatedByString:@"/"];
    if ([array count] != 2)
        return nil;
    NSObject *target = [[NSClassFromString(array[0]) alloc] init];
    SEL selector = NSSelectorFromString(array[1]);
    if (![target respondsToSelector:selector]) {
        [target release];
        return nil;
    }
    switch (self.thread) {
        case 1: // 主线程
            if ([NSThread currentThread].isMainThread) {
                [target performSelector:selector withObject:ntf];
            } else {
                [target performSelectorOnMainThread:selector
                                         withObject:ntf
                                      waitUntilDone:NO];
            }
            break;
        case 2: // 后台线程
            if (![NSThread currentThread].isMainThread) {
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
    return nil;
}

+ (id)parseFileLine:(NSString *)line {
    line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
    line = [line stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSArray *array = [line componentsSeparatedByString:@","];
    if ([array count] < 2)
        return nil;
    NSString *name = array[0];
    NSString *path = array[1];
    NSInteger thread = 0;
    if ([array count] >= 3) {
        NSNumber *threadNumber = array[2];
        if (threadNumber)
            thread = [threadNumber integerValue];
    }
    MYBroadcast *route = [[MYBroadcast alloc] initWithName:name
                                                      path:path
                                                    thread:thread];
    return [route autorelease];
}
@end
