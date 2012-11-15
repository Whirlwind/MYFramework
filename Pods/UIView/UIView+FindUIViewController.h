//
//  UIView+FindUIViewController.h
//  food
//
//  Created by 詹 迟晶 on 12-2-23.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//
//  快速通过一个View查找它的Controller



@interface UIView (FindUIViewController)
/** 获取当前view的controller
 *
 *  @return 当找不到controller时，返回nil
 */
- (UIViewController *) parentViewController;
- (id) traverseResponderChainForUIViewController;
@end
