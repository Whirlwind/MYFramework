//
//  MYInputFieldCellPhone.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-4.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYInputFieldCellPhone.h"

@implementation MYInputFieldCellPhone

#pragma mark - 重载
- (void)changeToNumberKeyboard{
    [super changeToNumberKeyboard];
    [self.validPredicate addPredicateString:kNSStringValidCellphonePredicate];
}

@end
