//
//  MYInputFieldText.m
//  food
//
//  Created by apple on 12-9-3.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldText.h"

@implementation MYInputFieldText

- (void)setValue:(NSObject *)value {
    [self.inputField setText:(NSString *)value];
    [super setValue:value];
}

- (UITextField *)initialiseInputField{
    UITextField *textField = (UITextField *)[super initialiseInputField];
    [textField setReturnKeyType:UIReturnKeyDone];
    return textField;
}

@end
