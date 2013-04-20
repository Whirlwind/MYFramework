//
//  MYInputField.h
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSStringValid.h"
#import "MYInputFieldDelegate.h"
#import "NSDate+Extend.h"

#define kCheckBoxValidChanged @"kCheckBoxValidChanged"

@interface MYInputField : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UIView *validView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *inputKeyboard;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, copy) NSString *unitString;
@property (nonatomic, copy) NSString *stringWhenEmpty;
@property (nonatomic, strong) NSStringValid *validPredicate;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL showValidErrorVisual;
@property (nonatomic, weak) id<MYInputFieldDelegate> checkBoxDelegate;
@property (nonatomic, strong) UIView *inputKeyboardAccessoryView;

@property (nonatomic, strong) NSObject *value;

- (void)updateValidResultVisual;

- (void)cancelEditing;
- (void)becameEditing;
// 用于重载
- (void)initData;
- (void)initUI;
- (UIImageView *)initialiseBackgroundImageView;
- (UITextField *)initialiseInputField;
- (UIView *)initialiseInputKeyboard;
- (BOOL)tryValid;
- (NSObject *)inputFieldValue;

@end
