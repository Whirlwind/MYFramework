//
//  MYViewControllerDelegate.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (BOOL)isTopViewController;
- (void)viewControllerBecomeTopViewController:(BOOL)isPush;
- (void)viewControllerResignTopViewController:(BOOL)isPush;
- (void)backNavigationController;
- (NSUInteger)indexInNavigationControllerStack;
- (id<MYViewControllerDelegate>)prevViewController;
- (id<MYViewControllerDelegate>)nextViewController;
- (void)addSubViewController:(id<MYViewControllerDelegate>)childController;
- (void)addSubViewController:(id<MYViewControllerDelegate>)childController view:(UIView*)__view;

#pragma mark - keyboard
- (void)keyboardWillShowNotification:(NSNotification *)ntf;
- (void)keyboardDidHideNotification:(NSNotification *)ntf;

@optional
#pragma mark - thread
- (NSMutableArray *)getThreadPool;
- (NSThread *)addCurrentThreadToThreadPool;
- (NSThread *)addCurrentThreadToThreadPool:(NSString *)threadName;

#pragma mark - IB event
- (IBAction)backAction:(id)sender;
// 隐藏键盘
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
