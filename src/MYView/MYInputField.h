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

@property (nonatomic, retain) UIView *validView;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UIView *inputKeyboard;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, copy) NSString *unitString;
@property (nonatomic, copy) NSString *stringWhenEmpty;
@property (nonatomic, retain) NSStringValid *validPredicate;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL showValidErrorVisual;
@property (nonatomic, assign) id<MYInputFieldDelegate> checkBoxDelegate;
@property (nonatomic, retain) UIView *inputKeyboardAccessoryView;

@property (nonatomic, retain) NSObject *value;

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
