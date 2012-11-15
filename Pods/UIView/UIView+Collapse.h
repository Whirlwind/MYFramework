//
//  UIView+Collapse.h
//  food
//
//  Created by James Whirlwind on 11-11-14.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface UIView (Collapse){
}
//@property (nonatomic, assign) BOOL collapseHeight;

- (void)setCollapseHeight:(BOOL)_collapse;
- (BOOL)collapseHeight;
- (void)changeHeightTo:(CGFloat)newHeight;
- (void)changeHeight:(CGFloat)oldHeight To:(CGFloat)newHeight;
+ (void)changeHeight:(UIView *)changeView oldHeight:(CGFloat)oldHeight newHeight:(CGFloat)newHeight;
@end
