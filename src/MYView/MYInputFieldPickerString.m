//
//  MYInputFieldPickerString.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPickerString.h"
#import "IXPickerOverlayView.h"

@implementation MYInputFieldPickerString

- (void)dealloc {
    [_source release], _source = nil;
    [_picker release], _picker = nil;
    [super dealloc];
}
#pragma mark - 重载
- (void)initData{
    [super initData];
}

- (UITextField *)initialiseInputField {
    UITextField *field = [super initialiseInputField];
    [field setClearButtonMode:UITextFieldViewModeNever];
    [field setHidden:YES];
    return field;
}
- (UIView *)initialiseInputKeyboard {
    self.picker = [[[UIPickerView alloc] init] autorelease];
    [self.picker setDataSource:self];
    [self.picker setDelegate:self];
    [self.picker setShowsSelectionIndicator:YES];

    UIView *pannel = [[UIView alloc] initWithFrame:self.picker.bounds];
    [pannel addSubview:self.picker];

//    IXPickerOverlayView *overlay = [[IXPickerOverlayView alloc] init];
//    [overlay setHostPickerView:self.picker];
//    [overlay setNeedsLayout];
//    [pannel addSubview:overlay];
//    [overlay release];

    return [pannel autorelease];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.source count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.source[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setValue:self.source[row]];
}

- (void)setValue:(NSObject *)value {
    if ([value isKindOfClass:[NSString class]]) {
        [self.inputField setText:(NSString *)value];
        [super setValue:value];
        NSInteger index = [self.source indexOfObject:value];
        if (index != NSNotFound) {
            [self.picker selectRow:index inComponent:0 animated:YES];
        }
    }
}
@end
