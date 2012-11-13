//
//  MYViewController.m
//  ONE
//
//  Created by Whirlwind James on 11-9-20.
//  Copyright 2011 BOOHEE. All rights reserved.
//

#import "MYViewController.h"
#import "MYFramework.h"
#import "CGRectAdditions.h"

#ifndef LOGPAGEVIEWBEGIN
#define LOGPAGEVIEWBEGIN 
#define LOGPAGEVIEWEND
#endif
@implementation MYViewController

#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    if ([self.myNavigationController topViewController] == self) {
        return;
    }
    if (subViewDidLoaded) {
        [self releaseSubViews];
    } else if (dataDidLoaded) {
        [self releaseReloadableData];
    }
    [super didReceiveMemoryWarning];
}
- (void)releaseSubViews{
    subViewDidLoaded = NO;
    [self setSubViewControllers:nil];
}
- (void)releaseReloadableData {
    dataDidLoaded = NO;
}
-(void)dealloc{
	while (_threadPool != nil && [_threadPool count]>0) {
		NSThread *thread = (NSThread *)[_threadPool objectAtIndex:0];
		[thread cancel];
		[_threadPool removeObject:thread];
	}
    [self releaseSubViews];
    [self releaseReloadableData];
	[_threadPool release], _threadPool = nil;
    [_myNavigationController release], _myNavigationController = nil;
	[super dealloc];
}

#pragma mark - init
- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initData];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self initData];
    }
    return self;
}

#pragma mark - data
- (void)initData{
    self.viewZIndex = 0;
    [self reloadData];
}

- (void)reloadData{
    dataDidLoaded = YES;
}

- (void)reloadDataAndReflashView {
    [self reloadDataAndReflashView:YES];
}

- (void)reloadDataAndReflashView:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reflashView:animated];
        });
    });
}

#pragma mark - getter
- (NSMutableArray *)subViewControllers {
    if (_subViewControllers == nil)
        _subViewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    return _subViewControllers;
}

#pragma mark - view controller
- (BOOL)isTopViewController {
    return [self.myNavigationController topViewController] == self;
}

- (void)viewControllerBecomeTopViewController:(BOOL)isPush{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewControllerResignTopViewController:(BOOL)isPush{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)backNavigationController{
    [self.myNavigationController popViewControllerAnimated:YES];
}

- (NSUInteger)indexInNavigationControllerStack{
    return [self.myNavigationController.viewControllers indexOfObject:self];
}

- (MYViewController *)prevViewController {
    return [self.myNavigationController.viewControllers objectAtIndex:[self indexInNavigationControllerStack] - 1];
}

- (MYViewController *)nextViewController {
    return [self.myNavigationController.viewControllers objectAtIndex:[self indexInNavigationControllerStack] + 1];
}

- (void)addSubViewController:(MYViewController *)childController {
    if (childController.viewZIndex >= ((MYViewController *)[self.subViewControllers lastObject]).viewZIndex) {
        [self.subViewControllers addObject:childController];
        [self.view addSubview:childController.view];
        return;
    }
    NSUInteger i = 0;
    for (MYViewController *vc in self.subViewControllers) {
        if (vc.viewZIndex > childController.viewZIndex) {
            [self.subViewControllers insertObject:vc atIndex:i];
            [self.view insertSubview:childController.view aboveSubview:vc.view];
            return;
        }
        i++;
    }
}

#pragma mark - view
- (void)viewDidLoad{
    [self.myView updateRelatedViewController:self];
    [self.myView configView];
    if (!dataDidLoaded) {
        [self reloadData];
    }
    subViewDidLoaded = YES;
    [super viewDidLoad];

    POST_ROUTE;

    if ([UIScreen mainScreen].bounds.size.height == 568.0f && self.view.frame.size.height == 460.0f)
        [self.view setFrameWithHeight:568.0f];


    [self reflashView:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    POST_ROUTE;
    [super viewWillAppear:animated];
    LOGPAGEVIEWBEGIN([[self class] description]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    POST_ROUTE;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LOGPAGEVIEWEND([[self class] description]);
    POST_ROUTE;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    POST_ROUTE;
}

- (void)reflashView {
    [self reflashView:YES];
}
- (void)reflashView:(BOOL)animated {
    
}

- (MYView *)myView {
    if ([self.view isKindOfClass:[MYView class]]) {
        return (MYView *)[self view];
    }
    return nil;
}
#pragma mark - IB event
- (IBAction)backAction:(id)sender {
    [self backNavigationController];
}
// 隐藏键盘
- (IBAction)cancelKeyboard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - keyboard
- (void)keyboardWillShowNotification:(NSNotification *)ntf{
    self.keyboardIsOpened = YES;
    self.keyboardRect = [[[ntf userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    POST_ROUTE;
}
- (void)keyboardDidHideNotification:(NSNotification *)ntf{
    self.keyboardIsOpened = NO;
    self.keyboardRect = CGRectZero;
    POST_ROUTE;
}

#pragma mark - animation
- (void)enterWithAnimated:(BOOL)animated prevViewController:(MYViewController *)prevViewController direction:(BOOL)isPush sender:(id)sender complete:(void (^)(void))block {
    [self.myNavigationController.contentView addSubview:self.view];
}

- (void)exitWithAnimated:(BOOL)animated
      nextViewController:(MYViewController *)nextViewController
               direction:(BOOL)isPush
                  sender:(id)sender
                complete:(void (^)(void))block {
    [self.view removeFromSuperview];
}
#pragma mark - Thread
- (NSMutableArray *)getThreadPool{
    if (self.threadPool == nil) {
        self.threadPool = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    }
    return self.threadPool;
}
- (NSThread *)addCurrentThreadToThreadPool:(NSString *)threadName{
	NSThread *curThread = [self addCurrentThreadToThreadPool];
	[curThread setName:threadName];
	return curThread;
}
- (NSThread *)addCurrentThreadToThreadPool{
	NSThread *curThread = [NSThread currentThread];
	[[self getThreadPool] addObject:curThread];
	return curThread;
}

#pragma mark - ios 兼容
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self presentModalViewController:viewControllerToPresent animated:flag];
    }
}
- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        [super dismissViewControllerAnimated:flag completion:completion];
    } else {
        [self dismissModalViewControllerAnimated:flag];
    }
}

#pragma mark - route support

+ (void)pushIntoMyNavigationController:(NSNotification *)ntf {
    MYViewController *vc = [[[self class] alloc] init];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [((MYNavigationController *)window.rootViewController) pushViewController:vc animated:YES sender:nil];
    [vc release];
}
@end

