//
//  MYInputFieldDelegate.h
//  food
//
//  Created by 詹 迟晶 on 12-2-27.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

//#import "CustomCheckBoxView.m"
@class MYInputField;
@protocol MYInputFieldDelegate <NSObject>
@optional
- (void)checkbox:(MYInputField *)checkbox didInputValue:(NSString *)value;
@end
