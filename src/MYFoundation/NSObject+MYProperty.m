//
//  NSObject+MYProperty.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "NSObject+MYProperty.h"

@implementation NSObject (MYProperty)
+ (SEL)setterFromPropertyString:(NSString *)property {
    NSString *firstCapChar = [[property substringToIndex:1] capitalizedString];
    NSString *cappedString = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", cappedString]);
}

+ (SEL)getterFromPropertyString:(NSString *)property {
    return NSSelectorFromString(property);
}
@end
