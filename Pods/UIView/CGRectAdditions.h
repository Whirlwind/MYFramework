//
//  CGRectAdditions.h
//  food
//
//  Created by Whirlwind James on 11-11-8.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

#define CGRectMakeWithSize(size) CGRectMake(0.0, 0.0, size.width, size.height)
#define CGRectMakeWithPointAndSize(point, size) CGRectMake(point.x, point.y, size.width, size.height)

@interface UIView (CustomFrame)
- (CGRect)setFrameWithX:(CGFloat)x;
- (CGRect)setFrameWithX:(CGFloat)x Y:(CGFloat)y;
- (CGRect)setFrameWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;
- (CGRect)setFrameWithY:(CGFloat)y;
- (CGRect)setFrameWithWidth:(CGFloat)width;
- (CGRect)setFrameWithWidth:(CGFloat)width Height:(CGFloat)height;
- (CGRect)setFrameWithHeight:(CGFloat)height;

- (CGRect)setFrameWithOrigin:(CGPoint)origin;
- (CGRect)setFrameWithSize:(CGSize)size;
- (CGRect)setFrameWithOrigin:(CGPoint)origin Size:(CGSize)size;
@end