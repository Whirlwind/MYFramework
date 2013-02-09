//
//  MYInputFieldNumber.h
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputField.h"

#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
@class NumberKeypadDecimalPoint;
#endif

@interface MYInputFieldNumber : MYInputField{
    BOOL isDecimal;
#if __IPHONE_4_1 > __IPHONE_OS_VERSION_MIN_REQUIRED
    BOOL hasDecimalPad;
    NumberKeypadDecimalPoint*numberKeyPad;
#endif
}
@property (nonatomic, retain) NSNumber *minValue;
@property (nonatomic, retain) NSNumber *maxValue;
- (void)changeToDecimalKeyboard;
- (void)changeToNumberKeyboard;
- (BOOL)isNumberKeyboard;
- (BOOL)isDecimalKeyboard;

- (NSNumber *)numberValue;
@end
