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

+ (NSString *)convertRailsStylePropertyToAppleStyleProperty:(NSString *)property {
    NSArray *pieces = [property componentsSeparatedByString:@"_"];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:[pieces count]] autorelease];
    [pieces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [array addObject:obj];
        } else {
            [array addObject:[obj capitalizedString]];
        }
    }];
    return [array componentsJoinedByString:@""];
}

+ (NSString *)convertAppleStylePropertyToRailsStyleProperty:(NSString *)property {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([A-Z])"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:NULL];

    NSString *s1 = [regex stringByReplacingMatchesInString:property
                                                   options:0
                                                     range:NSMakeRange(0, [property length])
                                              withTemplate:@"_$0"];
    s1 = [s1 lowercaseString];
    if ([[s1 substringToIndex:1] isEqualToString:@"_"]) {
        s1 = [s1 substringFromIndex:1];
    }
    return s1;
}
@end
