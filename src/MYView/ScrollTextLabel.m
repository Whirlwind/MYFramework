//
//  ScrollTextLabel.m
//  inice
//
//  Created by Whirlwind James on 12-8-11.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ScrollTextLabel.h"

@implementation ScrollTextLabel
@synthesize label = _label;
@synthesize maxScrollWidth = _maxScrollWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.label];
}
- (void)updateView {
    if (self.maxScrollWidth > 0) {
        if (self.label.frame.size.width < self.maxScrollWidth) {
            [self setFrameWithWidth:self.label.frame.size.width];
        } else {
            [self setFrameWithWidth:self.maxScrollWidth];
        }
    }
    [self.label setCenter:CGPointMake(self.label.center.x, self.frame.size.height/2.0f)];
    [self setScrollEnabled:self.label.frame.size.width > self.frame.size.width];
}
- (void)setText:(NSString *)text {
    [self.label setText:text];
    [self.label sizeToFit];
    [self setContentSize:CGSizeMake(self.label.frame.size.width, self.frame.size.height)];
    [self updateView];
}

- (NSString *)text {
    return self.label.text;
}

- (void)setMaxWidth:(CGFloat)maxWidth {
    _maxScrollWidth = maxWidth;
    [self updateView];
}
- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor blackColor]];
    }
    return _label;
}
@end
