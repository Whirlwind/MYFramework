//
//  MYBroadcastCenter.m
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYBroadcastCenter.h"

static MYBroadcastCenter *_sharedBroadcastCenter = nil;

static dispatch_once_t _sharedBroadcastCenterPred;

@implementation MYBroadcastCenter
+ (id)sharedInstant {
    dispatch_once(&_sharedBroadcastCenterPred, ^{ _sharedBroadcastCenter = [[[self class] alloc] init]; });
    return _sharedBroadcastCenter;
}

+ (void)release {
    [_sharedBroadcastCenter release], _sharedBroadcastCenter = nil;
}

+ (NSString *)extendString {
    return @".broadcast";
}

+ (Class)modelClass {
    return [MYBroadcast class];
}

- (void)dealloc {
    for (NSString *name in [self.list allKeys]) {
        [self unregisterNotification:name];
    }
    [super dealloc];
}
- (void)registerNotification:(MYBroadcast *)broadcast {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callback:)
                                                 name:broadcast.name
                                               object:nil];
}

- (void)unregisterNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)callback:(NSNotification *)ntf {
    NSArray *array = [self.list valueForKey:ntf.name];
    if (array != nil) {
        [ntf retain];
        for (MYBroadcast *broadcast in array) {
            [broadcast executeWithNotification:ntf];
        }
        [ntf release];
    }
}

- (void)add:(MYBroadcast *)broadcast {
    NSMutableArray *array = [self.list valueForKey:broadcast.name];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
        (self.list)[broadcast.name] = array;
        [self registerNotification:broadcast];
    }
    [array addObject:broadcast];
}
@end
