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

/*  动画工厂，用于控制push和pop的切换动画 */
@property (retain, nonatomic) id<MYNavigationControllerAnimationFactoryProtocol> animationFactory;

/*  VC堆栈 */
@property (nonatomic, retain) NSMutableArray *viewControllers;


- (id)initWithRootViewController:(id<MYViewControllerDelegate>)viewController;

/*  获取VC堆栈的第一个VC */
- (id<MYViewControllerDelegate>)rootViewController;

/*  获取VC堆栈的最后一个VC */
- (id<MYViewControllerDelegate>)topViewController;

/*  切换根VC
 *  @warning 如果当前堆栈层级大于1，将不会出现UI变化，即animated被忽略。
 */
- (void)setRootViewController:(id<MYViewControllerDelegate>)vc animated:(BOOL)animated;

/*  将整个VC堆栈清空，然后重新设置根VC */
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

/*  返回到指定VC */
- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                     sender:(id)sender;
- (void)popToClass:(Class)className
          animated:(BOOL)animated
            sender:(id)sender;

/*  清空除了根VC外的所有VC */
- (void)popToRootViewControllerWithAnimated:(BOOL)animated;
- (void)popToRootViewControllerWithAnimated:(BOOL)animated
                                    sender:(id)sender;

/*  将堆栈顶的VC替换为新的VC，原VC将会被释放 */
- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated;
- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender;

#pragma mark - override
/*  VC堆栈的栈顶元素改变时将会被调用，一般用于重载 */
- (void)viewControllerWillChangeTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController;
- (void)viewControllerDidChangedTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController;
@end
