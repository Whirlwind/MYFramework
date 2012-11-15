//
//  CGRectAdditions.m
//  food
//
//  Created by Whirlwind James on 11-11-8.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//
#import "CGRectAdditions.h"

@implementation UIView (CustomFrame)
- (CGRect)setFrameWithX:(CGFloat)x{
    return [self setFrameWithX:x Y:self.frame.origin.y];
}
- (CGRect)setFrameWithX:(CGFloat)x Y:(CGFloat)y{
    return [self setFrameWithOrigin:CGPointMake(x, y)];
}
- (CGRect)setFrameWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    [self setFrame:CGRectMake(x, y, width, height)];
    return self.frame;
}
- (CGRect)setFrameWithY:(CGFloat)y{
    return [self setFrameWithX:self.frame.origin.x Y:y];
}
- (CGRect)setFrameWithWidth:(CGFloat)width{
    return [self setFrameWithWidth:width Height:self.frame.size.height];
}
- (CGRect)setFrameWithWidth:(CGFloat)width Height:(CGFloat)height{
    return [self setFrameWithSize:CGSizeMake(width, height)];
}
- (CGRect)setFrameWithHeight:(CGFloat)height{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
    return self.frame;
}

- (CGRect)setFrameWithOrigin:(CGPoint)origin{
    return [self setFrameWithOrigin:origin Size:self.frame.size];
}
- (CGRect)setFrameWithSize:(CGSize)size{
    return [self setFrameWithOrigin:self.frame.origin Size:size];
}
- (CGRect)setFrameWithOrigin:(CGPoint)origin Size:(CGSize)size{
    [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
    return self.frame;
}

@end