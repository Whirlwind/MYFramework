//
//  MYInputFieldPickerTime.m
//  food
//
//  Created by 詹 迟晶 on 12-6-10.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPickerTime.h"

@implementation MYInputFieldPickerTime

- (NSDate *)timeValue{
    return [self dateValue];
}

- (void)initData{
    [super initData];
    self.dateFormatInTextField = @"HH:mm";
    [self.validPredicate removePredicateString:kNSStringValidDatePredicate];
}

- (UIDatePicker *)initialiseDatePicker:(UIDatePicker *)pickerView{
    UIDatePicker *picker = [super initialiseDatePicker:pickerView];
    [picker setDatePickerMode:UIDatePickerModeTime];
    return picker;
}
@end
