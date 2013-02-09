//
//  MYInputFieldEmail.m
//  iNice
//
//  Created by Whirlwind on 12-10-19.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldEmail.h"

@implementation MYInputFieldEmail

#pragma mark - 重载
- (void)initData{
    [super initData];
    [self.validPredicate addPredicateString:kNSStringValidEmailPredicate];
}

- (UITextField *)initialiseInputField{
    UITextField *textField = (UITextField *)[super initialiseInputField];
    [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    return textField;
}
@end
