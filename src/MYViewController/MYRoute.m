//
//  MYRoute.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
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
              path:(NSString *)path {
    if (self = [self init]) {
        self.name = name;
        self.path = path;
    }
    return self;
}

- (id)executeWithNotification:(NSNotification *)ntf {
    NSArray *array = [self.path componentsSeparatedByString:@"/"];
    if ([array count] != 2)
        return nil;
    NSObject *target = [[[NSClassFromString(array[0]) alloc] init] autorelease];
    SEL selector = NSSelectorFromString(array[1]);
    if (![target respondsToSelector:selector]) {
        return nil;
    }
    return [target performSelector:selector withObject:ntf];
}

+ (id)parseFileLine:(NSString *)line {
    line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
    line = [line stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSArray *array = [line componentsSeparatedByString:@","];
    if ([array count] < 2)
        return nil;
    NSString *name = array[0];
    NSString *path = array[1];
    MYRoute *route = [[[self class] alloc] initWithName:name
                                                   path:path];
    return [route autorelease];
}

@end
