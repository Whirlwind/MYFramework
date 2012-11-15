//
//  NSDate+Extend.h
//  food
//
//  Created by Whirlwind James on 12-2-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//



@interface NSDate (Extend)
/** @name format date to string */
/** 格式化时间
 *
 *  输出格式化的时间字符串。格式字符串：yyyy/MM/dd HH:mm:ss Z
 *  @param  格式字符串：yyyy/MM/dd HH:mm:ss Z
 *  @return 根据格式字符串格式的时间
 */
- (NSString *)strftime:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;

/** @name format date to string */
/** 将时间字符串转换为时间
 *
 *  @param  string 用于转换的时间字符串
 *  @param  format 所给的时间字符串的格式
 *  @return 返回时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

#pragma mark - convient methods
- (NSUInteger)weekday;
- (NSDate *)date;

#pragma mark - add time
- (NSDate *)addSecond:(NSInteger)sec;
- (NSDate *)addMinute:(NSInteger)min;
- (NSDate *)addHour:(NSInteger)hour;
- (NSDate *)addDay:(NSInteger)day;
- (NSDate *)addWeek:(NSInteger)week;

#pragma mark - date ago
- (NSInteger)daysSince:(NSDate *)date;
- (NSInteger)daysAgo;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

#pragma mark - year ago
- (NSInteger)yearAgo;

#pragma mark - week range
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfWeekWithFirstDay:(NSInteger)first;
- (NSDate *)endOfWeek;
- (NSDate *)endOfWeekWithFirstDay:(NSInteger)first;

#pragma mark - combine
- (NSDate *)dateCombineTime:(NSDate *)time;
@end
