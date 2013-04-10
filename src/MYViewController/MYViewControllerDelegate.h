//
//  MYViewControllerDelegate.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 
 MYViewController的生命周期：
    在init时，调用initData, reloadData
    在ViewDidLoad中，调用reloadData(如果之前没有执行的话), reflashView
    在接收内存警告时，调用releaseSubViews, releaseReloadableData
    在内存警告后，需要重新绘制View时，会再次调用ViewDidLoad。
 
    请将可重新加载的View和Data分开在reflashView和reloadData中，并在releaseSubView和releaseReloadableData进行卸载和释放。
 */
@protocol MYViewControllerDelegate <NSObject>


@property (assign, nonatomic) NSInteger vcType;
@property (nonatomic, assign) MYNavigationController *myNavigationController;
@property (nonatomic, assign) BOOL keyboardIsOpened;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, assign) NSInteger viewZIndex;
@property (nonatomic, retain) NSMutableArray *subViewControllers;

@optional
#pragma mark - dealloc
- (void)releaseSubViews; // for override
- (void)releaseReloadableData; // for override

#pragma mark - data
- (void)initData; // for override
- (void)reloadData; // for override
- (void)reloadDataAndReflashView; // animated=YES
- (void)reloadDataAndReflashView:(BOOL)animated;

#pragma mark - view
- (void)reflashView; // animated=YES
- (void)reflashView:(BOOL)animated; // for override
- (MYView *)myView;

- (void)showLoading:(BOOL)show; // Shows views to represent the model loading.
- (void)showEmpty:(BOOL)show; // Shows views to represent an empty model.
- (void)showError:(BOOL)show; // Shows views to represent an error that occurred while loading the model.

@required
- (UIView *)view;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

@optional
#pragma mark - view controller

/*  判断当前VC是否在栈顶 */
- (BOOL)isTopViewController;

/*  当前VC成为栈顶元素时被调用
    该方法在viewDidLoad之后，viewWillAppear之前被调用
 */
- (void)viewControllerBecomeTopViewController:(BOOL)isPush;

/*  当前VC不再是栈顶元素时被调用
    该方法在viewWillDisappear之前被调用
 */
- (void)viewControllerResignTopViewController:(BOOL)isPush;

/*  返回上一级 */

- (void)backNavigationController;

/*  获取当前VC在Navigation中的序号
    不在堆栈中，则返回NSNotFound
 */
- (NSUInteger)indexInNavigationControllerStack;

/*  获取在堆栈中的前一个VC
    如果当前VC不在堆栈中，或者是RootVC，则返回nil。
 */
- (id<MYViewControllerDelegate>)prevViewController;

/*  获取在堆栈中的后一个VC
    如果当前VC不在堆栈中，或者是TopVC，则返回nil。
 */
- (id<MYViewControllerDelegate>)nextViewController;

/*  添加一个subViewController到当前VC
    该方法若在view加载之前调用，则会在view加载时统一渲染所有subView；
         若在View加载之后调用，则会立即渲染并加到View上。
    subViewController的viewZIndex属性决定视图的层次关系。
 */
- (void)addSubViewController:(id<MYViewControllerDelegate>)childController;
- (void)addSubViewController:(id<MYViewControllerDelegate>)childController view:(UIView*)__view;

#pragma mark - keyboard
/*  键盘显示和隐藏时回调，一般用于重载。*/
- (void)keyboardWillShowNotification:(NSNotification *)ntf;
- (void)keyboardDidHideNotification:(NSNotification *)ntf;

@optional
#pragma mark - thread
- (NSMutableArray *)getThreadPool;
- (NSThread *)addCurrentThreadToThreadPool;
- (NSThread *)addCurrentThreadToThreadPool:(NSString *)threadName;

#pragma mark - IB event
/*  返回上一级 */
- (IBAction)backAction:(id)sender;
/*  隐藏键盘 */
- (IBAction)cancelKeyboard:(id)sender;

#pragma mark - iOS 兼容
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion;

#pragma mark - route support
- (void)pushIntoMyNavigationController:(NSNotification *)ntf;
+ (void)pushIntoMyNavigationController:(NSNotification *)ntf;
@end
