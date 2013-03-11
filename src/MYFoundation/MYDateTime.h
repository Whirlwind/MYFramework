//
//  MYDateTime.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-10.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDateTime : NSObject <NSCopying>
@property (retain, nonatomic) NSDate *NSDate;

- (id)initWithString:(NSString *)dateString;
- (id)initWithNSDate:(NSDate *)date;

- (BOOL)isEqualToDate:(id)date;

+ (id)dateWithNSDate:(NSDate *)date;
+ (id)dateWithString:(NSString *)dateString;

+ (id)dateWithObject:(NSObject *)object;
@end
