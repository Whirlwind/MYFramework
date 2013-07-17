//
//  UIView+MoveView.h
//  Pods
//
//  Created by Whirlwind on 13-7-17.
//
//

#import <UIKit/UIKit.h>

@interface UIView (MoveView)

- (void)moveToTargetView:(UIView *)targetView
             targetFrame:(CGRect)targetFrame
              overWindow:(UIView *)overWindow
                duration:(NSTimeInterval)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              animations:(void (^)(void))animations
              completion:(void(^)(UIView *movedView, UIView *superView))block;

- (void)moveToTargetView:(UIView *)targetView
             targetFrame:(CGRect)targetFrame
                duration:(NSTimeInterval)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              completion:(void(^)(UIView *movedView, UIView *superView))block;
@end
