//
//  MYDateTime.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-10.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDateTime.h"

@implementation MYDateTime

- (id)initWithString:(NSString *)dateString {
    return [self initWithNSDate:[NSDate dateFromString:dateString]];
}

- (id)initWithNSDate:(NSDate *)date {
    if (self = [self init]) {
        self.NSDate = date;
    }
    return self;
}

- (BOOL)isEqualToDate:(id)date {
    if (![date isKindOfClass:[self class]]) {
        return NO;
    }
    return [self.NSDate isEqualToDate:[date NSDate]];
}

- (NSString *)description {
    return [self.NSDate strftime:kMYDateTimeFormat];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    [copy setNSDate:[self.NSDate copy]];
    return copy;
}
#pragma mark - class methods
+ (id)dateWithNSDate:(NSDate *)date {
    if (date == nil) {
        return nil;
    }
    return [[[self class] alloc] initWithNSDate:date];
}

+ (id)dateWithString:(NSString *)dateString {
    if (dateString == nil) {
        return nil;
    }
    return [[[self class] alloc] initWithString:dateString];
}

+ (id)dateWithObject:(NSObject *)object {
    if ([object isKindOfClass:[NSString class]]) {
        return [self dateWithString:(NSString *)object];
    } else if ([object isKindOfClass:[NSDate class]]) {
        return [self dateWithNSDate:(NSDate *)object];
    }
    return nil;
}
@end
