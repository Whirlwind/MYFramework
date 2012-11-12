//
//  MYNavigationController.h
//  iNice
//
//  Created by Whirlwind James on 12-6-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYViewController.h"

@interface MYNavigationController : MYViewController
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) UIView *contentView;

- (id)initWithRootViewController:(UIViewController *)viewController;

- (MYViewController *)topViewController;

- (void)setRootViewController:(MYViewController *)vc animated:(BOOL)animated;
- (void)setRootViewControllerWithEmptyStack:(MYViewController *)vc animated:(BOOL)animated;

- (void)pushViewController:(MYViewController *)vc
                  animated:(BOOL)animated;
- (void)pushViewController:(MYViewController *)vc
                  animated:(BOOL)animated
                    sender:(id)sender;
- (void)pushViewController:(MYViewController *)vc
            animationBlock:(void (^)(MYViewController *preVC, MYViewController *nextVC, id sender))block;

- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated sender:(id)sender;
- (void)popViewControllerAnimationBlock:(void (^)(MYViewController *preVC, MYViewController *nextVC, id sender))block;


- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                     sender:(id)sender;
- (void)popToTopViewControllerWithAnimated:(BOOL)animated;
- (void)popToTopViewControllerWithAnimated:(BOOL)animated
                                    sender:(id)sender;

- (void)popToClass:(Class)className
          animated:(BOOL)animated
            sender:(id)sender;

- (void)replaceTopViewController:(MYViewController *)vc animated:(BOOL)animated;
- (void)replaceTopViewController:(MYViewController *)vc animated:(BOOL)animated sender:(id)sender;
@end
