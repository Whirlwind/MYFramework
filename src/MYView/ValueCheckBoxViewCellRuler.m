//
//  ValueCheckBoxViewCellRuler.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-12-18.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ValueCheckBoxViewCellRuler.h"
#ifndef kValueCheckBoxViewCellSmallLineLength
#   define kValueCheckBoxViewCellSmallLineLength 15.0f
#endif
#ifndef kValueCheckBoxViewCellBigLineLength
#   define kValueCheckBoxViewCellBigLineLength 32.0f
#endif
#ifndef kValueCheckBoxViewCellLineColor
#   define kValueCheckBoxViewCellLineColor [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1]
#endif
#ifndef kValueCheckBoxViewCellLineWidth
#   define kValueCheckBoxViewCellLineWidth 1.0f
#endif

@implementation ValueCheckBoxViewCellRuler

- (id)initWithFrame:(CGRect)frame splitNumber:(NSInteger)splitNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        self.splitNumber = splitNumber;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    CGFloat startY = 0.0f;
    NSInteger lineNumber = 0;
    if (self.splitNumber % 2 != 0) { // 奇数
        startY = self.frame.size.height / (self.splitNumber * 2.0f);
        lineNumber = self.splitNumber;
    } else { // 偶数
        startY = 0.0f;
        lineNumber = self.splitNumber + 1;
    }

    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, kValueCheckBoxViewCellLineColor.CGColor);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, kValueCheckBoxViewCellLineWidth);

    CGFloat height = self.frame.size.height / self.splitNumber;
    for (NSInteger i = 0; i < lineNumber; i++) {
        CGFloat length = i == (lineNumber - 1) / 2 ? kValueCheckBoxViewCellBigLineLength : kValueCheckBoxViewCellSmallLineLength;
        CGFloat y = startY + (i * height);

        CGContextMoveToPoint(context, self.frame.size.width - length, y); //start at this point
        CGContextAddLineToPoint(context, self.frame.size.width, y); //draw to this point
        CGContextStrokePath(context);
    }
    [super drawRect:rect];
}

@end
