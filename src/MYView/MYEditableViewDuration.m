//
//  MYEditableViewDuration.m
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-21.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableViewDuration.h"

#ifndef kDurationDefaultMaxValue
#define kDurationDefaultMaxValue 120
#endif

#ifndef kDurationDefaultMinValue
#define kDurationDefaultMinValue 0
#endif
@implementation MYEditableViewDuration

- (void)dealloc {
    [_minutePickerView release], _minutePickerView = nil;
    [super dealloc];
}

- (void)initUI {
    [super initUI];
    [self.titleLabel setText:@"时长"];
    [self setKeyboardView:self.minutePickerView];
}

- (ValueCheckBoxView *)minutePickerView {
    if (_minutePickerView == nil) {
        _minutePickerView = [[ValueCheckBoxView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        [_minutePickerView setDelegate:self];
        [_minutePickerView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_minutePickerView setIncreaseValuePerCell:10];
        [_minutePickerView setMaxValue:kDurationDefaultMaxValue];
        [_minutePickerView setMinValue:kDurationDefaultMinValue];
        [_minutePickerView updateUnits:@[@"分钟"]];
        [_minutePickerView updateSelectedUnitIndex:0];
    }
    return _minutePickerView;
}

#pragma mark - override
- (void)setKeyboardShowView:(UIView *)keyboardShowView {
    [super setKeyboardShowView:keyboardShowView];
    [self.minutePickerView setFrame:CGRectMake(0, self.keyboardShowView.frame.size.height - self.minutePickerView.frame.size.height, self.keyboardShowView.frame.size.width, self.minutePickerView.frame.size.height)];
}

- (void)setMinute:(NSInteger)minute {
    _minute = minute;
    if ((NSInteger)[self.minutePickerView selectedValue] != minute) {
        [self.minutePickerView updateSelectedValue:minute];
    }
}

#pragma mark - delegate
- (void)checkBox:(ValueCheckBoxView *)checkBox didChangedValue:(CGFloat)value {
    self.valueLabel.text = [NSString stringWithFormat:@"%@ 分钟", @(value)];
    [self setMinute:(NSInteger)value];
}
@end