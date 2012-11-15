//
//  NSDate+Extend.m
//  food
//
//  Created by Whirlwind James on 12-2-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)
#pragma mark - format date to string
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}
- (NSString *)strftime:(NSString *)format{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:format];
    NSString *localDate = [formatter stringFromDate:self];
    [formatter release];
    return localDate;
}

- (NSString *)stringWithFormat:(NSString *)format {
    return [self strftime:format];
}


#pragma mark - format string to date
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    if (string == nil || [string isKindOfClass:[NSNull class]])
        return nil;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [inputFormatter setDateFormat:format];
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![inputFormatter getObjectValue:&theDate forString:string range:nil error:&error]) {
        NSLog(@"ERROR! Date '%@' with '%@' could not be parsed: %@", string, format,  error);
    }
    //NSDate *date = [inputFormatter dateFromString:string];
    [inputFormatter release];
    return theDate;
}

#pragma mark - add time
- (NSDate *)addSecond:(NSInteger)sec{
    return [NSDate dateWithTimeInterval:sec sinceDate:self];
}

- (NSDate *)addMinute:(NSInteger)min{
    return [NSDate dateWithTimeInterval:60 * min sinceDate:self];
}

- (NSDate *)addHour:(NSInteger)hour{
    return [NSDate dateWithTimeInterval:60 * 60 * hour sinceDate:self];
}
- (NSDate *)addDay:(NSInteger)day{
    return [NSDate dateWithTimeInterval:60 * 60 * 24 * day sinceDate:self];
}

- (NSDate *)addWeek:(NSInteger)week{
    return [NSDate dateWithTimeInterval:60 * 60 * 24 * 7 * week sinceDate:self];
}

#pragma mark - convient methods
- (NSUInteger)year{
    NSDateComponents *yearComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    return [yearComponents year];
}
- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit) fromDate:self];
    return [weekdayComponents weekday];
}
- (NSDate *)date{
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    [mdf release];
    return midnight;
}

#pragma mark - date ago
- (NSInteger)daysSince:(NSDate *)date{
    return (int)([[self date] timeIntervalSinceDate:[date date]] / (60*60*24));
}
- (NSInteger)daysAgo {
    return (int)(([[self date] timeIntervalSinceNow] / (60*60*24) + 1) * -1);
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime
{
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:today];

    NSDate *midnight = [calendar dateFromComponents:offsetComponents];

    NSString *displayString = nil;

    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        [componentsToSubtract release];
        if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];

            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
            } else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }

    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    [displayFormatter release];
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
    return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

#pragma mark - year ago
- (NSInteger)yearAgo{
    return [[[NSDate date] date] year] - [[self date] year];
}

#pragma mark - week range
- (NSDate *)beginningOfWeek{
    // 以周日为第一天
    return [self beginningOfWeekWithFirstDay:1];
}
- (NSDate *)beginningOfWeekWithFirstDay:(NSInteger)first {
    int weekday = [self weekday] - first;
    return [self addDay: - (weekday >= 0 ? weekday : 7 + weekday)];
}
- (NSDate *)endOfWeek{
    // 以周日为第一天
    return [self endOfWeekWithFirstDay:1];
}
- (NSDate *)endOfWeekWithFirstDay:(NSInteger)first {
    int weekday = [self weekday] - first;
    return [self addDay:6 - (weekday >= 0 ? weekday : 7 + weekday)];
}

#pragma mark - combine
- (NSDate *)dateCombineTime:(NSDate *)time{
    NSString *timeString = [time stringWithFormat:@"HH:mm:SS"];
    NSString *dateString = [self stringWithFormat:@"yyyy/MM/dd"];
    return [NSDate dateFromString:[NSString stringWithFormat:@"%@ %@", dateString, timeString, nil] withFormat:@"yyyy/MM/dd HH:mm:SS"];
}
@end
