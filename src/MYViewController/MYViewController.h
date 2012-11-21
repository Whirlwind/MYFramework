//
//  MYViewController.h
//  ONE
//
//  Created by Whirlwind James on 11-9-20.
//  Copyright 2011 BOOHEE. All rights reserved.
//

@class MYView;
@class MYNavigationController;
//#import "UIViewController+GuideImageView.h"
//#import "UIViewController+ViewCounter.h"



@interface MYViewController: UIViewController {
    BOOL subViewDidLoaded;
    BOOL dataDidLoaded;
}
@property (retain) NSMutableArray *threadPool;

@property (nonatomic, retain) MYNavigationController *myNavigationController;
@property (nonatomic, assign) BOOL keyboardIsOpened;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, assign) NSInteger viewZIndex;
@property (nonatomic, retain) NSMutableArray *subViewControllers;

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

#pragma mark - view controller
- (BOOL)isTopViewController;
- (void)viewControllerBecomeTopViewController:(BOOL)isPush;
- (void)viewControllerResignTopViewController:(BOOL)isPush;
- (void)backNavigationController;
- (NSUInteger)indexInNavigationControllerStack;
- (MYViewController *)prevViewController;
- (MYViewController *)nextViewController;
- (void)addSubViewController:(MYViewController *)childController;

#pragma mark - keyboard
- (void)keyboardWillShowNotification:(NSNotification *)ntf;
- (void)keyboardDidHideNotification:(NSNotification *)ntf;

#pragma mark - animation
- (void)enterWithAnimated:(BOOL)animated prevViewController:(MYViewController *)prevViewController direction:(BOOL)isPush sender:(id)sender complete:(void (^)(void))block;
- (void)exitWithAnimated:(BOOL)animated
      nextViewController:(MYViewController *)nextViewController
                                  direction:(BOOL)isPush
                                     sender:(id)sender
                                   complete:(void (^)(void))block;
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




