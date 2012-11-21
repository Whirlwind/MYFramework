//
//  MYEditableView.m
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableView.h"

@implementation MYEditableView
- (void)dealloc {
    [_titleLabel release], _titleLabel = nil;
    [_valueLabel release], _valueLabel = nil;
    [_keyboardView release], _keyboardView = nil;
    [_keyboardShowView release], _keyboardShowView = nil;
    [super dealloc];
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width / 2.0f - 10.0f, self.frame.size.height)];
    [self addSubview:_titleLabel];
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f, 10, self.frame.size.width / 2.0f - 10.0f, self.frame.size.height)];
    [_valueLabel setTextAlignment:UITextAlignmentRight];
    [self addSubview:_valueLabel];
}

#pragma mark - public methods
- (void)active {
    UIView *otherKeyboard = [self.keyboardShowView viewWithTag:kKeyboardShowViewTag];
    if (otherKeyboard != self.keyboardView) {
        [otherKeyboard removeFromSuperview];
        [self addKeyboardToShowView];
    }
}

- (void)addKeyboardToShowView {
    [self.keyboardShowView addSubview:self.keyboardView];
}

#pragma mark - setter
- (void)setKeyboardShowView:(UIView *)keyboardShowView {
    if (_keyboardView == nil) {
        [self setKeyboardView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, keyboardShowView.frame.size.width, keyboardShowView.frame.size.height)] autorelease]];
    }
    [_keyboardShowView release];
    _keyboardShowView = [keyboardShowView retain];
}

- (void)setKeyboardView:(UIView *)keyboardView {
    [_keyboardView release];
    _keyboardView = [keyboardView retain];
    [_keyboardView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_keyboardView setTag:kKeyboardShowViewTag];
}
@end
