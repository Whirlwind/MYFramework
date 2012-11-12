//
//  MYRouteCenter.m
//  ONE
//
//  Created by Whirlwind on 12-10-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYRouteCenter.h"

static MYRouteCenter *_sharedRouteCenter = nil;

static dispatch_once_t _sharedRouteCenterPred;

@implementation MYRouteCenter
+ (id)sharedRouteCenter {
    dispatch_once(&_sharedRouteCenterPred, ^{ _sharedRouteCenter = [[[self class] alloc] init]; });
    return _sharedRouteCenter;
}

+ (void)release {
    [_sharedRouteCenter release], _sharedRouteCenter = nil;
}

- (void)dealloc {
    for (NSString *routeName in [self.routeList allKeys]) {
        [self unregisterNotification:routeName];
    }
    [_routeList release], _routeList = nil;
    [super dealloc];
}
- (void)registerNotification:(MYRoute *)route {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callRoute:)
                                                 name:route.name
                                               object:nil];
}

- (void)unregisterNotification:(NSString *)routeName {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:routeName
                                                  object:nil];
}

- (void)callRoute:(NSNotification *)ntf {
    NSArray *array = [self.routeList valueForKey:ntf.name];
    if (array == nil)
        return;
    for (MYRoute *route in array) {
        [route executeWithNotification:ntf];
    }
}

- (void)addRouteFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"route"];
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
            MYRoute *route = [MYRoute parseRouteFileLine:contentLine];
            if (route != nil)
                [self addRoute:route];
        }
    }];
    [content release];
}

- (void)addRoute:(MYRoute *)route {
    NSMutableArray *array = [self.routeList valueForKey:route.name];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
        [self.routeList setObject:array forKey:route.name];
        [self registerNotification:route];
    }
    [array addObject:route];
}
#pragma mark - getter
- (NSMutableDictionary *)routeList {
    if (_routeList == nil)
        _routeList = [[NSMutableDictionary alloc] initWithCapacity:0];
    return _routeList;
}
@end