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
- (void)checkbox:(MYInputField *)checkbox didInputValue:(NSObject *)value;


- (BOOL)inputFieldShouldBeginEditing:(MYInputField *)inputField;        // return NO to disallow editing.

- (void)inputFieldDidBeginEditing:(MYInputField *)inputField;           // became first responder

- (BOOL)inputFieldShouldEndEditing:(MYInputField *)inputField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

- (BOOL)inputField:(MYInputField *)inputField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)inputFieldShouldClear:(MYInputField *)inputField;               // called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)inputFieldShouldReturn:(MYInputField *)inputField;              // called when 'return' key pressed. return NO to ignore.
@end
