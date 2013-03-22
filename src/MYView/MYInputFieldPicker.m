//
//  MYInputFieldPicker.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPicker.h"

@implementation MYInputFieldPicker

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.inputField];
    [_inputLabel release], _inputLabel = nil;
    [super dealloc];
}

- (void)initUI{
    [super initUI];
    [self insertSubview:self.inputLabel atIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputFieldValueChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.inputField];

}

- (UILabel *)initialiseInputLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [label setTextAlignment:UITextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:16];
    [label setBackgroundColor:[UIColor clearColor]];
    return [label autorelease];
}

- (UITextField *)initialiseInputField{
    UITextField *field = [super initialiseInputField];
    [field setBackgroundColor:[UIColor clearColor]];
    [field setBorderStyle:UITextBorderStyleLine];
    [field setHidden:YES];
    [field addTarget:self action:@selector(inputFieldValueChanged:) forControlEvents:UIControlEventValueChanged];
    return field;
}

#pragma mark - getter
- (UILabel *)inputLabel{
    if (_inputLabel == nil) {
        _inputLabel = [[self initialiseInputLabel] retain];
    }
    return _inputLabel;
}

#pragma mark - event
- (void)inputFieldValueChanged:(NSNotification *)ntf{
    [self.inputLabel setText:self.inputField.text];
}

@end
