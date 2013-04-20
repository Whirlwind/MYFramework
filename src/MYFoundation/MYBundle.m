//
//  MYBundle.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-4.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYBundle.h"

static NSString *myBundleName = nil;
@implementation MYBundle

+ (NSString *)bundleName {
    return myBundleName;
}

+ (void)changeBundleName:(NSString *)name {
    myBundleName = name;
}

+ (NSString *)resource:(NSString *)name {
    if ([self bundleName] == nil) {
        return name;
    } else {
        return [NSString stringWithFormat:@"%@/%@", [self bundleName], name];
    }
}

+ (UIImage *)image:(NSString *)name {
    return [UIImage imageNamed:[self resource:[NSString stringWithFormat:@"images/%@", name]]];
}
@end
