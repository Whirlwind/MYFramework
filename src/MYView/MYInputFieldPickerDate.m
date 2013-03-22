//
//  MYInputFieldPickerDate.m
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPickerDate.h"

@implementation MYInputFieldPickerDate
@synthesize datePicker = _datePicker;
@synthesize maxValue = _maxValue;
@synthesize minValue = _minValue;
@synthesize dateFormatInTextField = _dateFormatInTextField;
#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_maxValue release], _maxValue = nil;
    [_minValue release], _minValue = nil;
    [_datePicker release], _datePicker = nil;
    [_dateFormatInTextField release], _dateFormatInTextField = nil;
    [super dealloc];
}
#pragma mark - init
- (void)initData{
    [super initData];
    self.dateFormatInTextField = @"yyyy'-'MM'-'dd";
    [self.validPredicate addPredicateString:kNSStringValidDatePredicate];
    [self.validPredicate addPredicateWithTarget:self selector:@selector(validMaxAndMin:state:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDatePicker:) name:UIKeyboardWillShowNotification object:nil];
}

- (NSDate *)dateValue{
    NSString *string = [self value];
    if (string == nil || [string isEqualToString:@""]) {
        return nil;
    }
    return [NSDate dateFromString:string withFormat:self.dateFormatInTextField];
}

#pragma mark - initView
- (UIView *)initialiseInputKeyboard{
    UIView *keyboard = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 216.0)];
    [keyboard addSubview:self.datePicker];
    return [keyboard autorelease];
}
- (UIDatePicker *)initialiseDatePicker:(UIDatePicker *)pickerView{
    if (pickerView == nil) {
        pickerView = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 216.0)] autorelease];
    }
    [pickerView setDatePickerMode:UIDatePickerModeDate];
    [pickerView setMaximumDate:self.maxValue];
    [pickerView setMinimumDate:self.minValue];
    [pickerView addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    return pickerView;
}
#pragma mark - getter
- (UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[self initialiseDatePicker:nil] retain];
    }
    return _datePicker;
}

- (void)setMaxValue:(NSDate *)maxValue{
    [_maxValue release];
    _maxValue = [maxValue retain];
    [_datePicker setMaximumDate:_maxValue];
}
- (void)setMinValue:(NSDate *)minValue{
    [_minValue release];
    _minValue = [minValue retain];
    [_datePicker setMinimumDate:_minValue];
}
#pragma mark - valid
- (void)validMaxAndMin:(NSString *)value state:(NSMutableDictionary *)state{
    NSDate *v = [NSDate dateFromString:value withFormat:self.dateFormatInTextField];
    if ((self.maxValue != nil && [self.maxValue timeIntervalSinceDate:v] < 0) || (self.minValue != nil && [self.minValue timeIntervalSinceDate:v] > 0)) {
        [state setValue:[NSNumber numberWithBool:NO] forKey:@"state"];
    }
}

#pragma mark - event
- (void)dateDidChange:(id)sender{
    [self setValue:self.datePicker.date];
}

#pragma mark - keyboard
- (void)updateDatePicker:(NSNotification *)aNotification{
    if (![self.inputField isFirstResponder]) {
        return;
    }
    NSString *string = [self value];
    if (string != nil && ![string isEqualToString:@""]) {
        NSDate *date = [NSDate dateFromString:string withFormat:self.dateFormatInTextField];
        if (date != nil) {
            [self.datePicker setDate:date animated:NO];
        }
    }
}
#pragma mark - override
- (void)setValue:(NSObject *)value{
    NSDate *date = (NSDate *)value;
    self.inputField.text = [date stringWithFormat:self.dateFormatInTextField];
    [super setValue:value];
}
@end
