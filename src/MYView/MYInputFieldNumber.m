//
//  MYInputFieldNumber.m
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputFieldNumber.h"
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
#import "VersionString.h"
#import "NumberKeypadDecimalPoint.h"
#endif

@implementation MYInputFieldNumber

#pragma mark - dealloc
- (void)dealloc{
    [_minValue release], _minValue = nil;
    [_maxValue release], _maxValue = nil;
    [super dealloc];
}
- (NSNumber *)numberValue{
    NSString *string = [self value];
    if (string == nil || [string isEqualToString:@""]) {
        return nil;
    }
    return [NSNumber numberWithDouble:[string doubleValue]];
}
#pragma mark - 重载
- (void)initData{
    [super initData];
    [self changeToNumberKeyboard];
    [self.validPredicate addPredicateWithTarget:self selector:@selector(validMaxAndMin:state:)];
}
- (UITextField *)initialiseInputField{
    UITextField *textField = (UITextField *)[super initialiseInputField];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@"<4.1"] ) {
        hasDecimalPad = NO;
    }else {
        hasDecimalPad = YES;
    }
#endif
    isDecimal = NO;
    return textField;
}
- (void)setValue:(NSObject *)value{
    if (value != nil) {
        NSString *stringValue = nil;
        NSLog(@"value: %f", [(NSNumber *)value doubleValue]);
        if ([value isKindOfClass:[NSString class]]) {
            stringValue = (NSString *)value;
        } else {
            NSNumberFormatter *doubleValueWithMaxTwoDecimalPlaces = [[NSNumberFormatter alloc] init];
            [doubleValueWithMaxTwoDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
            [doubleValueWithMaxTwoDecimalPlaces setMaximumFractionDigits:2];
            NSNumber *myValue = (NSNumber *)value;
            stringValue = [doubleValueWithMaxTwoDecimalPlaces stringFromNumber:myValue];
            [doubleValueWithMaxTwoDecimalPlaces release];
            doubleValueWithMaxTwoDecimalPlaces = nil;
        }
        if (self.unitString == nil) {
            ((UITextField *)self.inputField).text = stringValue;
        }else{
            ((UITextField *)self.inputField).text = [NSString stringWithFormat:@"%@ %@", stringValue, self.unitString];
        }
    }
    [super setValue:value];
}

#pragma mark - keyboard
- (void)changeToDecimalKeyboard{
    isDecimal = YES;
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
    if (!hasDecimalPad)
        [self.inputField setKeyboardType:UIKeyboardTypeNumberPad];
    else
#endif
        [self.inputField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.validPredicate clearPredicateString];
    [self.validPredicate addPredicateString:kNSStringValidDecimalPredicate];
}
- (void)changeToNumberKeyboard{
    isDecimal = NO;
    [self.inputField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.validPredicate clearPredicateString];
    [self.validPredicate addPredicateString:kNSStringValidIntegerPredicate];
}
- (BOOL)isNumberKeyboard{
    return !isDecimal;
}
- (BOOL)isDecimalKeyboard{
    return isDecimal;
}

#pragma mark - valid
- (void)validMaxAndMin:(NSString *)value state:(NSMutableDictionary *)state{
    float v = [value floatValue];
    if ((self.maxValue != nil && v > [self.maxValue floatValue]) || (self.minValue != nil && v < [self.minValue floatValue])) {
        [state setValue:[NSNumber numberWithBool:NO] forKey:@"state"];
    }
}
- (void) textFieldDidBeginEditing:(UITextField*)textField {
    [super textFieldDidBeginEditing:textField];
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([self isDecimalKeyboard] && !hasDecimalPad) {
        numberKeyPad= [[NumberKeypadDecimalPoint keypadForTextField:textField] retain];
    }
#endif
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([self isDecimalKeyboard] && !hasDecimalPad) {
        [numberKeyPad removeButtonFromKeyboard];
        [numberKeyPad release];
    }
#endif
}
@end
