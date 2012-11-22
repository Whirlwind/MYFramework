//
//  MYNavigationController.m
//  iNice
//
//  Created by Whirlwind James on 12-6-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYNavigationController.h"
#import "MYFramework.h"

@implementation MYNavigationController

#pragma mark - release
- (void)didReceiveMemoryWarning
{
    // Do Nothing
}

- (void)releaseSubViews{
    [_contentView release], _contentView = nil;
    [super releaseSubViews];
}

- (void)dealloc{
    [_viewControllers release], _viewControllers = nil;
    [super dealloc];
}

#pragma mark - init
- (id)initWithRootViewController:(id<MYViewControllerDelegate>)viewController {
    if (self = [self init]) {
        [self.viewControllers addObject:viewController];
        [viewController setMyNavigationController:self];
    }
    return self;
}

#pragma mark - getter
- (NSMutableArray *)viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _viewControllers;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView setContentMode:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ];
    }
    return _contentView;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    [self.contentView setFrame:self.view.bounds];
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.contentView];
    [self enterWithAnimated:NO
         nextViewController:[self.viewControllers lastObject]
                  direction:YES
                     sender:nil
                   complete:nil];
}

#pragma mark - private methods
- (void)enterWithAnimated:(BOOL)animated
       nextViewController:(id<MYViewControllerDelegate> )nextViewController
                direction:(BOOL)isPush
                   sender:(id)sender
                 complete:(void (^)(void))block {
    [self exitWithAnimated:animated
        prevViewController:nil
        nextViewController:nextViewController
                 direction:isPush
                    sender:sender
                  complete:block];
}
- (void)exitWithAnimated:(BOOL)animated
      prevViewController:(id<MYViewControllerDelegate> )prevViewController
      nextViewController:(id<MYViewControllerDelegate> )nextViewController
               direction:(BOOL)isPush
                  sender:(id)sender
                complete:(void (^)(void))block {
    if (!subViewDidLoaded) {
        return;
    }
    [prevViewController retain];
    [prevViewController viewControllerResignTopViewController:YES];
    [nextViewController view];
    [nextViewController setMyNavigationController:self];
    [nextViewController viewControllerBecomeTopViewController:YES];
    BOOL isIOS4 = [[[UIDevice currentDevice] systemVersion] integerValue] < 5;
    if (isIOS4)
        [prevViewController viewWillDisappear:animated];
    if (isIOS4)
        [nextViewController viewWillAppear:animated];
    [prevViewController exitWithAnimated:animated
                      nextViewController:nextViewController
                               direction:isPush
                                  sender:sender
                                complete:^{
                                    if (isIOS4)
                                        [prevViewController viewDidDisappear:animated];
                                    if (isIOS4)
                                        [nextViewController viewDidAppear:animated];
                                    if (block)
                                        block();
                                    [prevViewController setMyNavigationController:nil];
                                    [prevViewController release];
                                }];
    [prevViewController retain];
    [nextViewController enterWithAnimated:animated
                       prevViewController:prevViewController
                                direction:isPush
                                   sender:sender
                                 complete:^{
                                     if (isIOS4)
                                         [nextViewController viewDidAppear:animated];
                                     [prevViewController release];
                                 }];
}

#pragma mark - controller
- (id<MYViewControllerDelegate> )topViewController {
    if ([self.viewControllers count] == 0) {
        return nil;
    }
    return [self.viewControllers lastObject];
}
- (void)setRootViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated{
    if ([self.viewControllers count] <= 1) {
        [self pushViewController:vc
                        animated:animated];
    } else {
        [self.viewControllers insertObject:vc atIndex:1];
    }
    if ([self.viewControllers count] > 1) {
        [self.viewControllers removeObjectAtIndex:0];
    }
}
- (void)setRootViewControllerWithEmptyStack:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated {
    [self setRootViewControllerWithEmptyStack:vc animated:animated sender:nil];
}

