//
//  MYInputFieldPickerDate.h
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPicker.h"

@interface MYInputFieldPickerDate : MYInputFieldPicker
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *maxValue;
@property (nonatomic, strong) NSDate *minValue;
@property (nonatomic, copy) NSString *dateFormatInTextField;

- (NSDate *)dateValue;
- (UIDatePicker *)initialiseDatePicker:(UIDatePicker *)pickerView;
@end
