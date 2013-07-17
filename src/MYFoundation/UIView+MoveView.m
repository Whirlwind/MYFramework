//
//  UIView+MoveView.m
//  Pods
//
//  Created by Whirlwind on 13-7-17.
//
//

#import "UIView+MoveView.h"

@implementation UIView (MoveView)

- (void)moveToTargetView:(UIView *)targetView
             targetFrame:(CGRect)targetFrame
              overWindow:(UIView *)overWindow
                duration:(NSTimeInterval)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              animations:(void (^)(void))animations
              completion:(void(^)(UIView *movedView, UIView *superView))block {
    self.frame = [self.superview convertRect:self.frame toView:overWindow];
    [overWindow addSubview:self];
    __weak UIView *movedView = self;
    __weak UIView *targetView1 = targetView;
    CGRect overFrame = [targetView convertRect:targetFrame toView:overWindow];
    [UIView animateWithDuration:duration
                          delay:delay
                        options:options
                     animations:^{
                         movedView.frame = overFrame;
                         if (animations) {
                             animations();
                         }
                     }
                     completion:^(BOOL finished) {
                         movedView.frame = targetFrame;
                         [targetView addSubview:movedView];
                         if (block) block(movedView, targetView1);
                     }];
}

- (void)moveToTargetView:(UIView *)targetView
             targetFrame:(CGRect)targetFrame
                duration:(NSTimeInterval)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              completion:(void(^)(UIView *movedView, UIView *superView))block {
    [self moveToTargetView:targetView targetFrame:targetFrame
                overWindow:[[[[UIApplication sharedApplication] delegate] window] rootViewController].view
                  duration:duration
                     delay:delay
                   options:options
                animations:NULL
                completion:block];
}
@end