- (void)setRootViewControllerWithEmptyStack:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    if ([self.viewControllers count] == 0) {
        [self.viewControllers addObject:vc];
        [self enterWithAnimated:animated
             nextViewController:vc
                      direction:YES
                         sender:sender
                       complete:nil];
    } else {
        id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
        [self.viewControllers removeAllObjects];
        [self.viewControllers addObject:vc];

        [self exitWithAnimated:animated prevViewController:[last autorelease]nextViewController:vc direction:YES sender:sender complete:nil];
    }
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated{
    [self pushViewController:vc animated:animated sender:nil];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    [self pushViewController:vc
                      sender:sender
              animationBlock:^(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender) {
                  [self exitWithAnimated:animated prevViewController:preVC nextViewController:nextVC direction:YES sender:sender complete:nil];
              }];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    [self pushViewController:vc sender:nil animationBlock:block];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc sender:(id)sender animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    id<MYViewControllerDelegate> last = [self.viewControllers lastObject];
    [self.viewControllers addObject:vc];
    block(last, vc, sender);
}

- (void)popToTopViewControllerWithAnimated:(BOOL)animated {
    [self popToTopViewControllerWithAnimated:animated sender:nil];
}

- (void)popToTopViewControllerWithAnimated:(BOOL)animated sender:(id)sender {
    if ([self.viewControllers count] < 2)
        return;
    NSRange range;
    range.location = 1;
    range.length = [self.viewControllers count] - 2;
    if (range.length > 0) {
        [self.viewControllers removeObjectsInRange:range];
    }
    [self popViewControllerAnimated:animated sender:sender];
}

- (void)popToViewControllerWithBlock:(BOOL (^)(UIViewController *))block
                            animated:(BOOL)animated
                              sender:(id)sender{
    NSInteger i = [self.viewControllers count] - 1;
    for (; i >= 0; i--) {
        UIViewController *vc = (self.viewControllers)[i];
        if (block(vc)) {
            break;
        }
    }
    if (i < 0) {
        return;
    }
    if (i < [self.viewControllers count] - 2) {
        NSRange range;
        range.location = i + 1;
        range.length = [self.viewControllers count] - i - 2;
        if (range.length > 0) {
            [self.viewControllers removeObjectsInRange:range];
        }
    }
    [self popViewControllerAnimated:animated sender:sender];
}

- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                     sender:(id)sender{
    [self popToViewControllerWithBlock:^ BOOL (UIViewController *vc) {
        return vc == viewController;
    }
                              animated:animated
                                sender:sender];
}
- (void)popToClass:(Class)className
          animated:(BOOL)animated
            sender:(id)sender{
    [self popToViewControllerWithBlock:^ BOOL (UIViewController *vc) {
        return [vc isKindOfClass:className];
    }
                              animated:animated
                                sender:sender];
}
- (void)popViewControllerAnimated:(BOOL)animated{
    [self popViewControllerAnimated:animated sender:nil];
}

- (void)popViewControllerAnimated:(BOOL)animated sender:(id)sender{
    [self popViewControllerBySender:sender
                     animationBlock:^(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender) {
                         [self exitWithAnimated:animated
                             prevViewController:preVC
                             nextViewController:nextVC
                                      direction:NO
                                         sender:sender
                                       complete:nil];
                     }];
}

- (void)popViewControllerAnimationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    [self popViewControllerBySender:nil animationBlock:block];
}

- (void)popViewControllerBySender:(id)sender animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    if (self.viewControllers.count <= 1) {
        return;
    }
    id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
    [self.viewControllers removeLastObject];
    block([last autorelease], [self.viewControllers lastObject], sender);
}

- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated {
    [self replaceTopViewController:vc animated:animated sender:nil];
}
- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
    if (last) {
        [self.viewControllers removeObject:last];
    }
    [self.viewControllers addObject:vc];
    [self exitWithAnimated:animated
        prevViewController:[last autorelease]
        nextViewController:vc
                 direction:YES
                    sender:sender
                  complete:nil];
}
@end
