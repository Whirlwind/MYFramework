//
//  MYEditableViewWeight.h
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//
#import "ValueCheckBoxView.h"
#import "MYEditableView.h"

@interface MYEditableViewWeight : MYEditableView <ValueCheckBoxViewDelegate>
@property (retain, nonatomic) ValueCheckBoxView *weightPickerView;
@property (assign, nonatomic) CGFloat weight;
@end
