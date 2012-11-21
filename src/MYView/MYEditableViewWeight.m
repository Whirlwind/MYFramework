//
//  MYEditableViewWeight.m
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableViewWeight.h"

#ifndef kWeightDefaultMaxValue
    #define kWeightDefaultMaxValue 100
#endif

#ifndef kWeightDefaultMinValue
    #define kWeightDefaultMinValue 30
#endif
@implementation MYEditableViewWeight

- (void)dealloc {
    [_weightPickerView release], _weightPickerView = nil;
    [super dealloc];
}

- (void)initUI {
    [super initUI];
    [self.titleLabel setText:@"体重"];
    [self setKeyboardView:self.weightPickerView];
}

- (ValueCheckBoxView *)weightPickerView {
    if (_weightPickerView == nil) {
        _weightPickerView = [[ValueCheckBoxView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        [_weightPickerView setDelegate:self];
        [_weightPickerView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_weightPickerView setIncreaseValuePerCell:1];
        [_weightPickerView setMaxValue:kWeightDefaultMaxValue];
        [_weightPickerView setMinValue:kWeightDefaultMinValue];
        [_weightPickerView updateUnits:[NSArray arrayWithObject:@"kg"]];
        [_weightPickerView updateSelectedUnitIndex:0];
    }
    return _weightPickerView;
}

#pragma mark - override
- (void)setKeyboardShowView:(UIView *)keyboardShowView {
    [super setKeyboardShowView:keyboardShowView];
    [self.weightPickerView setFrame:CGRectMake(0, self.keyboardShowView.frame.size.height - self.weightPickerView.frame.size.height, self.keyboardShowView.frame.size.width, self.weightPickerView.frame.size.height)];
}

- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    if ([self.weightPickerView selectedValue] != weight) {
        [self.weightPickerView updateSelectedValue:weight];
    }
}

#pragma mark - delegate
- (void)checkBox:(ValueCheckBoxView *)checkBox didChangedValue:(CGFloat)value {
    self.valueLabel.text = [NSString stringWithFormat:@"%@ kg", [NSNumber numberWithFloat:value]];
    [self setWeight:value];
}
@end
