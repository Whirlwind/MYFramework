//
//  MYNavigationController.h
//  iNice
//
//  Created by Whirlwind James on 12-6-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//
#import "MYViewController.h"
#import "MYNavigationControllerAnimationFactoryProtocol.h"

@interface MYNavigationController : MYViewController
@property (retain, nonatomic) id<MYNavigationControllerAnimationFactoryProtocol> animationFactory;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (id)initWithRootViewController:(id<MYViewControllerDelegate>)viewController;

- (id<MYViewControllerDelegate>)rootViewController;
- (id<MYViewControllerDelegate>)topViewController;

- (void)setRootViewController:(id<MYViewControllerDelegate>)vc animated:(BOOL)animated;
- (void)setRootViewControllerWithEmptyStack:(id<MYViewControllerDelegate>)vc animated:(BOOL)animated;

- (void)pushViewController:(id<MYViewControllerDelegate>)vc
                  animated:(BOOL)animated;
- (void)pushViewController:(id<MYViewControllerDelegate>)vc
                  animated:(BOOL)animated
                    sender:(id)sender;
- (void)pushViewController:(id<MYViewControllerDelegate>)vc
            animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block;

- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated sender:(id)sender;
- (void)popViewControllerAnimationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block;


- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                     sender:(id)sender;
- (void)popToTopViewControllerWithAnimated:(BOOL)animated;
- (void)popToTopViewControllerWithAnimated:(BOOL)animated
                                    sender:(id)sender;

- (void)popToClass:(Class)className
          animated:(BOOL)animated
            sender:(id)sender;

- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated;
- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender;

#pragma mark - override

- (void)viewControllerWillChangeTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController;
- (void)viewControllerDidChangedTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController;
@end
