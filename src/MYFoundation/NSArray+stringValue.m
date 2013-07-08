//
//  NSArray+stringValue.m
//  Pods
//
//  Created by Whirlwind on 13-6-20.
//
//

#import "NSArray+stringValue.h"

@implementation NSArray (stringValue)
- (NSString *)stringValue {
    return [NSString stringWithFormat:@"[%@]", [self componentsJoinedByString:@", "]];
}
@end
