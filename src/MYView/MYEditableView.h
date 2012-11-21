//
//  MYEditableView.h
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef kKeyboardShowViewTag
    #define kKeyboardShowViewTag 1100
#endif
@interface MYEditableView : UIView
@property (retain, nonatomic) UIView *keyboardShowView;
@property (retain, nonatomic) UIView *keyboardView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *valueLabel;

- (void)initUI;
- (void)addKeyboardToShowView;
- (void)active;
@end
