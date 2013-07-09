//
//  MYTextView.m
//  Pods
//
//  Created by Whirlwind on 13-7-9.
//
//

#import "MYTextView.h"
@interface UITextView ()

- (id)styleString;

@end

@implementation MYTextView

- (CGFloat)lineHeight {
    return 2.f;
}

- (id)styleString {
    return [[super styleString] stringByAppendingString:[NSString stringWithFormat:@"; line-height: %fem", [self lineHeight]]];
}

@end
