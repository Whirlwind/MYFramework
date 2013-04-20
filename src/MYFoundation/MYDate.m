//
//  MYDate.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-10.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDate.h"

@implementation MYDate

- (id)initWithNSDate:(NSDate *)date {
    if (self = [self init]) {
        self.NSDate = [date date];
    }
    return self;
}

- (NSString *)description {
    return [self.NSDate strftime:kMYDateFormat];
}

@end
