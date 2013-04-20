//
//  MYInputFieldPickerString.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-16.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYInputFieldPicker.h"

@interface MYInputFieldPickerString : MYInputFieldPicker <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *source;

@property (strong, nonatomic) UIPickerView *picker;
@end
