//
//  MYBroadcastCenter.m
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYBroadcastCenter.h"
#import "MYBroadcast.h"

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

+ (void)addBroadcastFileInBundle {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [[self sharedInstant] addBroadcastFileInDir:bundlePath];
}

- (void)dealloc {
    for (NSString *name in [self.BroadcastList allKeys]) {
        [self unregisterNotification:name];
    }
    [_broadcastList release], _broadcastList = nil;
    [super dealloc];
}
- (void)registerNotification:(MYBroadcast *)broadcast {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callBroadcast:)
                                                 name:broadcast.name
                                               object:nil];
}

- (void)unregisterNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)callBroadcast:(NSNotification *)ntf {
    NSArray *array = [self.BroadcastList valueForKey:ntf.name];
    if (array != nil) {
        for (MYBroadcast *broadcast in array) {
            [broadcast executeWithNotification:ntf];
        }
    }
}

- (void)addBroadcastFileInDir:(NSString *)dir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *bundleDirectory = [fileManager contentsOfDirectoryAtPath:dir error:nil];

    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.route'"];
    for (NSString *filename in [bundleDirectory filteredArrayUsingPredicate:filter]) {
        [self addBroadcastFile:[dir stringByAppendingPathComponent:filename]];
    }
}

- (void)addBroadcastFile:(NSString *)path {
    NSString *content = [[NSString alloc] initWithContentsOfFile:path
                                                        encoding:NSUTF8StringEncoding
                                                           error:NULL];
    [content enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSRange range = [line rangeOfString:@"//"];
        NSString *contentLine = nil;
        if (range.location == NSNotFound) {
            contentLine = line;
        } else {
            NSRange preRange;
            preRange.location = 0;
            preRange.length = range.location;
            contentLine = [line substringWithRange:preRange];
        }
        if (contentLine != nil && ![contentLine isEqualToString:@""]) {
            MYBroadcast *broadcast = [MYBroadcast parseRouteFileLine:contentLine];
            if (broadcast != nil)
                [self addBroadcast:broadcast];
        }
    }];
    [content release];
}

- (void)addBroadcast:(MYBroadcast *)broadcast {
    NSMutableArray *array = [self.BroadcastList valueForKey:broadcast.name];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
        (self.BroadcastList)[broadcast.name] = array;
        [self registerNotification:broadcast];
    }
    [array addObject:broadcast];
}
#pragma mark - getter
- (NSMutableDictionary *)BroadcastList {
    if (_broadcastList == nil)
        _broadcastList = [[NSMutableDictionary alloc] initWithCapacity:0];
    return _broadcastList;
}
@end
