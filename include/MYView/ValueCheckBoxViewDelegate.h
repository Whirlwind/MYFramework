//
//  ValueCheckBoxViewDelegate.h
//  iNice
//
//  Created by Whirlwind James on 12-8-7.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ValueCheckBoxView;
@protocol ValueCheckBoxViewDelegate <NSObject>
@optional
- (BOOL)checkBox:(ValueCheckBoxView *)checkBox shouldChangeUnitFrom:(NSObject *)from to:(NSObject *)to;
- (void)checkBox:(ValueCheckBoxView *)checkBox didChangedUnit:(NSObject *)unit;
- (void)checkBox:(ValueCheckBoxView *)checkBox didChangedValue:(CGFloat)value;
@end
