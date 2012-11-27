//
//  MYRouteCenter.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYRouteCenter.h"
#import "MYRoute.h"

static MYRouteCenter *_sharedRouteCenter = nil;
static dispatch_once_t _sharedRouteCenterPred;

@implementation MYRouteCenter

+ (id)sharedInstant {
    dispatch_once(&_sharedRouteCenterPred, ^{ _sharedRouteCenter = [[[self class] alloc] init]; });
    return _sharedRouteCenter;
}

+ (void)release {
    [_sharedRouteCenter release], _sharedRouteCenter = nil;
}

+ (void)addFileInBundle {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [[self sharedInstant] addFileInDir:bundlePath];
}

+ (NSString *)extendString {
    return @".route";
}

+ (Class)modelClass {
    return [MYRoute class];
}
- (void)dealloc {
    [_list release], _list = nil;
    [super dealloc];
}

- (void)addFileInDir:(NSString *)dir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *bundleDirectory = [fileManager contentsOfDirectoryAtPath:dir error:nil];

    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self ENDSWITH '%@'", [[self class] extendString]]];
    for (NSString *filename in [bundleDirectory filteredArrayUsingPredicate:filter]) {
        [self addFile:[dir stringByAppendingPathComponent:filename]];
    }
}

- (void)addFile:(NSString *)path {
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
            MYRoute *route = [[[self class] modelClass] parseFileLine:contentLine];
            if (route != nil)
                [self add:route];
        }
    }];
    [content release];
}

- (void)add:(MYRoute *)route {
    [self.list setValue:route forKey:route.name];
}

- (id)callRoute:(NSString *)name userInfo:(NSDictionary *)userInfo {
    MYRoute *route = [self.list valueForKey:name];
    if (route == nil) {
        NSArray *nameArray = [name componentsSeparatedByString:@"/"];
        NSRange range;
        range.location = 1;
        range.length = [nameArray count] - 1;
        name = [NSString stringWithFormat:@"*/%@", [[nameArray subarrayWithRange:range] componentsJoinedByString:@"/"]];
        route = [self.list valueForKey:name];
    }
    return [route executeWithUserInfo:userInfo];
}
#pragma mark - getter
- (NSMutableDictionary *)list {
    if (_list == nil)
        _list = [[NSMutableDictionary alloc] initWithCapacity:0];
    return _list;
}
@end
